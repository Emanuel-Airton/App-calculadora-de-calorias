import 'dart:async';

import 'package:app_calorias_diarias/auth/domain/models/auth_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<AuthModel?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        debugPrint('null');
        return null;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credentials = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credentials);
      debugPrint('currentUser id: ${_auth.currentUser?.uid.toString()}');
      debugPrint('currentUser email: ${_auth.currentUser?.email.toString()}');

      AuthModel authUserModel = AuthModel.fromJson(
        userName: _auth.currentUser?.displayName,
        userEmail: _auth.currentUser?.email,
        photoUrl: _auth.currentUser?.photoURL,
        userId: _auth.currentUser?.uid,
      );
      //debugPrint(authUserModel.toJson().toString());
      return authUserModel;
    } catch (e) {
      debugPrint('exception-> $e ');
      throw Exception('Erro ao fazer login com sua conta Google');
    }
  }

  Stream<User?> listenAuth() {
    return _auth.authStateChanges();
  }

  Future signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      if (_auth.currentUser == null) {
        debugPrint('usuario deslogado');
      }
    } catch (e) {
      debugPrint('erro ao sair: $e');
    }
  }
}
