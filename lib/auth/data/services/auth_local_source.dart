import 'package:app_calorias_diarias/auth/domain/models/auth_user_model.dart';
import 'package:app_calorias_diarias/chat/domain/models/plano_alimentar_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AuthLocalSourceService {
  Box<AuthUserModel> box;
  AuthLocalSourceService(this.box);

  Future<void> salvar(AuthModel user) async {
    // await box.put('user_profile', user);
    await box.put(user.userId, user.authUserModel!);
  }

  Future<void> atualizarCaloriasPlano({
    required String userId,
    int? caloriasConsumidas,
  }) async {
    final authUserModel = await obterDadosUsuario(userId);
    authUserModel?.caloriasModel?.caloriasConsumidas = caloriasConsumidas;
    authUserModel?.save();
  }

  Future<void> adicionarPlanoAlimentar(
    String userId,
    PlanoAlimentar planoAlimentar,
  ) async {
    final authUserModel = await obterDadosUsuario(userId);
    authUserModel?.planoAlimentar = planoAlimentar;
    authUserModel?.save();
  }

  Future<AuthUserModel?> obterDadosUsuario(String userId) async {
    if (!box.isOpen) {
      box = await Hive.openBox<AuthUserModel>('userProfile');
    }

    AuthUserModel? authUserModel = box.get(userId);
    debugPrint(
      'teste obtendo dados do usuario: ${authUserModel?.macronutrientesDiarios?.toJson().toString()}',
    );
    return authUserModel;
  }

  //Atualiza a refeição especifica com o valor passado
  Future<void> atualizarRefeicaoPlano(
    String userId,
    String nomeRefeicao,
    bool valorSelecionado,
    double porcentagemConsumida,
  ) async {
    final dadosUsuarios = await obterDadosUsuario(userId);
    dadosUsuarios!.planoAlimentar!.porcentagemConsumida = porcentagemConsumida;
    for (var element in dadosUsuarios.planoAlimentar!.listRefeicao!) {
      if (element.nomeRefeicao == nomeRefeicao) {
        element.refeicaoFeita = valorSelecionado;

        debugPrint('refeição encontrada');

        debugPrint(element.toMap().toString());
        dadosUsuarios.save();
      }
    }
  }

  Future<void> remover() async {
    await box.delete('user_profile');

    if (!box.keys.contains(box)) {
      debugPrint(box.toString());

      debugPrint('caixa deletada');
    }
  }

  Future<void> limparECorrigirDados() async {
    await box.clear();
    box.close();
    // Agora salve os dados novamente com a estrutura correta
  }

  Future<void> fecharCaixa() async {
    if (box.isOpen) {
      try {
        await box.close();
        debugPrint('caixa fechada');
      } catch (e) {
        debugPrint('erro: $e');
        throw Exception(e);
      }
    }
  }
}
