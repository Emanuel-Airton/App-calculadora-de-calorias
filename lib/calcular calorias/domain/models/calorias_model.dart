import 'package:hive/hive.dart';

@HiveType(typeId: 4)
class CaloriasModel {
  @HiveField(0)
  int? caloriasTotais;
  @HiveField(1)
  int? caloriasConsumidas;
  @HiveField(2)
  int? taxaMetabolismoBasal;

  CaloriasModel({
    this.caloriasTotais,
    this.caloriasConsumidas,
    this.taxaMetabolismoBasal,
  });

  CaloriasModel.dados({
    this.caloriasTotais,
    this.caloriasConsumidas,
    this.taxaMetabolismoBasal,
  });
  factory CaloriasModel.fromMap(Map map) {
    return CaloriasModel.dados(
      caloriasTotais: map['caloriasTotais'],
      caloriasConsumidas: map['caloriasConsumidas'],
      taxaMetabolismoBasal: map['taxaMetabolismoBasal'],
    );
  }

  factory CaloriasModel.fromJson({
    required int caloriasTotais,
    required int caloriasConsumidas,
    required int taxaMetabolismoBasal,
  }) {
    return CaloriasModel.dados(
      caloriasTotais: caloriasTotais,
      caloriasConsumidas: caloriasConsumidas,
      taxaMetabolismoBasal: taxaMetabolismoBasal,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'caloriasTotais': caloriasTotais,
      'caloriasConsumidas': caloriasConsumidas,
      'taxaMetabolismoBasal': taxaMetabolismoBasal,
    };
  }
}

class CaloriasModelAdapter extends TypeAdapter<CaloriasModel> {
  @override
  CaloriasModel read(BinaryReader reader) {
    // TODO: implement read
    return CaloriasModel.fromMap(reader.readMap());
  }

  @override
  // TODO: implement typeId
  int get typeId => 4;

  @override
  void write(BinaryWriter writer, CaloriasModel obj) {
    writer.writeMap(obj.toMap());
  }
}
