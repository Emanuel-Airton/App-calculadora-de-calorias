import 'package:app_calorias_diarias/auth/domain/models/auth_user_model.dart';
import 'package:app_calorias_diarias/chat/domain/models/macronutrientes.dart';
import 'package:app_calorias_diarias/utils/result.dart';
import 'package:flutter/material.dart';

class CalcularCaloriasService {
  //  final ChatModel _chatModel = ChatModel();
  // CalcularCaloriasService(this._chatModel);
  Future<Result<int?>> calcularTMB(AuthUserModel authUserModel) async {
    try {
      await Future.delayed(Duration(seconds: 1));
      if (authUserModel.genero == 'masculino') {
        //throw Exception('erro de genero');
        return Result.ok(
          (88.362 +
                  (13.397 * authUserModel.peso!) +
                  (4.799 * authUserModel.altura!) -
                  (5.677 * authUserModel.idade!))
              .round(),
        );
      } else {
        return Result.ok(
          (447.593 +
                  (9.247 * authUserModel.peso!) +
                  (3.098 * authUserModel.altura!) -
                  (4.330 * authUserModel.idade!))
              .round(),
        );
      }
    } on Exception catch (exception) {
      return Result.error(exception);
    }
  }

  Result<int> calcularCaloriasDiarias(int tmb, AuthUserModel authUserModel) {
    try {
      double fatorAtividade;
      switch (authUserModel.nivelAtividade) {
        case 'Sedentário':
          fatorAtividade = 1.2;
          break;
        case 'Levemente ativo':
          fatorAtividade = 1.375;
          break;
        case 'Moderadamente ativo':
          fatorAtividade = 1.55;
          break;
        case 'Muito ativo':
          fatorAtividade = 1.725;
          break;
        case 'Extremamente ativo':
          fatorAtividade = 1.9;
          break;
        default:
          fatorAtividade = 1.2;
      }

      double calorias = tmb * fatorAtividade;
      //debugPrint('calorias calculadas: ${calorias.toString()}');
      if (authUserModel.objetivo == 'Emagrecer') {
        return Result.ok(((calorias * 0.8) / 100).round() * 100); // Reduz 20%
      } else if (authUserModel.objetivo == 'Ganhar massa') {
        final cal = ((calorias * 1.2) / 100).round() * 100;
        // debugPrint(cal.toString());
        return Result.ok(((calorias * 1.2) / 100).round() * 100); // Aumenta 20%
      } else {
        return Result.ok(calorias.round()); // Manter peso
      }
    } on Exception catch (exception) {
      return Result.error(exception);
    }
  }

  MacronutrientesModel calcularMacros({
    required AuthUserModel authUserModel,
    required int calorias,
  }) {
    double proteinas, carboidratos, gorduras;
    switch (authUserModel.objetivo) {
      case 'Emagrecer':
        proteinas = authUserModel.peso! * 2.0;
        carboidratos = (calorias * 0.35) / 4; // 1g de carb = 4kcal
        gorduras = (calorias * 0.25) / 9; // 1g de gordura = 9kcal

        break;
      case 'Ganhar massa':
        proteinas = authUserModel.peso! * 2.0;
        carboidratos = (authUserModel.peso! * 5);
        gorduras = (authUserModel.peso! * 1.2);
        break;
      default:
        proteinas = authUserModel.peso! * 1.5;
        carboidratos = (calorias * 0.45) / 4;
        gorduras = (calorias * 0.30) / 9;
    }
    final consumoAgua = calcularConsumoAgua(authUserModel);
    return MacronutrientesModel.fromJson(
      carboidratos: carboidratos,
      proteinas: proteinas,
      gorduras: gorduras,
      calorias: calorias,
      consumoAgua: consumoAgua,
    );
  }

  double calcularConsumoAgua(AuthUserModel authUserModel) {
    final double consumoAgua;
    switch (authUserModel.nivelAtividade) {
      case 'Sedentário':
      case 'Levemente ativo':
        consumoAgua = authUserModel.peso! * 35;
        break;
      case 'Moderadamente ativo':
        consumoAgua = (authUserModel.peso! * 40) / 1000;
        debugPrint('consumo de agua: ${consumoAgua.toString()}');
        break;
      case 'Muito ativo':
      case 'Extremamente ativo':
        consumoAgua = authUserModel.peso! * 45;
        break;
      default:
        consumoAgua = authUserModel.peso! * 35;
    }
    return consumoAgua.roundToDouble();
  }
}
