import 'package:app_calorias_diarias/auth/presentation/providers/auth_provider.dart';
import 'package:app_calorias_diarias/auth/presentation/providers/userProfile_provider.dart';
import 'package:app_calorias_diarias/auth/presentation/views/authView.dart';
import 'package:app_calorias_diarias/calcular%20calorias/presentation/providers/calorias_provider.dart';
import 'package:app_calorias_diarias/chat/domain/models/plano_alimentar_model.dart';
import 'package:app_calorias_diarias/chat/presentation/providers/chat_provider.dart';
import 'package:app_calorias_diarias/home.dart';
import 'package:app_calorias_diarias/verificar%20dia/data/repositories/verifica_dia_repository.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    testarHive();
    super.initState();
    verificarDiaAtual();

    /*debugPrint(
      'calorias consumidas: ${context.read<UserProfileProvider>().authProvider.authModel?.authUserModel?.caloriasModel?.caloriasConsumidas.toString()}',
    );
    //final caloriasProvider = Provider.of<CaloriasProvider>(context, listen: false);
    context.read<CaloriasProvider>().setCaloriasConsumidas(
      caloriasConsumidas: context
          .read<UserProfileProvider>()
          .authProvider
          .authModel
          ?.authUserModel
          ?.caloriasModel
          ?.caloriasConsumidas,
    );
    debugPrint(
      'calorias provider: ${context.read<CaloriasProvider>().caloriasConsumidas.toString()}',
    );*/
  }

  Future<void> verificarDiaAtual() async {
    final diaRepo = context.read<VerificaDiaRepository>();

    bool isMesmoDia = await diaRepo.verificaDiaIgualAtual();
    if (isMesmoDia) {
      debugPrint('dia atual é o mesmo dia salvo');
    } else {
      limparDadosDiarios();
      diaRepo.salvarDiaAtual();
    }
  }

  Future<void> limparDadosDiarios() async {
    context.read<CaloriasProvider>().setCaloriasConsumidas(
      caloriasConsumidas: 0,
    );
    await context.read<ChatProvider>().resetarRefeicoes();
    context.read<UserProfileProvider>().updateProfile(caloriasConsumidas: 0);
  }

  void testarHive() async {
    final box = Hive.box<PlanoAlimentar>('planoAlimentarBox');
    /*
    // Teste simples
    final testePlano = PlanoAlimentar(
      listRefeicao: [
        RefeicaoModel(
          nomeRefeicao: "Teste",
          alimentos: ["Alimento teste"],
          macros: {"calorias": 100},
        ),
      ],
    );
  
    await box.put('teste', testePlano);*/
    //await box.delete('teste');
    final recuperado = box.get('teste');

    // debugPrint('Teste Hive - Salvo: ${testePlano.toMap()}');
    debugPrint('Teste Hive - Recuperado: ${recuperado?.toMap()}');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    debugPrint('dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Material(
      color: Theme.of(context).colorScheme.inversePrimary,
      child: FutureBuilder(
        future: Future.delayed(
          Duration(seconds: 3),
        ).then((value) => authProvider.authModel),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              throw UnimplementedError();
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/calc.png',
                      height: MediaQuery.sizeOf(context).height * 0.3,
                    ),
                    CircularProgressIndicator(color: Colors.white),
                  ],
                ),
              );

            case ConnectionState.active:
              throw UnimplementedError();
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(child: Text('erro'));
              }
              debugPrint(snapshot.data?.userEmail.toString());
              return snapshot.data?.userEmail == null ? Authview() : Home();
          }
        },
      ),
    );
  }
}
