import 'package:app_calorias_diarias/auth/presentation/providers/auth_provider.dart';
import 'package:app_calorias_diarias/auth/presentation/providers/userProfile_provider.dart';
import 'package:app_calorias_diarias/calcular%20calorias/presentation/providers/calorias_provider.dart';
import 'package:app_calorias_diarias/calcular%20calorias/presentation/views/calcular_calorias_view.dart';
import 'package:app_calorias_diarias/chat/presentation/providers/chat_provider.dart';
import 'package:app_calorias_diarias/chat/presentation/views/chat_refeicoes_view.dart';
import 'package:app_calorias_diarias/mostrar%20calorias/presentation/views/mostrar_calorias_view.dart';
import 'package:app_calorias_diarias/perfil/presentation/views/perfil_usuario_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    ChatRefeicoesView(),
    PerfilUsuarioView(), //1
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      lerRefeicoesCache();
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      context.read<UserProfileProvider>().updateFromAuth(
        context.read<AuthProvider>(),
      );
      context.read<UserProfileProvider>().lerAuth();
      context.read<CaloriasProvider>().setCaloriasConsumidas(
        caloriasConsumidas: authProvider
            .authModel
            ?.authUserModel
            ?.caloriasModel
            ?.caloriasConsumidas,
        caloriasTotais: authProvider
            .authModel
            ?.authUserModel
            ?.caloriasModel
            ?.caloriasTotais,
      );
    });
  }

  void lerRefeicoesCache() {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.obterRefeicoesCache();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: true);

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
                        Text(
                          'Olá, ${authProvider.authModel?.userName}',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        CircleAvatar(
                          backgroundImage:
                              authProvider.authModel?.photoUrl != null
                              ? NetworkImage(
                                  authProvider.authModel!.photoUrl.toString(),
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
        type: BottomNavigationBarType.fixed,
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
            label: 'Calorias',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank),
            tooltip: 'info',
            label: 'Refeições',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            tooltip: 'perfil',
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
