import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class RefeicaoModel {
  @HiveField(0)
  String? nomeRefeicao;

  @HiveField(1)
  List<String>? alimentos;

  @HiveField(2)
  Map<String, dynamic>? macros;

  RefeicaoModel({this.nomeRefeicao, this.alimentos, this.macros});
  factory RefeicaoModel.fromJson(Map<dynamic, dynamic> map) {
    return RefeicaoModel(
      nomeRefeicao: map['refeicao'],
      alimentos: map['alimentos'] != null
          ? List<String>.from(map['alimentos'])
          : null,
      macros: map['macros'] != null
          ? Map<String, dynamic>.from(map['macros'])
          : null,
    );
  }

  // Método para criar a partir de Map
  factory RefeicaoModel.fromMap(Map<String, dynamic> map) {
    return RefeicaoModel(
      nomeRefeicao: map['refeicao'],
      alimentos: map['alimentos'] != null
          ? List<String>.from(map['alimentos'])
          : null,
      macros: map['macros'] != null
          ? Map<String, dynamic>.from(map['macros'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'refeicao': nomeRefeicao,
      'alimentos': alimentos?.map((e) => e).toList(),
      'macros': macros,
    };
  }
}

// Adaptador manual para RefeicaoModel
class RefeicaoModelAdapter extends TypeAdapter<RefeicaoModel> {
  @override
  final int typeId = 1;

  @override
  RefeicaoModel read(BinaryReader reader) {
    return RefeicaoModel.fromJson(reader.readMap());
  }

  @override
  void write(BinaryWriter writer, RefeicaoModel refeicaoModel) {
    writer.writeMap(refeicaoModel.toMap());
  }
}
