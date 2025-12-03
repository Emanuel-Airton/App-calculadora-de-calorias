import 'package:app_calorias_diarias/auth/domain/models/auth_user_model.dart';
import 'package:app_calorias_diarias/calcular%20calorias/data/services/calcular_calorias_service.dart';
import 'package:app_calorias_diarias/calcular%20calorias/domain/models/calorias_model.dart';
import 'package:app_calorias_diarias/chat/domain/models/macronutrientes.dart';
import 'package:app_calorias_diarias/utils/result.dart';
import 'package:flutter/material.dart';

/*class CaloriasProvider extends ChangeNotifier {
  final AuthUserModel authUserModel;
  final CalcularCaloriasService _calcularCaloriasService;

  CaloriasProvider({
    required this.authUserModel,
    CalcularCaloriasService? calcularCaliriasService,
  }) : _calcularCaloriasService =
           calcularCaliriasService ?? CalcularCaloriasService();

  int? _valorTMB;
  int? get valorTMB => _valorTMB;
  int? _caloriasTotais;
  int? get caloriasTotais => _caloriasTotais;

  int _caloriasConsumidas = 0;
  int? get caloriasConsumidas => _caloriasConsumidas;

  String? _nivelAtividade;
  String? get nivelAtividade => _nivelAtividade;
  bool isCalculate = false;

  // AuthUserModel? authUserModel = AuthUserModel();

  Future<Result?> calcularTMB() async {
    isCalculate = true;
    notifyListeners();
    final Result<int?> result = await _calcularCaloriasService.calcularTMB(
      authUserModel,
    );
    switch (result) {
      case Ok<int?>():
        _valorTMB = result.value;
        if (_valorTMB != null) {
          try {
            calcularCalorias();
          } on Exception catch (e) {
            isCalculate = false;
            notifyListeners();
            return Result.error(e);
          }
        }
        isCalculate = false;
        notifyListeners();
      case Error<int?>():
        isCalculate = false;
        notifyListeners();
    }
    return result;

    return null;
  }

  Result calcularCalorias() {
    final Result<int> result = _calcularCaloriasService.calcularCaloriasDiarias(
      _valorTMB!,
      authUserModel!,
    );
    switch (result) {
      case Ok<int>():
        _caloriasTotais = result.value;

        if (_caloriasTotais != null) {
          calcularMacros();
        }
        notifyListeners();
      case Error<int>():
        throw result.exception;
    }
    return result;
  }

  double? _porcentagem;
  double? get porcentagem => _porcentagem;

  Map<String, bool> refeicoesSelecionadas = {};
  void toggleRefeicao(String refeicao, int calorias, bool isChecked) {
    debugPrint(refeicao);
    refeicoesSelecionadas[refeicao] = isChecked;
    //debugPrint(refeicoesSelecionadas[refeicao].toString());
    if (isChecked) {
      calcularCaloriasConsumidas(calorias);
    } else {
      removerCaloriasConsumidas(calorias);
    }
    notifyListeners();
  }

  void calcularCaloriasConsumidas(int caloriasRecebidas) {
    //debugPrint(caloriasRecebidas.runtimeType.toString());
    debugPrint('calorias: $_caloriasConsumidas');
    int caloriasReserva = _caloriasConsumidas;
    _caloriasConsumidas = caloriasRecebidas + caloriasReserva;
    calcularPorcentagem();
    debugPrint('porcentagem: ${_porcentagem.toString()}');

    notifyListeners();
  }

  void removerCaloriasConsumidas(int caloriasRecebidas) {
    _caloriasConsumidas -= caloriasRecebidas;
    debugPrint('calorias: $_caloriasConsumidas');
    calcularPorcentagem();
    notifyListeners();
  }

  void calcularPorcentagem() {
    final calcular = ((_caloriasConsumidas / _caloriasTotais!) * 100)
        .roundToDouble();
    _porcentagem = calcular / 100;
    notifyListeners();
  }

  void calcularMacros() {
    authUserModel?.macronutrientesDiarios = _calcularCaloriasService
        .calcularMacros(authUserModel!, _caloriasTotais!);
    debugPrint(
      'calorias: ${authUserModel!.macronutrientesDiarios?.calorias?.toString()}',
    );
    notifyListeners();
  }
}*/
class CaloriasProvider extends ChangeNotifier {
  final CalcularCaloriasService _calcularCaloriasService;

  int? _valorTMB;
  int? get valorTMB => _valorTMB;
  int? _caloriasTotais;
  int? get caloriasTotais => _caloriasTotais;
  int _caloriasConsumidas = 0;
  int get caloriasConsumidas => _caloriasConsumidas;

  CaloriasModel? _calModel;
  CaloriasModel? get caloriasModel => _calModel;
  bool isCalculate = false;

  double? _porcentagem;
  double? get porcentagem => _porcentagem;

  Map<String, bool> refeicoesSelecionadas = {};

  MacronutrientesModel? _macronutrientesModel;
  MacronutrientesModel? get macronutrientesModel => _macronutrientesModel;

  CaloriasProvider({CalcularCaloriasService? calcularCaloriasService})
    : _calcularCaloriasService =
          calcularCaloriasService ?? CalcularCaloriasService();

  void setCaloriasConsumidas({
    required int? caloriasConsumidas,
    int? caloriasTotais,
  }) {
    _caloriasConsumidas = caloriasConsumidas ?? _caloriasConsumidas;
    _caloriasTotais = caloriasTotais ?? _caloriasTotais;
    calcularPorcentagem();
    notifyListeners();
  }

  // Agora recebe dados explicitamente
  Future<Result<int?>> calcularTMB({
    required String genero,
    required double peso,
    required double altura,
    required int idade,
    required String nivelAtividade,
    required String objetivo,
  }) async {
    isCalculate = true;
    notifyListeners();

    final userData = AuthUserModel.dados(
      genero: genero,
      peso: peso,
      altura: altura,
      idade: idade,
      nivelAtividade: nivelAtividade,
      objetivo: objetivo,
    );

    final result = await _calcularCaloriasService.calcularTMB(userData);

    switch (result) {
      case Ok<int?>():
        _valorTMB = result.value;
        /*debugPrint(
          'nivel de atifidade fisica: ${userData.nivelAtividade.toString()}',
        );*/
        // debugPrint('taxaMetabolismoBasal: ${_valorTMB.toString()}');
        if (_valorTMB != null) calcularCalorias(userData);

      case Error<int?>():
        // Tratar erro
        throw result.exception;
    }

    isCalculate = false;
    notifyListeners();
    return result;
  }

  Result calcularCalorias(AuthUserModel authUserModel) {
    final Result<int> result = _calcularCaloriasService.calcularCaloriasDiarias(
      _valorTMB!,
      authUserModel,
    );
    switch (result) {
      case Ok<int>():
        _caloriasTotais = result.value;

        if (_caloriasTotais != null) {
          calcularMacros(authUserModel: authUserModel);
          teste();
        }
        notifyListeners();
      case Error<int>():
        throw result.exception;
    }
    return result;
  }

  void alternarRefeicao({
    required String nomeRefeicao,
    required bool iselect,
    required int calorias,
    required int caloriasTotais,
  }) {
    refeicoesSelecionadas[nomeRefeicao] = iselect;
    if (iselect) {
      adicionarCaloriasConsumidas(calorias, caloriasTotais);
    } else {
      removerCaloriasConsumidas(calorias, caloriasTotais);
    }
    notifyListeners();
  }

  // Métodos de consumo de calorias (não dependem do usuário)
  void adicionarCaloriasConsumidas(int calorias, int caloriasTotais) {
    _caloriasTotais = caloriasTotais;
    final currentCalories = _caloriasConsumidas;
    _caloriasConsumidas = currentCalories + calorias;
    if (_caloriasTotais != null) {
      calcularPorcentagem();
      teste();
    }
    notifyListeners();
  }

  void removerCaloriasConsumidas(int calorias, int caloriasTotais) {
    _caloriasTotais = caloriasTotais;
    final currentCalories = _caloriasConsumidas;
    _caloriasConsumidas = currentCalories - calorias;
    if (_caloriasTotais != null) {
      calcularPorcentagem();
      teste();
    }

    notifyListeners();
  }

  Future<void> calcularPorcentagem() async {
    isCalculate = true;
    notifyListeners();
    debugPrint(_caloriasTotais.toString());
    if (_caloriasTotais != null) {
      final calcular = ((_caloriasConsumidas / _caloriasTotais!) * 100)
          .roundToDouble();
      _porcentagem = calcular / 100;
      isCalculate = false;
      notifyListeners();
    }
  }

  resetarProcentagem() {
    _caloriasConsumidas = 0;
    _porcentagem = 0;
    notifyListeners();
  }

  void calcularMacros({required AuthUserModel authUserModel}) {
    _macronutrientesModel = _calcularCaloriasService.calcularMacros(
      calorias: _caloriasTotais!,
      authUserModel: authUserModel,
    );
    debugPrint(_macronutrientesModel!.carboidratos.toString());
    debugPrint(_macronutrientesModel!.proteinas.toString());
    debugPrint(_macronutrientesModel!.gorduras.toString());

    notifyListeners();
  }

  void teste() {
    _calModel = CaloriasModel.fromJson(
      caloriasTotais: _caloriasTotais ?? 0,
      caloriasConsumidas: _caloriasConsumidas,
      taxaMetabolismoBasal: _valorTMB ?? 0,
    );
    notifyListeners();
  }
}
