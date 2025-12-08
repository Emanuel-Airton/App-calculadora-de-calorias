import 'package:app_calorias_diarias/auth/presentation/providers/userProfile_provider.dart';
import 'package:app_calorias_diarias/auth/presentation/views/authView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:app_calorias_diarias/auth/presentation/providers/auth_provider.dart';

class PerfilUsuarioView extends StatefulWidget {
  const PerfilUsuarioView({super.key});

  @override
  State<PerfilUsuarioView> createState() => _PerfilUsuarioViewState();
}

class _PerfilUsuarioViewState extends State<PerfilUsuarioView> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height * 0.6,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.40,
            left: 20,
            right: 20,
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.3,
              width: MediaQuery.sizeOf(context).width * 0.95,
              child: Consumer<AuthProvider>(
                builder: (context, value, child) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      return Card(
                        color: Colors.white,
                        elevation: 4,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.inversePrimary.withOpacity(0.3),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                              ),

                              height: constraints.maxHeight * 0.3,
                              width: constraints.maxWidth,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsetsGeometry.all(5),
                                    child: Text(
                                      value.authModel!.userName.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      value.authModel!.userEmail.toString(),
                                      // style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                                left: 10,
                                right: 10,
                              ),
                              child: Card(
                                color: Colors.white,
                                elevation: 4,
                                child: Padding(
                                  padding: EdgeInsetsGeometry.all(5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.share),
                                          Text('Compartilhar'),
                                        ],
                                      ),

                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.chevron_right),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                              ),
                              child: Card(
                                color: Colors.white,
                                elevation: 4,
                                child: Padding(
                                  padding: EdgeInsetsGeometry.all(5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.logout),
                                          Text('Sair'),
                                        ],
                                      ),

                                      IconButton(
                                        onPressed: () {
                                          try {
                                            QuickAlert.show(
                                              context: context,
                                              title: 'Fazer logout',
                                              type: QuickAlertType.confirm,
                                              onConfirmBtnTap: () async {
                                                context
                                                    .read<AuthProvider>()
                                                    .signOut();
                                                context
                                                    .read<UserProfileProvider>()
                                                    .closeBox();

                                                Navigator.pop(context);
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        Authview(),
                                                  ),
                                                );
                                              },
                                              onCancelBtnTap: () =>
                                                  Navigator.pop(context),
                                              text: 'Deseja remover usuario?',
                                            );
                                          } catch (e) {
                                            debugPrint('erro: $e');
                                          }
                                        },
                                        icon: Icon(Icons.chevron_right),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
