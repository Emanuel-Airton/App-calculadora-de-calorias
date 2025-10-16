import 'dart:async';
import 'package:app_calorias_diarias/chat/domain/models/plano_alimentar_model.dart';
import 'package:app_calorias_diarias/chat/domain/models/refeicao_model.dart';
import 'package:app_calorias_diarias/chat/presentation/providers/chat_provider.dart';
import 'package:app_calorias_diarias/chat/presentation/widgets/buttom_gerar_refeicoes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ChatRefeicoesView extends StatefulWidget {
  const ChatRefeicoesView({super.key});

  @override
  State<ChatRefeicoesView> createState() => _AlertdialogRefeicoesState();
}

class _AlertdialogRefeicoesState extends State<ChatRefeicoesView> {
  Stream<String>? streamPlano;

  @override
  Widget build(BuildContext context) {
    //   debugPrint('reload');

    return Expanded(
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: Container(
              padding: EdgeInsets.all(15),
              height: MediaQuery.sizeOf(context).height * 0.6,
              width: MediaQuery.sizeOf(context).width,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.05,
            left: 20,
            right: 20,
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.75,
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Consumer<ChatProvider>(
                    builder: (context, provider, child) {
                      debugPrint('reload');
                      return Expanded(
                        child: provider.carregando == false
                            ? Container(
                                height: MediaQuery.sizeOf(context).height * 0.8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 20),

                                    Expanded(
                                      child: ListView.builder(
                                        itemCount:
                                            provider
                                                .planoAtual
                                                ?.listRefeicao
                                                ?.length ??
                                            0,
                                        itemBuilder: (context, index) {
                                          debugPrint('plano alimentar');
                                          final refeicao = provider
                                              .planoAtual
                                              ?.listRefeicao?[index];
                                          return AnimatedOpacity(
                                            opacity: 1.0,
                                            duration: Duration(
                                              milliseconds: 300 + (index * 100),
                                            ),
                                            child: AnimatedSlide(
                                              duration: Duration(
                                                milliseconds:
                                                    400 + (index * 100),
                                              ),
                                              offset: Offset.zero,
                                              child: _buildRefeicaoCard(
                                                refeicao,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : StreamBuilder<PlanoAlimentar>(
                                stream: provider.currentStream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    // Usa um Future.microtask para evitar problemas de contexto
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Erro o gerar seu plano',
                                                textAlign: TextAlign.center,
                                              ),
                                              backgroundColor: Colors.red,
                                              duration: Duration(seconds: 4),
                                            ),
                                          );
                                          provider.clearException();
                                        });
                                  }
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.none:
                                    case ConnectionState.waiting:
                                      return Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            LinearProgressIndicator(),
                                            SizedBox(height: 16),
                                            Text(
                                              'Gerando seu plano alimentar...',
                                            ),
                                          ],
                                        ),
                                      );

                                    case ConnectionState.active:
                                      if (snapshot.hasData) {
                                        // Dados sendo recebidos - você pode mostrar um loading com preview
                                        return Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CircularProgressIndicator(),
                                              SizedBox(height: 16),
                                              Text('Processando resposta...'),
                                            ],
                                          ),
                                        );
                                      }
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );

                                    case ConnectionState.done:
                                      if (snapshot.hasData) {
                                        // Dados completos - será redirecionado para a view principal
                                        return Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.check_circle,
                                                color: Colors.green,
                                                size: 48,
                                              ),
                                              SizedBox(height: 16),
                                              Text(
                                                'Plano alimentar gerado com sucesso!',
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                      return Center(
                                        child: Text(
                                          'Gerar seu plano alimentar',
                                        ),
                                      );
                                  }

                                  /*    if (provider.exception != null) {
                              debugPrint('snapshot.hasError');
                              Future.delayed(Duration(seconds: 1)).then((
                                value,
                              ) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Center(
                                      child: Text(
                                        provider.exception.toString(),
                                      ),
                                    ),
                                  ),
                                );
                              });
                              //return Text('Erro: ${provider.exception}');
                            }*/
                                  /*   if (snapshot.hasData) {
                                    // if (snapshot.hasData) {
                                    // final PlanoAlimentar? plano = provider.planoAtual;
                                    final PlanoAlimentar? plano = snapshot.data;

                                    final ItemScrollController
                                    itemScrollController =
                                        ItemScrollController();
                                    return Container(
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                          0.8,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 20),

                                          Expanded(
                                            child:
                                                ScrollablePositionedList.builder(
                                                  itemScrollController:
                                                      itemScrollController,
                                                  itemCount:
                                                      plano
                                                          ?.listRefeicao
                                                          ?.length ??
                                                      0,
                                                  itemBuilder: (context, index) {
                                                    final refeicao = plano
                                                        ?.listRefeicao?[index];
                                                    return AnimatedOpacity(
                                                      opacity: 1.0,
                                                      duration: Duration(
                                                        milliseconds:
                                                            300 + (index * 100),
                                                      ),
                                                      child: AnimatedSlide(
                                                        duration: Duration(
                                                          milliseconds:
                                                              400 +
                                                              (index * 100),
                                                        ),
                                                        offset: Offset.zero,
                                                        child:
                                                            _buildRefeicaoCard(
                                                              refeicao,
                                                            ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                          ),
                                        ],
                                      ),
                                    );

                                    //  }
                                  }
                                  if (snapshot.hasError) {
                                    debugPrint('snapshot.hasError');
                                    Future.delayed(Duration(seconds: 1)).then((
                                      value,
                                    ) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Center(
                                            child: Text(
                                              provider.exception.toString(),
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                                    //return Text('Erro: ${provider.exception}');
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    // Mostra indicador de "digitando" enquanto o JSON não está completo
                                    return Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width:
                                                MediaQuery.sizeOf(
                                                  context,
                                                ).width *
                                                0.6,
                                            child: LinearProgressIndicator(),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            'Gerando seu plano alimentar, por favor aguarde...',
                                          ),
                                        ],
                                      ),
                                    );
                                  }

                                  return const Center(
                                    child: Text('Gerar seu plano'),
                                  );*/
                                },
                              ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: SizedBox(
                      width: double.maxFinite,
                      child: ButtomGerarRefeicoes(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRefeicaoCard(RefeicaoModel? refeicao) {
    return Card(
      elevation: 4,
      //  color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho da refeição
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  refeicao?.nomeRefeicao.toString() ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  '${refeicao?.macros?['calorias'] ?? 0}kcal',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Alimentos
            Text(
              '🍽️ Alimentos:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 5),
            Wrap(
              spacing: 8,
              runSpacing: 5,
              children: refeicao!.alimentos!.map((alimento) {
                return Chip(
                  side: BorderSide.none,
                  label: Text(alimento),
                  color: WidgetStatePropertyAll(
                    Theme.of(
                      context,
                    ).colorScheme.inversePrimary.withOpacity(0.4),
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                );
              }).toList(),
            ),

            const SizedBox(height: 10),

            // Macros
            Text(
              '📊 Macronutrientes:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMacroChip(
                  '🥩 Proteína',
                  '${refeicao.macros?['proteinas'] ?? 0}g',
                ),
                _buildMacroChip(
                  '🍚 Carboidrato',
                  '${refeicao.macros?['carboidratos'] ?? 0}g',
                ),
                _buildMacroChip(
                  '🥑 Gordura',
                  '${refeicao.macros?['gorduras'] ?? 0}g',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroChip(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
