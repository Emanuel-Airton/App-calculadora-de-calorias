import 'dart:convert';
import 'package:app_calorias_diarias/chat/data/services/chat_cache_service.dart';
import 'package:app_calorias_diarias/chat/data/services/chat_service.dart';
import 'package:app_calorias_diarias/chat/data/services/plano_alimentar_service.dart';
import 'package:app_calorias_diarias/chat/domain/models/macronutrientes.dart';
import 'package:app_calorias_diarias/chat/domain/models/plano_alimentar_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

/*class ChatRepositorie {
  ChatCacheService cacheService = ChatCacheService();
  ChatService chatService = ChatService();
  final chaveCache = 'refeições';

  Future<Map<String, dynamic>?> gerarRefeicoes(
    ChatModel chatModel,
    String objetivo,
  ) async {
    try {
      final lerRefeicoes = await lerRefeicoesCache();
      if (lerRefeicoes != null) return lerRefeicoes;
      final request = await chatService.requestApi(chatModel, objetivo);
      await cacheService.salvarCache(chaveCache, request);
      return jsonDecode(request);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> lerRefeicoesCache() async {
    final lerCache = await cacheService.lerCache(chaveCache);

    if (lerCache != null) {
      //  debugPrint('valor cache: $lerCache');
      final map = await jsonDecode(lerCache);
      debugPrint('valor cache: ${map.toString()}');
      return jsonDecode(map);
    }
    debugPrint('cache vazio: $lerCache');
    return null;
  }

  Future<void> limparCache() async {
    await cacheService.limparCache(chaveCache);
  }
}*/

class ChatRepository {
  final PlanoAlimentarService _planoService;
  final ChatService _chatService;

  ChatRepository({
    required PlanoAlimentarService planoService,
    required ChatService chatService,
  }) : _planoService = planoService,
       _chatService = chatService;

  final planoBox = Hive.box<PlanoAlimentar>('planoAlimentarBox');

  final chaveCache = 'refeições';

  int? verificarTempoUltimaRequisicao() {
    return _chatService.verificarTempoUltimaRequisicao();
  }

  Stream<PlanoAlimentar> gerarPlanoAlimentar(
    MacronutrientesModel macroNutrientes,
    String objetivo,
  ) async* {
    try {
      String accumulatedJson = '';
      await for (final chunk in _chatService.generateMealPlanStream(
        macroNutrientes,
        objetivo,
      )) {
        accumulatedJson += chunk;

        final plano = _tryParsePlanoAlimentar(accumulatedJson);
        if (plano != null) {
          yield plano;
          await limparCache();
          //  await PlanoAlimentarService(planoBox).salvarPlano(plano);
          await _planoService.salvarPlano(plano);
          //  cacheService.salvarCache('refeições', plano);
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  PlanoAlimentar? _tryParsePlanoAlimentar(String jsonString) {
    try {
      final cleanedJson = jsonString
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      if (cleanedJson.isEmpty) return null;

      final jsonMap = json.decode(cleanedJson);
      return PlanoAlimentar.fromJson(jsonMap);
    } catch (e) {
      return null; // JSON ainda incompleto
    }
  }

  Future<PlanoAlimentar?> lerRefeicoesCache() async {
    try {
      // final lerCache = PlanoAlimentarService(planoBox).obterPlano();
      final lerCache = _planoService.obterPlano();

      /*    PlanoAlimentarService(
        planoBox,
      ).atualizarPlano(plano: lerCache!, nomeRefeicao: 'Lanche da tarde');*/

      if (lerCache != null &&
          lerCache.listRefeicao != null &&
          lerCache.listRefeicao!.isNotEmpty) {
        debugPrint(
          'Cache encontrado: ${lerCache.listRefeicao!.length} refeições',
        );

        return lerCache;
      } else {
        debugPrint('Cache vazio ou inválido');
        return null;
      }
    } catch (e) {
      debugPrint('Erro ao ler cache: $e');
      return null;
    }
  }

  Future<void> atualizarPlano({
    required String nomeRefeicao,
    required bool valor,
  }) async {
    //final plano = await lerRefeicoesCache();
    await _planoService.atualizarPlano(
      nomeRefeicao: nomeRefeicao,
      valor: valor,
    );
    // await lerRefeicoesCache();
  }

  Future<void> resetarRefeicoes() async {
    await _planoService.removerPlano();
  }

  Future<void> limparCache() async {
    PlanoAlimentarService().removerPlano();
  }
}
