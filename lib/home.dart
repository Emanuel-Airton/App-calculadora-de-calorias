import 'package:app_calorias_diarias/auth/presentation/providers/auth_provider.dart';
import 'package:app_calorias_diarias/auth/presentation/views/authView.dart';
import 'package:app_calorias_diarias/calcular%20calorias/presentation/providers/calorias_provider.dart';
import 'package:app_calorias_diarias/calcular%20calorias/presentation/views/calcular_calorias_view.dart';
import 'package:app_calorias_diarias/chat/presentation/providers/chat_provider.dart';
import 'package:app_calorias_diarias/chat/presentation/views/chat_refeicoes_view.dart';
import 'package:app_calorias_diarias/mostrar%20calorias/presentation/views/mostrar_calorias_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int indiceAtual = 0;
  final List<Widget> listaTelas = [
    MostrarCaloriasView(), //2
    CalcularCaloriasView(), //0
    ChatRefeicoesView(), //1
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    debugPrint('test');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      lerRefeicao();

      final provider2 = Provider.of<AuthProvider>(context, listen: false);
      debugPrint(
        'calorias consumidas pelo usuario: ${provider2.authModel?.authUserModel?.caloriasModel?.caloriasConsumidas.toString()}',
      );
      context.read<CaloriasProvider>().setCaloriasConsumidas(
        caloriasConsumidas: provider2
            .authModel
            ?.authUserModel
            ?.caloriasModel
            ?.caloriasConsumidas,
        caloriasTotais:
            provider2.authModel?.authUserModel?.caloriasModel?.caloriasTotais,
      );
      debugPrint(
        'calorias provider: ${context.read<CaloriasProvider>().caloriasConsumidas.toString()}',
      );
      debugPrint(
        'calorias provider: ${context.read<CaloriasProvider>().caloriasTotais.toString()}',
      );
      await context.read<CaloriasProvider>().calcularPorcentagem();
    });
  }

  lerRefeicao() {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.obterRefeicoesCache();
  }

  @override
  Widget build(BuildContext context) {
    final provider2 = Provider.of<AuthProvider>(context, listen: true);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: MediaQuery.sizeOf(context).height,
            color: Theme.of(
              context,
            ).colorScheme.inversePrimary.withOpacity(0.8),
            child: Padding(
              padding: const EdgeInsets.only(top: 70),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () async {
                            try {
                              QuickAlert.show(
                                context: context,
                                title: 'Fazer logout',
                                type: QuickAlertType.confirm,
                                onConfirmBtnTap: () async {
                                  await provider2.signOut();
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Authview(),
                                    ),
                                  );
                                },
                                onCancelBtnTap: () => Navigator.pop(context),
                                text: 'Deseja remover usuario?',
                              );
                            } catch (e) {
                              debugPrint('erro: $e');
                            }
                          },
                          icon: Icon(Icons.logout),
                        ),
                        Text(
                          'Olá, ${provider2.authModel?.userName}',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        CircleAvatar(
                          backgroundImage: provider2.authModel?.photoUrl != null
                              ? NetworkImage(
                                  provider2.authModel!.photoUrl.toString(),
                                )
                              : AssetImage('assets/images/user.png')
                                    as ImageProvider,
                        ),
                      ],
                    ),
                  ),
                  listaTelas[indiceAtual],
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).colorScheme.inversePrimary,
        backgroundColor: Colors.grey[200],
        currentIndex: indiceAtual,
        onTap: (value) async {
          if (value == 2) {
            final chatProvider = context.read<ChatProvider>();
            chatProvider.obterRefeicoesCache();
          }
          setState(() {
            indiceAtual = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            tooltip: 'home',
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            tooltip: 'calcular',
            label: 'Calcular calorias',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank),
            tooltip: 'info',
            label: 'Refeições',
          ),
        ],
      ),
    );
  }
}
