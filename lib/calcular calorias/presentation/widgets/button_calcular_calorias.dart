import 'package:app_calorias_diarias/auth/presentation/providers/userProfile_provider.dart';
import 'package:app_calorias_diarias/calcular%20calorias/presentation/providers/calorias_provider.dart';
import 'package:app_calorias_diarias/calcular%20calorias/presentation/widgets/alertDialog_mostrar_resultado.dart';
import 'package:app_calorias_diarias/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ButtonCalcularCalorias extends StatelessWidget {
  GlobalKey<FormState> formkey;

  ButtonCalcularCalorias({super.key, required this.formkey});

  @override
  Widget build(BuildContext context) {
    debugPrint('rodando 1');

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      onPressed: () async {
        final userProfileprovider = Provider.of<UserProfileProvider>(
          context,
          listen: false,
        );
        final caloriasProvider = Provider.of<CaloriasProvider>(
          context,
          listen: false,
        );
        if (formkey.currentState!.validate()) {
          if (userProfileprovider.hasCompleteProfile) {
            final Result result = await caloriasProvider.calcularTMB(
              altura: userProfileprovider
                  .authProvider
                  .authModel!
                  .authUserModel!
                  .altura!,
              genero: userProfileprovider
                  .authProvider
                  .authModel!
                  .authUserModel!
                  .genero!,
              peso: userProfileprovider
                  .authProvider
                  .authModel!
                  .authUserModel!
                  .peso!,
              idade: userProfileprovider
                  .authProvider
                  .authModel!
                  .authUserModel!
                  .idade!,
              nivelAtividade: userProfileprovider
                  .authProvider
                  .authModel!
                  .authUserModel!
                  .nivelAtividade!,
              objetivo: userProfileprovider
                  .authProvider
                  .authModel!
                  .authUserModel!
                  .objetivo!,
            );
            if (result is Ok) {
              debugPrint(
                'Valor calculado? ${caloriasProvider.macronutrientesModel?.toJson().toString()}',
              );
              showDialog(
                context: context,
                builder: (context) => AlertdialogMostrarResultado(
                  calorias: caloriasProvider.caloriasModel?.caloriasTotais ?? 0,
                ),
              );

              userProfileprovider
                      .authProvider
                      .authModel
                      ?.authUserModel
                      ?.macronutrientesDiarios =
                  caloriasProvider.macronutrientesModel;
              userProfileprovider
                      .authProvider
                      .authModel
                      ?.authUserModel
                      ?.caloriasModel =
                  caloriasProvider.caloriasModel;
              //provider.authUserModel.macronutrientesDiarios?.calorias = provider.caloriasTotais;
              debugPrint(
                'objetivo: ${userProfileprovider.objetivo.toString()}',
              );
              userProfileprovider.salvarAuth();
            } else if (result is Error) {
              debugPrint(result.exception.toString());
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Center(child: Text('Erro ao calcular calorias')),
                ),
              );
            }
          }
        }
      },
      // child: const Text('Calcular calorias'),
      child: Consumer<CaloriasProvider>(
        builder: (context, value, child) {
          debugPrint(value.isCalculate.toString());
          return value.isCalculate
              ? CircularProgressIndicator()
              : Text('Calcular calorias');
        },
      ),
    );
    // },
    //  );
  }
}
