import 'dart:async';
import 'package:app_calorias_diarias/auth/presentation/providers/userProfile_provider.dart';
import 'package:app_calorias_diarias/calcular%20calorias/presentation/providers/calorias_provider.dart';
import 'package:app_calorias_diarias/chat/domain/models/plano_alimentar_model.dart';
import 'package:app_calorias_diarias/chat/presentation/providers/chat_provider.dart';
import 'package:app_calorias_diarias/chat/presentation/widgets/buttom_gerar_refeicoes.dart';
import 'package:app_calorias_diarias/chat/presentation/widgets/card_info_refeicoes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatRefeicoesView extends StatefulWidget {
  const ChatRefeicoesView({super.key});

  @override
  State<ChatRefeicoesView> createState() => _AlertdialogRefeicoesState();
}

class _AlertdialogRefeicoesState extends State<ChatRefeicoesView> {
  Stream<String>? streamPlano;

  @override
  Widget build(BuildContext context) {
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
                      debugPrint('reload ChatProvider');

                      return Expanded(
                        child:
                            provider.carregando == false &&
                                provider.planoAtual != null
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
                                              child: CardInfoRefeicoes(
                                                refeicao: refeicao,
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
                                  debugPrint('rodando novamente');

                                  if (provider.exception != null) {
                                    debugPrint('hasError ${snapshot.error}');
                                    // Usa um Future.microtask para evitar problemas de contexto
                                    Future.microtask(
                                      () => showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.error,
                                                color: Colors.red,
                                                size: 48,
                                              ),
                                              SizedBox(height: 16),
                                              Column(
                                                children: [
                                                  Text(
                                                    'Erro ao gerar novo plano!',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    'Tente novamente mais tarde',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                provider.clearException();
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                'Ok, fechar',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                    // provider.clearException();
                                  }
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                      debugPrint('waiting');

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
                                        debugPrint('hasdata');

                                        // Dados sendo recebidos - você pode mostrar um loading com preview
                                        WidgetsBinding.instance.addPostFrameCallback((
                                          timeStamp,
                                        ) {
                                          context
                                              .read<UserProfileProvider>()
                                              .resetCaloriasConsumidas();
                                          context
                                              .read<CaloriasProvider>()
                                              .resetarProcentagem();
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
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
                                            ),
                                          );
                                        });
                                      }
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );

                                    case ConnectionState.done:
                                      if (snapshot.hasData) {
                                        debugPrint('done');

                                        Center(child: Text('plano gerado'));
                                      }
                                      return Center(
                                        child: Text('Gerar seu plano'),
                                      );
                                    case ConnectionState.none:
                                      // TODO: Handle this case.
                                      return Center(
                                        child: Text(
                                          'Plano não gerado',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      );
                                  }
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
}
