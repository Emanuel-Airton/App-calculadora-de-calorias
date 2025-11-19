import 'dart:convert';
import 'package:app_calorias_diarias/chat/domain/models/macronutrientes.dart';
import 'package:app_calorias_diarias/env/env.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class ChatService {
  static DateTime? lastRequestTime;
  /* Stream<PlanoAlimentar?> retryrequestApi(
    MacronutrientesModel chatModel,
    String objetivo,
  ) async* {
    int retries = 2;
    for (int i = 0; i < retries; i++) {
      try {
        // requestApi(chatModel, objetivo);
      } catch (e) {
        if (i == retries - 1) {
          rethrow;
        } else {
          Future.delayed(Duration(seconds: 2));
          continue;
        }
      }
    }
    throw Exception("Falha após $retries tentativas devido a rate-limit");
  }*/

  int? verificarTempoUltimaRequisicao() {
    const Duration minInterval = Duration(seconds: 10);
    if (lastRequestTime != null) {
      final timeSinceLastRequest = DateTime.now().difference(lastRequestTime!);
      if (timeSinceLastRequest < minInterval) {
        final waitTime = minInterval - timeSinceLastRequest;
        debugPrint(
          '⏳ Aguardando ${waitTime.inSeconds} minutos para próxima requisição...',
        );
        return waitTime.inSeconds;
      } else {
        lastRequestTime = DateTime.now();
        return null;
      }
    } else {
      lastRequestTime = DateTime.now();
      return null;
    }
  }

  Stream<String> generateMealPlanStream(
    MacronutrientesModel macros,
    String objetivo,
  ) async* {
    const apiKey = Env.apiKey;
    final client = http.Client();
    final prompt = macros.messagePrompt(objetivo);
    //debugPrint('macros: ${prompt.toString()}');
    //  debugPrint('macros: ${macros.listFontesCarboidratos.toString()}');

    try {
      final request = http.Request(
        'POST',
        Uri.parse("https://openrouter.ai/api/v1/chat/completions"),
      );
      request.headers.addAll({"Authorization": 'Bearer $apiKey  '});
      request.body = jsonEncode({
        'model': 'meituan/longcat-flash-chat:free',
        "messages": [
          {
            "role": "system",
            "content":
                "Você é um nutricionista especializado em dietas personalizadas. IMPORTANTE: sua resposta DEVE ser SOMENTE um JSON válido, sem comentários, sem markdown, sem ```json, sem texto fora do objeto. FORMATO EXATO:\n\n{\n  \"plano_alimentar\": [\n    {\n      \"refeicao\": \"Nome da Refeição\",\n      \"alimentos\": [\"alimento 1 (quantidade)\", \"alimento 2 (quantidade)\"],\n      \"macros\": {\n        \"proteinas\": 0,\n        \"carboidratos\": 0,\n        \"gorduras\": 0,\n        \"calorias\": 0\n      }\n    }\n  ]\n}",
          },
          {"role": "user", "content": prompt},
        ],
        "stream": true,
        "max_tokens": 1000,
        "temperature": 0.4,
      });
      final response = await client.send(request);

      if (response.statusCode == 200) {
        //debugPrint(response.statusCode.toString());
        await for (var chunk in response.stream.transform(utf8.decoder)) {
          List<String> lines = chunk.split('\n');

          for (var line in lines) {
            if (line.startsWith('data: ') && line != 'data: [DONE]') {
              try {
                final jsonData = json.decode(
                  line
                      .substring(6)
                      .replaceAll('```json', '')
                      .replaceAll('```', '')
                      .trim(),
                );
                final content = jsonData['choices'][0]['delta']['content'];
                if (content != null) {
                  yield content;
                }
              } catch (e) {
                // Ignora linhas inválidas
              }
            }
          }
        }
      } else {
        throw Exception(
          'Erro na API: ${response.statusCode} ${response.reasonPhrase}',
        );
      }
    } finally {
      client.close();
    }
    // }
    //  return;
    //}
    // _lastRequestTime = DateTime.now();

    /*final response0 = await http.get(
      Uri.parse("https://openrouter.ai/api/v1/key"),
      headers: {"Authorization": 'Bearer $apiKey  '},
    );
    if (response0.statusCode == 200) {
      debugPrint(response0.body);
    }*/
  }

  /*
  Future<PlanoAlimentar> requestApi(
    MacronutrientesModel macros,
    String objetivo,
  ) async {
    const apiKey = Env.apiKey;
    // debugPrint(apiKey);
    final url = Uri.parse("https://openrouter.ai/api/v1/chat/completions");
    final prompt = macros.messagePrompt(objetivo);
    // debugPrint(prompt);
    /*  final response0 = await http.get(
      Uri.parse("https://openrouter.ai/api/v1/key"),
      headers: {"Authorization": 'Bearer $apiKey  '},
    );
    if (response0.statusCode == 200) {
      debugPrint(response0.body);
    }*/
    final response = await http
        .post(
          url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $apiKey",
          },

          body: jsonEncode({
            "model": "deepseek/deepseek-chat-v3-0324:free",
            "messages": [
              {
                "role": "system",
                "content":
                    "Você é um nutricionista especializado em dietas personalizadas. IMPORTANTE: sua resposta DEVE ser SOMENTE um JSON válido, sem comentários, sem markdown, sem ```json, sem texto fora do objeto. FORMATO EXATO:\n\n{\n  \"plano_alimentar\": [\n    {\n      \"refeicao\": \"Nome da Refeição\",\n      \"alimentos\": [\"alimento 1 (quantidade)\", \"alimento 2 (quantidade)\"],\n      \"macros\": {\n        \"proteinas\": 0,\n        \"carboidratos\": 0,\n        \"gorduras\": 0,\n        \"calorias\": 0\n      }\n    }\n  ]\n}",
              },
              {"role": "user", "content": prompt},
            ],
            "max_tokens": 700,
            "temperature": 0.7,
          }),
        )
        .timeout(Duration(seconds: 45));
    if (response.statusCode == 200) {
      try {
        String cleanedJson = response.body
            .replaceAll('```json', '')
            .replaceAll('```', '')
            .trim();

        final responseBody = jsonDecode(
          cleanedJson,
        )["choices"][0]["message"]["content"];
        debugPrint('Resposta da API: $responseBody');
        final jsonData = jsonDecode(responseBody);
        debugPrint('jsonData: ${jsonData.runtimeType}');
        PlanoAlimentar planoAlimentar = PlanoAlimentar.fromJson(
          jsonData, // Note: content já é um JSON string
        );

        if (planoAlimentar.listRefeicao!.isNotEmpty) {
          debugPrint(
            'Plano processado com ${planoAlimentar.listRefeicao!.length} refeições',
          );
        }
        return planoAlimentar;
      } catch (e) {
        debugPrint('Erro ao processar resposta da API: $e');
        rethrow;
      }
    } else {
      throw Exception("Erro ao gerar refeições: ${response.body}");
    }
  }*/
}
