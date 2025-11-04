import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 3)
class MacronutrientesModel {
  @HiveField(0)
  double? proteinas;
  @HiveField(1)
  double? carboidratos;
  @HiveField(2)
  double? gorduras;
  @HiveField(3)
  int? calorias;
  //o campo consumoAgua foi adicionado posteriormente
  @HiveField(4)
  double? consumoAgua;
  @HiveField(5)
  List<String>? listFontesCarboidratos;
  @HiveField(6)
  List<String>? listFontesProteinas;

  MacronutrientesModel({
    this.carboidratos,
    this.proteinas,
    this.gorduras,
    this.calorias,
    this.consumoAgua,
  });

  Map<String, dynamic> toMap(String objetivo) {
    return {
      'Objetivo': objetivo,
      'Proteínas totais': '${proteinas} g',
      'Carboidratos totais': '${carboidratos} g',
      'Gorduras totais': '${gorduras} g',
      'Calorias totais': '$calorias Kcal',
    };
  }

  Map<String, dynamic> toMapCarboEProteinas() {
    debugPrint(listFontesProteinas?.first.toString());
    return {
      'Fontes de carboidratos': listFontesCarboidratos ?? 'qualquer tipo',
      'Fontes de proteinas': listFontesProteinas ?? 'qualquer tipo',
    };
  }

  String messagePrompt(String objetivo) {
    return """
        Crie um plano bem elaborado com 5 refeições diárias contendo EXATAMENTE os seguintes dados:
        ${toMap(objetivo)}. Baseado nessas preferencias informadas: ${toMapCarboEProteinas()}
        REGRAS CRÍTICAS
        A SOMA EXATA de calorias de todas refeições DEVE ser EXARAMENTE igual a $calorias calorias
        A SOMA EXATA de todos os macros deve ser exatamente igual aos dados especificados.
        """;
  }

  factory MacronutrientesModel.fromJson({
    required double carboidratos,
    required double proteinas,
    required double gorduras,
    required int calorias,
    required double consumoAgua,
  }) {
    return MacronutrientesModel(
      carboidratos: carboidratos,
      proteinas: proteinas,
      gorduras: gorduras,
      calorias: calorias,
      consumoAgua: consumoAgua,
    );
  }
  factory MacronutrientesModel.fromMap({required Map readMap}) {
    return MacronutrientesModel(
      carboidratos: readMap['carboidratos'],
      proteinas: readMap['proteinas'],
      gorduras: readMap['gorduras'],
      calorias: readMap['calorias'],
      consumoAgua: readMap['consumoAgua'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'carboidratos': carboidratos,
      'proteinas': proteinas,
      'gorduras': gorduras,
      'calorias': calorias,
      'consumoAgua': consumoAgua,
    };
  }
}

class MacronutrientesModelAdapter extends TypeAdapter<MacronutrientesModel> {
  @override
  MacronutrientesModel read(BinaryReader reader) {
    // TODO: implement read
    return MacronutrientesModel.fromMap(readMap: reader.readMap());
  }

  @override
  // TODO: implement typeId
  int get typeId => 3;

  @override
  void write(BinaryWriter writer, MacronutrientesModel obj) {
    writer.writeMap(obj.toJson());
  }
}
