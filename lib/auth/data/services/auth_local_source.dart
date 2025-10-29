import 'package:app_calorias_diarias/auth/domain/models/auth_user_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AuthLocalSourceService {
  final Box<AuthUserModel> box;
  AuthLocalSourceService(this.box);

  Future<void> salvar(AuthUserModel user) async {
    await box.put('user_profile', user);
  }

  Future<void> atualizarCaloriasPlano({int? caloriasConsumidas}) async {
    final authUserModel = obterPlano();
    authUserModel?.caloriasModel?.caloriasConsumidas = caloriasConsumidas;
    authUserModel?.save();
  }

  AuthUserModel? obterPlano() {
    return box.get('user_profile');
  }

  Future<void> remover() async {
    await box.delete(box);
    if (!box.keys.contains(box)) {
      debugPrint('caixa deletada');
    }
  }
}
