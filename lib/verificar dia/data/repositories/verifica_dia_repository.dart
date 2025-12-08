import 'package:app_calorias_diarias/verificar%20dia/data/services/verifica_dia_service.dart';

class VerificaDiaRepository {
  final VerificaDiaService _verificaDiaService;
  VerificaDiaRepository(this._verificaDiaService);
  static const String _keyDiaAtual = 'dia_atual';

  Future<void> salvarDiaAtual() async {
    try {
      return await _verificaDiaService.salvarDiaAtual(_keyDiaAtual);
    } catch (e) {
      throw Exception('Erro ao salvar data atual: $e');
    }
  }

  Future<bool> verificaDiaIgualAtual() async {
    try {
      return await _verificaDiaService.verificaDiaIgualAtual(_keyDiaAtual);
    } catch (e) {
      return false;
    }
  }
}
