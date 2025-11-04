import 'package:app_calorias_diarias/auth/presentation/providers/userProfile_provider.dart';
import 'package:app_calorias_diarias/chat/presentation/providers/chat_provider.dart';
import 'package:app_calorias_diarias/chat/presentation/widgets/alertDialog_gerar_refeicao.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ButtomGerarRefeicoes extends StatelessWidget {
  const ButtomGerarRefeicoes({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProfileProvider>(context, listen: false);
    debugPrint('reload 1');
    debugPrint(
      'calorias: ${provider.authProvider.authModel?.authUserModel?.objetivo.toString()}',
    );
    return ElevatedButton(
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // Rounded corners
            // Border
          ),
        ),
        backgroundColor: WidgetStateProperty.all(
          Theme.of(context).colorScheme.inversePrimary,
        ),
        overlayColor: WidgetStateProperty.resolveWith<Color?>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.pressed)) {
            return Colors.white; // Color when pressed
          }
          if (states.contains(WidgetState.hovered)) {
            return Colors.white; // Color when hovered
          }
          return null; // Use default
        }),
      ),
      onPressed: () {
        // debugPrint(provider.authUserModel?.authString());

        try {
          if (provider
                      .authProvider
                      .authModel
                      ?.authUserModel
                      ?.macronutrientesDiarios !=
                  null &&
              provider.authProvider.authModel?.authUserModel?.objetivo !=
                  null) {
            final chatprovider = Provider.of<ChatProvider>(
              context,
              listen: false,
            );

            chatprovider.verificarUltimaRequisicao();
            //debugPrint(valor.toString());
            provider
                    .authProvider
                    .authModel
                    ?.authUserModel
                    ?.macronutrientesDiarios
                    ?.listFontesCarboidratos =
                null;
            provider
                    .authProvider
                    .authModel
                    ?.authUserModel
                    ?.macronutrientesDiarios
                    ?.listFontesProteinas =
                null;

            if (chatprovider.tempoProximaRequisicao == null) {
              showDialog(
                context: context,
                builder: (context) => AlertdialogGerarRefeicao(),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  content: Center(
                    child: Text(
                      'Aguarde ${chatprovider.tempoProximaRequisicao} minutos para gerar um novo plano',
                    ),
                  ),
                ),
              );
            }
            /*  chatprovider.gerarRefeicoes(
              provider
                  .authProvider
                  .authModel!
                  .authUserModel!
                  .macronutrientesDiarios!,
              provider.authProvider.authModel!.authUserModel!.objetivo!,
            );*/
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                content: Center(child: Text('Calcule primeiro as calorias!')),
              ),
            );
          }
        } catch (e) {
          debugPrint('erro');
        }
      },
      child: Text('Gerar plano alimentar'),
    );
  }
}
