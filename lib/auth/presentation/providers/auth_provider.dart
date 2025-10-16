import 'dart:async';
import 'package:app_calorias_diarias/auth/data/services/auth_local_source.dart';
import 'package:app_calorias_diarias/auth/data/services/google_auth_service.dart';
import 'package:app_calorias_diarias/auth/domain/models/auth_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AuthProvider extends ChangeNotifier {
  final GoogleAuthService _googleAuthService;

  // User? _user;
  //  User? get user => _user;
  StreamSubscription<User?>? _authSubscription;

  AuthModel? _authModel;
  AuthModel? get authModel => _authModel;

  AuthProvider.listen({GoogleAuthService? googleAuth})
    : _googleAuthService = googleAuth ?? GoogleAuthService() {
    _listen();
  }

  _listen() {
    _authSubscription = _googleAuthService.listenAuth().listen((event) {
      //  _user = event;
      _authModel = AuthModel(
        photoUrl: event?.photoURL,
        userEmail: event?.email,
        userName: event?.displayName,
      );
      //debugPrint('teste: ${_authUserModel?.userName}');
      notifyListeners();
    }, onError: (error) {});
  }

  Future<void> signInWithGoogle() async {
    try {
      await _googleAuthService.signInWithGoogle();
    } catch (e) {
      debugPrint('Error in provider signInWithGoogle: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _googleAuthService.signOut();
  }

  @override
  void dispose() {
    _authSubscription?.cancel(); // Importante para evitar memory leaks
    super.dispose();
  }
}

class UserProfileProvider extends ChangeNotifier {
  AuthProvider _authProvider;
  AuthProvider get authProvider => _authProvider;
  AuthLocalSourceService authLocalSourceService;

  String? _genero;
  double? _peso;
  double? _altura;
  int? _idade;
  String? _nivelAtividade;
  String? _objetivo;

  // Getters
  String? get genero => _genero;
  double? get peso => _peso;
  double? get altura => _altura;
  int? get idade => _idade;
  String? get nivelAtividade => _nivelAtividade;
  String? get objetivo => _objetivo;

  UserProfileProvider(
    this._authProvider, {
    AuthLocalSourceService? authLocalSource,
  }) : authLocalSourceService =
           authLocalSource ?? AuthLocalSourceService(Hive.box('userProfile')) {
    lerAuth();
    debugPrint('email ${_authProvider.authModel?.userEmail.toString()}');
  }

  void updateFromAuth(AuthProvider newAuthProvider) {
    _authProvider = newAuthProvider;

    notifyListeners();
  }

  // Métodos para atualizar dados
  void updateProfile({
    String? genero,
    double? peso,
    double? altura,
    int? idade,
    String? nivelAtividade,
    String? objetivo,
  }) {
    //   _authProvider._authModel?.authUserModel ??= AuthUserModel.dados();
    // final authUserModel = _authProvider._authModel!.authUserModel!;

    _authProvider._authModel?.authUserModel?.genero =
        genero ?? _authProvider._authModel?.authUserModel?.genero;
    _authProvider._authModel?.authUserModel?.peso =
        peso ?? _authProvider._authModel?.authUserModel?.peso;
    _authProvider._authModel?.authUserModel?.altura =
        altura ?? _authProvider._authModel?.authUserModel?.altura;
    _authProvider._authModel?.authUserModel?.idade =
        idade ?? _authProvider._authModel?.authUserModel?.idade;
    _authProvider.authModel?.authUserModel?.nivelAtividade =
        nivelAtividade ??
        _authProvider.authModel?.authUserModel?.nivelAtividade;
    _authProvider._authModel?.authUserModel?.objetivo =
        objetivo ?? _authProvider._authModel?.authUserModel?.objetivo;
    debugPrint(
      'testando ${_authProvider._authModel?.authUserModel?.idade.toString()}',
    );
    notifyListeners();
  }

  // Converter para modelo (se necessário para serviços)
  AuthUserModel toAuthUserModel() {
    return AuthUserModel.dados(
      genero: authProvider._authModel?.authUserModel?.genero,
      peso: authProvider._authModel?.authUserModel?.peso,
      altura: authProvider._authModel?.authUserModel?.altura,
      idade: authProvider._authModel?.authUserModel?.idade,
      nivelAtividade: authProvider._authModel?.authUserModel?.nivelAtividade,
      objetivo: authProvider._authModel?.authUserModel?.objetivo,
    );
  }

  bool get hasCompleteProfile {
    return authProvider._authModel?.authUserModel?.genero != null &&
        authProvider._authModel?.authUserModel?.peso != null &&
        authProvider._authModel?.authUserModel?.altura != null &&
        authProvider._authModel?.authUserModel?.idade != null &&
        authProvider._authModel?.authUserModel?.nivelAtividade != null &&
        authProvider._authModel?.authUserModel?.objetivo != null;
  }

  void salvarAuth() {
    //authProvider._authUserModel?.toJson();
    authLocalSourceService.salvar(_authProvider._authModel!.authUserModel!);
    notifyListeners();
  }

  Future<void> lerAuth() async {
    authProvider._authModel?.authUserModel =
        authLocalSourceService.obterPlano() ??
        authProvider._authModel!.authUserModel;
    debugPrint(
      authProvider
          ._authModel
          ?.authUserModel
          ?.macronutrientesDiarios
          ?.carboidratos
          .toString(),
    );
    debugPrint(authProvider._authModel?.toJson().toString());

    //await authLocalSourceService.remover();
    notifyListeners();
  }
}
