import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerificaDiaService {
  int _getDiaTimestamp(DateTime date) {
    return DateTime(date.year, date.month, date.day).millisecondsSinceEpoch;
  }

  Future salvarDiaAtual(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final todayTimestamp = _getDiaTimestamp(DateTime.now());
      await prefs.setInt(key, todayTimestamp);
    } on PlatformException catch (e) {
      throw Exception('Erro de plataforma $e');
    } catch (e) {
      throw Exception('Erro inesperado ao salvar $e');
    }
  }

  Future<bool> verificaDiaIgualAtual(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTimestamp = prefs.getInt(key);
      if (savedTimestamp == null) {
        await salvarDiaAtual(key);
        return true;
      }
      final todayTimestamp = _getDiaTimestamp(DateTime.now());
      return todayTimestamp == savedTimestamp;
    } on PlatformException catch (e) {
      throw Exception('Erro de plataforma ao verificar data $e');
    } catch (e) {
      throw Exception('Erro inesperado ao verificar data $e');
    }
  }
}
