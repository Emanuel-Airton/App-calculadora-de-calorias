import 'package:shared_preferences/shared_preferences.dart';

class ChatCacheService {
  Future<void> salvarCache(String chave, String valor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(chave, valor);
  }

  Future<String?> lerCache(String chave) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(chave);
  }

  Future<void> limparCache(String chave) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(chave);
  }
}
