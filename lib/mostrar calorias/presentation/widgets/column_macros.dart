import 'package:app_calorias_diarias/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ColumnMacros extends StatelessWidget {
  const ColumnMacros({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileProvider>(
      builder: (context, userProfileProvider, child) {
        return Column(
          children: [
            sizedbox(
              context: context,
              texto: 'Carboidratos',
              macrosRecebidos:
                  userProfileProvider
                      .authProvider
                      .authModel
                      ?.authUserModel
                      ?.macronutrientesDiarios
                      ?.carboidratos
                      .toString() ??
                  /*   value.authUserModel?.macronutrientesDiarios?.proteinas
                      .toString() ??*/
                  '--',

              /*     value.authUserModel?.macronutrientesDiarios?.carboidratos
                      .toString() ??*/
              //  '--',
              assetImage: 'assets/images/carbs.png',
            ),

            sizedbox(
              context: context,
              texto: 'Proteínas',
              macrosRecebidos:
                  userProfileProvider
                      .authProvider
                      .authModel
                      ?.authUserModel
                      ?.macronutrientesDiarios
                      ?.proteinas
                      .toString() ??
                  /*   value.authUserModel?.macronutrientesDiarios?.proteinas
                      .toString() ??*/
                  '--',
              assetImage: 'assets/images/protein.png',
            ),
            sizedbox(
              context: context,
              texto: 'Gorduras',
              macrosRecebidos:
                  userProfileProvider
                      .authProvider
                      .authModel
                      ?.authUserModel
                      ?.macronutrientesDiarios
                      ?.gorduras
                      .toString() ??
                  '--',
              assetImage: 'assets/images/fat.png',
            ),
            sizedbox(
              context: context,
              texto: 'Consumo de agua',
              macrosRecebidos: '2.5 litros',
              assetImage: 'assets/images/water.png',
            ),
          ],
        );
      },
    );
  }
}

Widget sizedbox({
  required BuildContext context,
  required String texto,
  required String macrosRecebidos,
  required String assetImage,
}) {
  return SizedBox(
    height: MediaQuery.sizeOf(context).height * 0.1,
    width: MediaQuery.sizeOf(context).width,
    child: LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          margin: EdgeInsets.fromLTRB(25, 0, 25, 15),
          elevation: 4.0,
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.0),
                height: constraints.maxHeight,
                width: constraints.maxWidth * 0.3,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: Column(
                  children: [
                    Image.asset(
                      assetImage,
                      height: constraints.maxHeight * 0.45,
                    ),
                    Text(
                      texto,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: Text(
                    macrosRecebidos,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}
