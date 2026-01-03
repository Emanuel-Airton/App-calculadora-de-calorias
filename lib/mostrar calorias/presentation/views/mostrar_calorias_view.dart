import 'package:app_calorias_diarias/auth/presentation/providers/userProfile_provider.dart';
import 'package:app_calorias_diarias/chat/domain/models/plano_alimentar_model.dart';
import 'package:app_calorias_diarias/mostrar%20calorias/presentation/widgets/card_info_calorias.dart';
import 'package:app_calorias_diarias/mostrar%20calorias/presentation/widgets/checkbox_refeicoes.dart';
import 'package:app_calorias_diarias/mostrar%20calorias/presentation/widgets/column_macros.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MostrarCaloriasView extends StatefulWidget {
  const MostrarCaloriasView({super.key});

  @override
  State<MostrarCaloriasView> createState() => _HomepageState();
}

class _HomepageState extends State<MostrarCaloriasView> {
  Map<int, bool> map = {};
  bool valor = false;
  Future<PlanoAlimentar?>? plano;
  @override
  void initState() {
    // TODO: implement initState

    obterPlano();
    // debugPrint('teste');
    super.initState();
  }

  void obterPlano() {
    plano = Future.delayed(Duration(milliseconds: 500)).then(
      (value) => context
          .read<UserProfileProvider>()
          .authProvider
          .authModel!
          .authUserModel!
          .planoAlimentar!,
    );
  }

  @override
  Widget build(BuildContext context) {
    // final chatprovider = Provider.of<ChatProvider>(context);

    debugPrint('reload');
    return Expanded(
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: MediaQuery.sizeOf(context).width * 0.9,
              height: MediaQuery.sizeOf(context).height * 0.6,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 180.0),
                child: SingleChildScrollView(child: ColumnMacros()),
              ),
            ),
          ),

          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.45,
            left: 0,
            right: 0,
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.3,
              width: MediaQuery.sizeOf(context).width * 0.95,
              child: CardInfoCalorias(),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.41,
            left: 25,
            right: 25,
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.06,
              width: MediaQuery.sizeOf(context).width * 0.3,
              child: Consumer<UserProfileProvider>(
                builder: (context, value, child) {
                  return FutureBuilder(
                    future: plano,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          return Container();
                        case ConnectionState.waiting:
                          return Center(child: LinearProgressIndicator());
                        case ConnectionState.active:
                        case ConnectionState.done:
                          if (snapshot.hasError) {
                            return Center(
                              child: Text('Erro ao carregar dados!'),
                            );
                          }
                          if (snapshot.hasData) {
                            final data = snapshot.data?.listRefeicao;
                            if (data != null) {
                              //  List<int> list = [];
                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  final item =
                                      snapshot.data?.listRefeicao?[index];
                                  // debugPrint('testando');
                                  map.addAll({
                                    index:
                                        //valor,
                                        ?item?.refeicaoFeita,
                                  });
                                  final calorias = item?.macros!['calorias'];
                                  //debugPrint('map: ${map.toString()}');
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: CheckboxRefeicoes(
                                      nomeRefeicaoSelecionada:
                                          item?.nomeRefeicao,
                                      valor: map[index],
                                      calorias: calorias,
                                    ),
                                  );
                                },
                              );
                            }
                          }
                      }
                      return Container();
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
