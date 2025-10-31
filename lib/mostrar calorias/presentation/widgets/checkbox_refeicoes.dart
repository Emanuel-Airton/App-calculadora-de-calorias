import 'package:app_calorias_diarias/auth/presentation/providers/auth_provider.dart';
import 'package:app_calorias_diarias/calcular%20calorias/presentation/providers/calorias_provider.dart';
import 'package:app_calorias_diarias/chat/data/repositories/chat_repositorie.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class CheckboxRefeicoes extends StatefulWidget {
  String? nomeRefeicaoSelecionada;
  final calorias;
  bool? valor;
  CheckboxRefeicoes({
    super.key,
    this.nomeRefeicaoSelecionada,
    this.valor,
    this.calorias,
  });

  @override
  State<CheckboxRefeicoes> createState() => _CheckboxRefeicoesState();
}

class _CheckboxRefeicoesState extends State<CheckboxRefeicoes> {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<CaloriasProvider>(context, listen: false);

    provider.refeicoesSelecionadas[widget.nomeRefeicaoSelecionada!] =
        widget.valor!;
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
        child: Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Row(
            children: [
              Text(
                widget.nomeRefeicaoSelecionada!,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w700,
                ),
              ),
              Consumer<CaloriasProvider>(
                builder: (context, caloriasProvider, child) {
                  //provider.refeicoesSelecionadas[widget.item!] = widget.valor!;
                  return Checkbox(
                    side: BorderSide(
                      width: 3,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    value:
                        caloriasProvider.refeicoesSelecionadas[widget
                            .nomeRefeicaoSelecionada] ??
                        false,

                    activeColor: Theme.of(context).colorScheme.inversePrimary,
                    onChanged: (bool? value) {
                      debugPrint(widget.calorias.runtimeType.toString());
                      caloriasProvider.alternarRefeicao(
                        nomeRefeicao: widget.nomeRefeicaoSelecionada!,
                        iselect: value!,
                        calorias: widget.calorias.runtimeType == double
                            ? widget.calorias.round()
                            : widget.calorias,
                        caloriasTotais: userProfileProvider
                            .authProvider
                            .authModel!
                            .authUserModel!
                            .macronutrientesDiarios!
                            .calorias!,
                      );

                      userProfileProvider.updateProfile(
                        caloriasConsumidas: caloriasProvider.caloriasConsumidas,
                      );
                      context.read<ChatRepository>().atualizarPlano(
                        nomeRefeicao: widget.nomeRefeicaoSelecionada!,
                        valor: value,
                      );

                      if (caloriasProvider.caloriasModel?.caloriasTotais ==
                          caloriasProvider.caloriasModel?.caloriasConsumidas) {
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
