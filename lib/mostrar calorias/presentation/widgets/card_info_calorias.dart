import 'package:app_calorias_diarias/auth/presentation/providers/auth_provider.dart';
import 'package:app_calorias_diarias/calcular%20calorias/presentation/providers/calorias_provider.dart';
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String onlyDay = DateFormat.yMMMEd().format(date);
    debugPrint(onlyDay);
    //2025-09-10T13:20:12.396339
    //2025-09-10T13:21:00.178900
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CaloriasProvider>(context, listen: true);
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
                            ).colorScheme.inversePrimary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Taxa metabólica Basal',

                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
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
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5),

                        Container(
                          height: constraints.maxHeight * 0.27,
                          width: constraints.maxWidth * 0.38,

                          padding: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.inversePrimary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Calorias diárias',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  fontSize: 18,
                                ),
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
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    CircularPercentIndicator(
                      radius: 70.0,
                      lineWidth: 7.0,
                      percent: provider.porcentagem ?? 0.0,
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          provider.porcentagem != null
                              ? Text('${provider.porcentagem}%')
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
                                : '${provider.caloriasModel?.caloriasConsumidas.toString()}/${userProfileProvider.authProvider.authModel?.authUserModel?.macronutrientesDiarios?.calorias.toString()} Kcal',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      backgroundColor: Colors.grey.shade300,
                      progressColor: Theme.of(
                        context,
                      ).colorScheme.inversePrimary,
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
