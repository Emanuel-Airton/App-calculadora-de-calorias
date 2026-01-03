import 'package:app_calorias_diarias/auth/presentation/providers/userProfile_provider.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:intl/intl.dart';

class CardInfoCalorias extends StatefulWidget {
  const CardInfoCalorias({super.key});

  @override
  State<CardInfoCalorias> createState() => _CardInfoCaloriasState();
}

class _CardInfoCaloriasState extends State<CardInfoCalorias> {
  final date = DateTime.now();
  Future<double>? valor;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String onlyDay = DateFormat.yMMMEd().format(date);
    debugPrint(onlyDay);
    debugPrint('testando...');
    obterPorcentagem();
    //2025-09-10T13:20:12.396339
    //2025-09-10T13:21:00.178900
  }

  obterPorcentagem() {
    valor = Future.delayed(Duration(milliseconds: 500)).then(
      (value) => context
          .read<UserProfileProvider>()
          .authProvider
          .authModel!
          .authUserModel!
          .planoAlimentar!
          .porcentagemConsumida!,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProfileProvider = Provider.of<UserProfileProvider>(
      context,
      listen: true,
    );

    /*debugPrint(
      'lista: ${provider.authUserModel?.macronutrientesDiarios?.listFontesProteinas.toString()}',
    );*/
    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          margin: EdgeInsets.fromLTRB(25, 5, 25, 2),
          color: Colors.white,
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: constraints.maxHeight * 0.27,
                  width: constraints.maxWidth * 0.85,

                  padding: EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: DatePicker(
                    dateTextStyle: TextStyle(fontSize: 11),
                    dayTextStyle: TextStyle(fontSize: 10),
                    date,
                    initialSelectedDate: date,
                    activeDates: [date],
                    daysCount: 5,
                    selectionColor: Theme.of(
                      context,
                    ).colorScheme.inversePrimary,
                    selectedTextColor: Colors.white,
                    locale: 'pt_BR',
                  ),
                ),
                SizedBox(height: 5),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Container(
                          height: constraints.maxHeight * 0.27,

                          padding: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: const Offset(0, 8),
                                blurRadius: 20,
                                spreadRadius: -5,
                              ),
                            ],
                            gradient: LinearGradient(
                              colors: [
                                Colors.grey.shade300,
                                Colors.grey.shade200,
                                Colors.grey.shade100,
                                Colors.grey.shade50,
                              ],
                            ),
                          ),

                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Taxa metabólica Basal',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(
                                              'Taxa metabólica Basal',
                                            ),
                                            content: Text(
                                              style: TextStyle(
                                                color: Colors.grey[700],
                                              ),
                                              'A taxa metabólica basal (TMB) é a quantidade mínima de energia (calorias) que o seu corpo precisa para manter as funções vitais enquanto você está em completo repouso físico e mental, em jejum e em ambiente com temperatura neutra.\n Em outras palavras, é o gasto de energia necessário para manter você vivo — respiração, circulação sanguínea, temperatura corporal, funcionamento dos órgãos, atividade celular, etc.',
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.inversePrimary,
                                      ),
                                      child: Text(
                                        '?',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                userProfileProvider
                                            .authProvider
                                            .authModel
                                            ?.authUserModel
                                            ?.caloriasModel
                                            ?.taxaMetabolismoBasal ==
                                        null
                                    ? '--'
                                    : '${userProfileProvider.authProvider.authModel?.authUserModel?.caloriasModel?.taxaMetabolismoBasal} Kcal',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.inversePrimary,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5),

                        Container(
                          height: constraints.maxHeight * 0.27,
                          width: constraints.maxWidth * 0.45,

                          padding: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: const Offset(0, 8),
                                blurRadius: 20,
                                spreadRadius: -5,
                              ),
                            ],
                            gradient: LinearGradient(
                              colors: [
                                Colors.grey.shade300,
                                Colors.grey.shade200,
                                Colors.grey.shade100,
                                Colors.grey.shade50,
                              ],
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Calorias diárias',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text('Calorias diárias'),
                                            content: Text(
                                              style: TextStyle(
                                                color: Colors.grey[700],
                                              ),
                                              'Esse valor é referente a quantidade de calorias que você deve ingerir em um único dia, de acordo com o calculo feito para seu objetivo especifico (Emagrecer ou ganhar massa muscular).',
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.inversePrimary,
                                      ),
                                      child: Text(
                                        '?',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                userProfileProvider
                                            .authProvider
                                            .authModel
                                            ?.authUserModel
                                            ?.caloriasModel
                                            ?.caloriasTotais ==
                                        null
                                    ? '--'
                                    : '${userProfileProvider.authProvider.authModel?.authUserModel?.macronutrientesDiarios?.calorias.toString()} Kcal',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.inversePrimary,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    FutureBuilder(
                      future: valor,
                      builder: (context, asyncSnapshot) {
                        switch (asyncSnapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return CircularProgressIndicator();
                          case ConnectionState.active:
                            throw UnimplementedError();
                          case ConnectionState.done:
                            final double porcentagem = asyncSnapshot.data!;

                            return CircularPercentIndicator(
                              radius: 70.0,
                              lineWidth: 7.0,
                              percent: asyncSnapshot.data ?? 0.0,
                              center: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  porcentagem != null
                                      ? Text(
                                          '${(porcentagem * 100).toStringAsFixed(1)}%',
                                        )
                                      : Text((0.0).toString()),
                                  Text(
                                    'Calorias consumidas',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                  Text(
                                    userProfileProvider
                                                .authProvider
                                                .authModel
                                                ?.authUserModel
                                                ?.macronutrientesDiarios
                                                ?.calorias ==
                                            null
                                        ? '--'
                                        : '${userProfileProvider.authProvider.authModel?.authUserModel?.caloriasModel?.caloriasConsumidas.toString()}/${userProfileProvider.authProvider.authModel?.authUserModel?.macronutrientesDiarios?.calorias.toString()} Kcal',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              backgroundColor: Colors.grey.shade300,
                              progressColor: Theme.of(
                                context,
                              ).colorScheme.inversePrimary,
                            );
                        }
                        return Container();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
