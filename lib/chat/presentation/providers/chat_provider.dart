import 'dart:async';
import 'package:app_calorias_diarias/chat/data/repositories/chat_repositorie.dart';
import 'package:app_calorias_diarias/chat/domain/models/macronutrientes.dart';
import 'package:app_calorias_diarias/chat/domain/models/plano_alimentar_model.dart';
import 'package:flutter/widgets.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepository _chatRepository;
  Future<PlanoAlimentar?>? _valorCache;
  Future<PlanoAlimentar?>? get valorCache => _valorCache;

  String? _streamValorCache;
  String? get streamValorCache => _streamValorCache;
  bool _carregando = false;
  bool? get carregando => _carregando;

  bool _respostaFinalizada = false;
  bool? get respostaFinalizada => _respostaFinalizada;

  Stream<PlanoAlimentar>? _currentStream;
  PlanoAlimentar? _accumulatedResponse;

  Stream<PlanoAlimentar>? get currentStream => _currentStream;
  PlanoAlimentar? get accumulatedResponse => _accumulatedResponse;

  PlanoAlimentar? _planoAtual;
  PlanoAlimentar? get planoAtual => _planoAtual;

  Exception? _exception;
  Exception? get exception => _exception;

  int? _tempoProximaRequisicao;
  int? get tempoProximaRequisicao => _tempoProximaRequisicao;

  ChatProvider({required ChatRepository chatRepository})
    : _chatRepository = chatRepository {
    lerRefeicaoCache();
  }

  int? verificarUltimaRequisicao() {
    _tempoProximaRequisicao = _chatRepository.verificarTempoUltimaRequisicao();
    notifyListeners();
    return null;
  }

  void gerarRefeicoes(MacronutrientesModel macroNutrientes, String objetivo) {
    _accumulatedResponse = null;
    _currentStream = null;
    _respostaFinalizada = false;
    _carregando = true;
    _exception = null;
    notifyListeners();
    // Transforma o stream de String em stream de PlanoAlimentar

    _currentStream = _chatRepository
        .gerarPlanoAlimentar(macroNutrientes, objetivo)
        .asBroadcastStream()
        .transform(
          StreamTransformer<PlanoAlimentar, PlanoAlimentar>.fromHandlers(
            handleData: (data, sink) {
              _planoAtual = null;
              _planoAtual = data;

              // Tenta parsear o JSON completo a cada novo chunk
              try {
                _carregando = true;

                sink.add(data);
                notifyListeners();
              } catch (e) {
                // JSON ainda incompleto - não faz nada, espera mais chunks
                // _carregando = true;
                _respostaFinalizada = false;
                debugPrint('JSON ainda incompleto');
              }

              notifyListeners();
            },
            handleError: (error, stackTrace, sink) {
              _exception = error is Exception
                  ? error
                  : Exception(error.toString());
              _carregando = true;
              _respostaFinalizada = false;
              debugPrint('exceção: ${exception.toString()}');
              sink.addError(error);
              //_carregando = false;
              sink.close();
              notifyListeners();
            },
            handleDone: (sink) {
              sink.close();

              if (_planoAtual != null) {
                _respostaFinalizada = true;
                _carregando = false;
                obterRefeicoesCache(plano: _planoAtual);
                debugPrint(
                  'resposta acumulada ${_planoAtual!.listRefeicao!.first.nomeRefeicao.toString()}',
                );
              }

              _exception = null;

              notifyListeners();
            },
          ),
        );

    notifyListeners();
  }

  void clearException() {
    _exception = null;
    _carregando = false;
    notifyListeners();
  }

  Future<void> lerRefeicaoCache() async {
    _planoAtual = await _chatRepository.lerRefeicoesCache();
    _respostaFinalizada = true;
    notifyListeners();
  }

  Future<void> atualizarRefeicao({
    required PlanoAlimentar planoAlimentar,
    required String nomeRefeicao,
    required valor,
  }) async {
    if (_planoAtual != null) {
      await _chatRepository.atualizarPlano(
        nomeRefeicao: nomeRefeicao,
        valor: valor,
      );
      // Recarrega o plano atualizado
      await obterRefeicoesCache();
    }
  }

  Future<void> obterRefeicoesCache({PlanoAlimentar? plano}) async {
    if (_carregando) {
      debugPrint(_carregando.toString());
      return;
    }
    _carregando = true;
    try {
      // if (_valorCache != null) return;
      if (plano != null) {
        debugPrint('plano atualizado');
        _valorCache = Future.delayed(
          Duration(milliseconds: 500),
        ).then((value) => plano);

        notifyListeners();
      } else {
        _valorCache = _chatRepository.lerRefeicoesCache();
        notifyListeners();
      }
      //_carregando = false;
      debugPrint('cache: $_valorCache');
    } catch (e) {
      debugPrint('Erro ao carregar cache: $e');
    } finally {
      _carregando = false;
      notifyListeners();
    }
    // notifyListeners();
    //  return _valorCache;
  }

  Future<void> limparCache() async {
    await _chatRepository.limparCache();
  }

  Future<void> resetarRefeicoes() async {
    await _chatRepository.resetarRefeicoes();
    notifyListeners();
  }

  /* void gerarRefeicoes(MacronutrientesModel macroNutrientes, String objetivo) {
    _accumulatedResponse = ''; // Reseta o acumulador
    _currentStream = ChatService()
        .generateMealPlanStream(macroNutrientes, objetivo)
        .asBroadcastStream()
        .transform(
          StreamTransformer<String, PlanoAlimentar>.fromHandlers(
            handleData: (data, sink) {
              _accumulatedResponse += data;

              // Tenta parsear o JSON completo a cada novo chunk
              try {
                final jsonString = _accumulatedResponse
                    .replaceAll('```json', '')
                    .replaceAll('```', '')
                    .trim();

                if (jsonString.isNotEmpty) {
                  final jsonMap = json.decode(jsonString);
                  final plano = PlanoAlimentar.fromJson(jsonMap);
                  _planoAtual = plano;
                  sink.add(plano);
                }
              } catch (e) {
                // JSON ainda incompleto - não faz nada, espera mais chunks
              }

              notifyListeners();
            },
            handleError: (error, stackTrace, sink) {
              sink.addError(error);
              debugPrint(error.toString());

              notifyListeners();
            },
            handleDone: (sink) {
              sink.close();

              notifyListeners();
            },
          ),
        );

    notifyListeners(); // Notifica que o stream começou
  }*/

  // Limpar stream atual
  void limparStream() {
    _currentStream = null;
    _accumulatedResponse = null;
    notifyListeners();
  }

  /*Future<void> gerarRefeicoes(
    MacronutrientesModel macroNutrientes,
    String objetivo,
  ) async {
    try {
      await chatRepositorie.gerarRefeicoes(macroNutrientes, objetivo);
    } catch (e) {
      rethrow;
    }
  }*/
}
/*
class ChatProvider extends ChangeNotifier {
  ChatRepositorie chatRepositorie;
  Future<PlanoAlimentar?>? _valorCache;
  Future<PlanoAlimentar?>? get valorCache => _valorCache;
  bool _carregando = false;
  bool? get carregando => _carregando;

  ChatProvider({ChatRepositorie? chatRepositorie})
    : chatRepositorie = chatRepositorie ?? ChatRepositorie();

  Future<void> gerarRefeicoes(ChatModel chatModel, String objetivo) async {
    await chatRepositorie.gerarRefeicoes(chatModel, objetivo);
  }

  Future<PlanoAlimentar?> lerRefeicoesCache() async {
    _carregando = true;
    _valorCache = chatRepositorie.lerRefeicoesCache();
    _carregando = false;
    debugPrint('cache: ${_valorCache}');
    notifyListeners();
    return _valorCache;
  }

  Future<void> limparCache() async {
    await chatRepositorie.limparCache();
  }
}

*/