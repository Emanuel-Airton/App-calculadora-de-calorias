import 'package:app_calorias_diarias/chat/domain/models/plano_alimentar_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class PlanoAlimentarService {
  //final Box<PlanoAlimentar> box;
  final planoBox = Hive.box<PlanoAlimentar>('planoAlimentarBox');

  //  PlanoAlimentarService(this.box);

  // Salvar plano alimentar
  Future<void> salvarPlano(PlanoAlimentar plano) async {
    await planoBox.put('plano_alimentar', plano);
  }

  Future<void> atualizarPlano({
    String? nomeRefeicao,
    required bool valor,
    //required int caloriasConsumidas
  }) async {
    final plano = obterPlano();
    if (plano != null) {
      for (var element in plano.listRefeicao!) {
        if (element.nomeRefeicao == nomeRefeicao) {
          element.refeicaoFeita = valor;
          debugPrint('refeição encontrada');

          debugPrint(element.toMap().toString());
          plano.save();
        }
      }
    }
  }

  //Limpa a marcação de refeição feita no dia
  Future<void> resetRefeicoesFeitasPlano() async {
    final plano = obterPlano();
    if (plano?.listRefeicao != null) {
      for (var element in plano!.listRefeicao!) {
        element.refeicaoFeita = false;
        // debugPrint('refeiçoes resetadas');

        //  debugPrint(element.toMap().toString());
        plano.save();
      }
    }
  }

  // Obter plano alimentar
  PlanoAlimentar? obterPlano() {
    return planoBox.get('plano_alimentar');
  }

  // Verificar se existe plano salvo
  bool existePlano() {
    return planoBox.containsKey('plano_alimentar');
  }

  // Remover plano
  Future<void> removerPlano() async {
    await planoBox.delete('plano_alimentar');
  }
}
