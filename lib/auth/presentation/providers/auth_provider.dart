import 'dart:async';
import 'package:app_calorias_diarias/auth/data/services/google_auth_service.dart';
import 'package:app_calorias_diarias/auth/domain/models/auth_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final GoogleAuthService _googleAuthService;

  // User? _user;
  //  User? get user => _user;
  StreamSubscription<User?>? _authSubscription;

  AuthModel? _authModel;
  AuthModel? get authModel => _authModel;

  AuthProvider.listen({GoogleAuthService? googleAuth})
    : _googleAuthService = googleAuth ?? GoogleAuthService() {
    listen();
  }
  Stream<User?> get authStream => _googleAuthService.listenAuth();

  void listen() {
    _authSubscription = authStream.listen((event) {
      //  _user = event;
      _authModel = AuthModel(
        photoUrl: event?.photoURL,
        userEmail: event?.email,
        userName: event?.displayName,
        userId: event?.uid,
      );
      notifyListeners();
    });
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
    _authModel?.photoUrl = null;
    _authModel?.userEmail = null;
    _authModel?.userName = null;
    _authModel?.userId = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel(); // Importante para evitar memory leaks
    super.dispose();
  }
}
