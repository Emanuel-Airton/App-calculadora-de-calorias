import 'package:app_calorias_diarias/auth/data/services/auth_local_source.dart';
import 'package:app_calorias_diarias/auth/domain/models/auth_user_model.dart';
import 'package:app_calorias_diarias/auth/presentation/providers/auth_provider.dart';
import 'package:app_calorias_diarias/chat/domain/models/plano_alimentar_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

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
  Future<PlanoAlimentar?>? plano;

  UserProfileProvider(
    this._authProvider, {
    AuthLocalSourceService? authLocalSource,
  }) : authLocalSourceService =
           authLocalSource ?? AuthLocalSourceService(Hive.box('userProfile')) {
    lerAuth();
    //_authProvider.authModel?.userEmail = 'novoEmail';
    debugPrint(
      'email do usuario ${_authProvider.authModel?.userEmail.toString()}',
    );
    debugPrint('id do usuario ${_authProvider.authModel?.userId.toString()}');
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
    int? caloriasConsumidas,
  }) {
    //   _authProvider._authModel?.authUserModel ??= AuthUserModel.dados();
    // final authUserModel = _authProvider._authModel!.authUserModel!;
    _authProvider.authModel?.authUserModel?.genero =
        genero ?? _authProvider.authModel?.authUserModel?.genero;
    _authProvider.authModel?.authUserModel?.peso =
        peso ?? _authProvider.authModel?.authUserModel?.peso;
    _authProvider.authModel?.authUserModel?.altura =
        altura ?? _authProvider.authModel?.authUserModel?.altura;
    _authProvider.authModel?.authUserModel?.idade =
        idade ?? _authProvider.authModel?.authUserModel?.idade;
    _authProvider.authModel?.authUserModel?.nivelAtividade =
        nivelAtividade ??
        _authProvider.authModel?.authUserModel?.nivelAtividade;
    _authProvider.authModel?.authUserModel?.objetivo =
        objetivo ?? _authProvider.authModel?.authUserModel?.objetivo;
    _authProvider.authModel?.authUserModel?.caloriasModel?.caloriasConsumidas =
        caloriasConsumidas ??
        _authProvider
            .authModel
            ?.authUserModel
            ?.caloriasModel
            ?.caloriasConsumidas;
    debugPrint(
      'testando ${_authProvider.authModel?.authUserModel?.idade.toString()}',
    );
    if (caloriasConsumidas != null) {
      debugPrint('Contém calorias');
      authLocalSourceService.atualizarCaloriasPlano(
        userId: _authProvider.authModel!.userId!,
        caloriasConsumidas: caloriasConsumidas,
      );
    }
    notifyListeners();
  }

  // Converter para modelo (se necessário para serviços)
  AuthUserModel toAuthUserModel() {
    return AuthUserModel.dados(
      genero: authProvider.authModel?.authUserModel?.genero,
      peso: authProvider.authModel?.authUserModel?.peso,
      altura: authProvider.authModel?.authUserModel?.altura,
      idade: authProvider.authModel?.authUserModel?.idade,
      nivelAtividade: authProvider.authModel?.authUserModel?.nivelAtividade,
      objetivo: authProvider.authModel?.authUserModel?.objetivo,
    );
  }

  bool get hasCompleteProfile {
    return authProvider.authModel?.authUserModel?.genero != null &&
        authProvider.authModel?.authUserModel?.peso != null &&
        authProvider.authModel?.authUserModel?.altura != null &&
        authProvider.authModel?.authUserModel?.idade != null &&
        authProvider.authModel?.authUserModel?.nivelAtividade != null &&
        authProvider.authModel?.authUserModel?.objetivo != null;
  }

  void salvarAuth() {
    //authProvider._authUserModel?.toJson();
    authLocalSourceService.salvar(_authProvider.authModel!);
    debugPrint(
      'consumo de agua 1: ${authProvider.authModel?.authUserModel?.macronutrientesDiarios?.consumoAgua.toString()}',
    );
    notifyListeners();
  }

  //Obtem os dados do usuario salvos na memoria
  Future<void> lerAuth() async {
    debugPrint('UserId: ${authProvider.authModel?.userId}');
    authProvider.authModel?.authUserModel =
        await authLocalSourceService.obterDadosUsuario(
          authProvider.authModel!.userId!,
        ) ??
        authProvider.authModel!.authUserModel;
    notifyListeners();
  }

  Future<void> adicionarPlanoAlimentar(PlanoAlimentar planoAlimetar) async {
    await authLocalSourceService.adicionarPlanoAlimentar(
      authProvider.authModel!.userId!,
      planoAlimetar,
    );
    notifyListeners();
  }

  Future<void> closeBox() async {
    await authLocalSourceService.fecharCaixa();
  }

  Future<void> atualizarRefeicaoPlano(
    String nomeRefeicao,
    bool valorSelecionado,
    double porcentagemCalculada,
  ) async {
    await authLocalSourceService.atualizarRefeicaoPlano(
      authProvider.authModel!.userId!,
      nomeRefeicao,
      valorSelecionado,
      porcentagemCalculada,
    );
  }

  void resetCaloriasConsumidas() {
    authProvider.authModel?.authUserModel?.caloriasModel?.caloriasConsumidas =
        0;
    notifyListeners();
  }
}
