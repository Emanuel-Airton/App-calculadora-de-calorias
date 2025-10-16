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

class ChatRepositorie {
  // ChatCacheService cacheService = ChatCacheService();
  final planoBox = Hive.box<PlanoAlimentar>('planoAlimentarBox');

  ChatService chatService = ChatService();
  final chaveCache = 'refeições';

  int? verificarTempoUltimaRequisicao() {
    return chatService.verificarTempoUltimaRequisicao();
  }

  Stream<PlanoAlimentar> gerarPlanoAlimentar(
    MacronutrientesModel macroNutrientes,
    String objetivo,
  ) async* {
    try {
      String accumulatedJson = '';
      await for (final chunk in chatService.generateMealPlanStream(
        macroNutrientes,
        objetivo,
      )) {
        accumulatedJson += chunk;

        final plano = _tryParsePlanoAlimentar(accumulatedJson);
        if (plano != null) {
          yield plano;
          await limparCache();
          await PlanoAlimentarService(planoBox).salvarPlano(plano);
          //  cacheService.salvarCache('refeições', plano);
        }
      }
      /*  chatService.generateMealPlanStream(macroNutrientes, objetivo).listen((
        event,
      ) {
        accumulatedJson = event;
      });
      yield accumulatedJson;*/
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
  /*  Future<PlanoAlimentar?> gerarRefeicoes(
    MacronutrientesModel chatModel,
    String objetivo,
  ) async {
    try {
      // Primeiro tenta fazer a requisição da API

      debugPrint('objetivo: $objetivo');
      final request = await chatService.retryrequestApi(chatModel, objetivo);

      // Se a requisição foi bem sucedida, salva no cache
      if (request!.listRefeicao != null && request.listRefeicao!.isNotEmpty) {
        await PlanoAlimentarService(planoBox).salvarPlano(request);
        debugPrint('Plano salvo no cache com sucesso!');
      }
      return request;
    } catch (e) {
      // Se der erro na API, tenta buscar do cache
      debugPrint('objetivo nulo: $objetivo');
      debugPrint('Erro na API, tentando cache: $e');
      final cache = await lerRefeicoesCache();
      if (cache != null) {
        debugPrint('Usando dados do cache');
        return cache;
      }
      rethrow;
    }
  }*/

  /* Stream<String?> gerar(MacronutrientesModel macros, String objetivo) {
    try {
      Stream<String?> stream = chatService.requestApi(macros, objetivo);
      return stream;
    } catch (e) {
      rethrow;
    }
  }*/

  Future<PlanoAlimentar?> lerRefeicoesCache() async {
    try {
      final lerCache = PlanoAlimentarService(planoBox).obterPlano();

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

  Future<void> limparCache() async {
    PlanoAlimentarService(planoBox).removerPlano();
  }
}
