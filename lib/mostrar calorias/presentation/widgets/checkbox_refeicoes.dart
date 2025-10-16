import 'package:app_calorias_diarias/auth/presentation/providers/auth_provider.dart';
import 'package:app_calorias_diarias/calcular%20calorias/presentation/providers/calorias_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class CheckboxRefeicoes extends StatefulWidget {
  String? item;
  final calorias;
  bool? valor;
  CheckboxRefeicoes({super.key, this.item, this.valor, this.calorias});

  @override
  State<CheckboxRefeicoes> createState() => _CheckboxRefeicoesState();
}

class _CheckboxRefeicoesState extends State<CheckboxRefeicoes> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.valor!;
  }

  @override
  Widget build(BuildContext context) {
    final userProfileProvider = Provider.of<UserProfileProvider>(
      context,
      listen: false,
    );
    return SizedBox(
      child: Card(
        elevation: 6,
        // margin: EdgeInsets.only(left: 5.0),
        // color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Row(
            children: [
              Text(
                widget.item!,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w700,
                ),
              ),
              Consumer<CaloriasProvider>(
                builder: (context, provider, child) {
                  return Checkbox(
                    side: BorderSide(
                      width: 3,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    value: provider.refeicoesSelecionadas[widget.item] ?? false,
                    activeColor: Theme.of(context).colorScheme.inversePrimary,
                    onChanged: (bool? value) {
                      /*setState(() {
                        _isChecked = value!;
                      });*/
                      provider.alternarRefeicao(
                        valor: widget.item!,
                        iselect: value!,
                        calorias: widget.calorias,
                        caloriasTotais: userProfileProvider
                            .authProvider
                            .authModel!
                            .authUserModel!
                            .macronutrientesDiarios!
                            .calorias!,
                      );

                      /*provider.toggleRefeicao(
                        widget.item!,
                        widget.calorias,
                        value!,
                      );*/
                      debugPrint(
                        'calorias consumidas: ${provider.caloriasModel?.caloriasConsumidas.toString()}',
                      );
                      debugPrint(
                        'calorias totais: ${userProfileProvider.authProvider.authModel?.authUserModel?.macronutrientesDiarios?.calorias.toString()}',
                      );
                      if (provider.caloriasModel?.caloriasTotais ==
                          provider.caloriasModel?.caloriasConsumidas) {
                        Future.delayed(Duration(milliseconds: 700)).then((
                          value,
                        ) {
                          return QuickAlert.show(
                            title: 'Parabens! 👏',
                            widget: Center(
                              child: Text(
                                'Você cumpriu a meta de calorias diárias.',
                              ),
                            ),
                            context: context,
                            type: QuickAlertType.success,
                            confirmBtnColor: Theme.of(
                              context,
                            ).colorScheme.inversePrimary,

                            confirmBtnText: 'Ok, fechar',
                            onConfirmBtnTap: () {
                              Navigator.pop(context);
                            },
                          );
                        });
                      }

                      /*if (_isChecked) {
                        provider.calcularCaloriasConsumidas(widget.calorias);
                      } else {
                        provider.removerCaloriasConsumidas(widget.calorias);
                      }*/
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
