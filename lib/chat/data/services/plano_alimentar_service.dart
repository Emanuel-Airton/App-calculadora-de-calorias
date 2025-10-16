import 'package:app_calorias_diarias/chat/domain/models/plano_alimentar_model.dart';
import 'package:hive/hive.dart';

class PlanoAlimentarService {
  final Box<PlanoAlimentar> box;

  PlanoAlimentarService(this.box);

  // Salvar plano alimentar
  Future<void> salvarPlano(PlanoAlimentar plano) async {
    await box.put('plano_alimentar', plano);
  }

  // Obter plano alimentar
  PlanoAlimentar? obterPlano() {
    return box.get('plano_alimentar');
  }

  // Verificar se existe plano salvo
  bool existePlano() {
    return box.containsKey('plano_alimentar');
  }

  // Remover plano
  Future<void> removerPlano() async {
    await box.delete('plano_alimentar');
  }
}
