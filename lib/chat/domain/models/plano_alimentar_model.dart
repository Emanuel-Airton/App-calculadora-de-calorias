import 'package:app_calorias_diarias/chat/domain/models/refeicao_model.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 2)
class PlanoAlimentar extends HiveObject {
  @HiveField(0)
  List<RefeicaoModel>? listRefeicao;

  PlanoAlimentar({this.listRefeicao});
  factory PlanoAlimentar.fromJson(Map<String, dynamic> map) {
    List list = map['plano_alimentar'] as List;
    return PlanoAlimentar(
      listRefeicao: list.map((map) => RefeicaoModel.fromJson(map)).toList(),
    );
  }
  // Método para criar a partir de Map
  factory PlanoAlimentar.fromMap(Map<dynamic, dynamic> map) {
    return PlanoAlimentar(
      listRefeicao: map['listRefeicao'] != null
          ? (map['listRefeicao'] as List)
                .map((e) => RefeicaoModel.fromJson(e))
                .toList()
          : null,
    );
  }

  // Método para converter para Map
  Map<String, dynamic> toMap() {
    return {
      'listRefeicao': listRefeicao
          ?.map((refeicao) => refeicao.toMap())
          .toList(),
    };
  }
}

// Adaptador manual para PlanoAlimentar
class PlanoAlimentarAdapter extends TypeAdapter<PlanoAlimentar> {
  @override
  final int typeId = 2;

  @override
  PlanoAlimentar read(BinaryReader reader) {
    return PlanoAlimentar.fromMap(reader.readMap());
  }

  @override
  void write(BinaryWriter writer, PlanoAlimentar obj) {
    writer.writeMap(obj.toMap());
  }
}
