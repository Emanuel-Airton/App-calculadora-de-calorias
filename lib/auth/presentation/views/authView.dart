import 'package:app_calorias_diarias/auth/presentation/providers/auth_provider.dart';
import 'package:app_calorias_diarias/auth/presentation/providers/userProfile_provider.dart';
import 'package:app_calorias_diarias/auth/presentation/widgets/alerts/quickAlert_error.dart';
import 'package:app_calorias_diarias/auth/presentation/widgets/alerts/quickAlert_sucess.dart';
import 'package:app_calorias_diarias/auth/presentation/widgets/buttons/auth_button.dart';
import 'package:app_calorias_diarias/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Authview extends StatefulWidget {
  const Authview({super.key});

  @override
  State<Authview> createState() => _AuthviewState();
}

class _AuthviewState extends State<Authview> {
  @override
  Widget build(BuildContext context) {
    // final provider2 = Provider.of<AuthProvider>(context, listen: true);
    return Material(
      child: Consumer<AuthProvider>(
        builder: (context, value, child) {
          return StreamBuilder(
            stream: value.authStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Show a loading indicator
              } else if (snapshot.hasError) {
                return Text(
                  'Error: ${snapshot.error}',
                ); // Display error message
              } else if (snapshot.data != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Splashscreen()),
                  );
                  context.read<UserProfileProvider>().updateFromAuth(
                    context.read<AuthProvider>(),
                  );
                  context.read<UserProfileProvider>().lerAuth();
                });

                // Text('Latest number: ${snapshot.data}'); // Display the data
              } else {
                return Stack(
                  children: [
                    // Fundo colorido
                    Container(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    // Top bar (logout e avatar)
                    Positioned(
                      top: 20,
                      left: 15,
                      right: 15,
                      child: Center(
                        child: Image.asset(
                          'assets/images/calc.png',
                          height: MediaQuery.sizeOf(context).height * 0.3,
                        ),
                      ),
                    ),
                    // Container branco na parte inferior
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.65,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                      ),
                    ),

                    // Card cinza central sobrepondo tudo
                    Positioned(
                      top:
                          MediaQuery.of(context).size.height *
                          0.25, // Ajuste esta posição
                      left: 25,
                      right: 25,
                      child: SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.5,
                        width: MediaQuery.sizeOf(context).width * 0.4,
                        child: Card(
                          margin: EdgeInsets.all(25.0),
                          color: Colors.white,
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: [
                                Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 30,
                                  ),
                                ),
                                SizedBox(height: 50),
                                AuthButton(
                                  assetImage: 'assets/images/google.png',
                                  text: 'Continue com Google',
                                  onPressed: () async {
                                    try {
                                      await value.signInWithGoogle();
                                      if (value.authModel!.userEmail != null) {
                                        /*  QuickAlertSucess().quickAlertSucess(
                                          context,
                                        );*/
                                      }
                                    } catch (e) {
                                      QuickalertError().quickAlertError(
                                        context,
                                        e,
                                      );
                                    }
                                  },
                                ),
                                SizedBox(height: 20),
                                AuthButton(
                                  assetImage: 'assets/images/apple.png',
                                  text: 'Continue com Apple',
                                  onPressed: () async {
                                    try {
                                      await value.signInWithGoogle();
                                      if (value.authModel!.authUserModel !=
                                          null) {
                                        QuickAlertSucess().quickAlertSucess(
                                          context,
                                        );
                                      }
                                    } catch (e) {
                                      QuickalertError().quickAlertError(
                                        context,
                                        e,
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ); // Handle no data case
              }
              return Center(child: CircularProgressIndicator());
            },
          );
        },
        /* child: Stack(
          children: [
            // Fundo colorido
            Container(color: Theme.of(context).colorScheme.inversePrimary),
            // Top bar (logout e avatar)
            Positioned(
              top: 20,
              left: 15,
              right: 15,
              child: Center(
                child: Image.asset(
                  'assets/images/calc.png',
                  height: MediaQuery.sizeOf(context).height * 0.3,
                ),
              ),
            ),
            // Container branco na parte inferior
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.65,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
              ),
            ),
        
            // Card cinza central sobrepondo tudo
            Positioned(
              top:
                  MediaQuery.of(context).size.height *
                  0.25, // Ajuste esta posição
              left: 25,
              right: 25,
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.5,
                width: MediaQuery.sizeOf(context).width * 0.4,
                child: Card(
                  margin: EdgeInsets.all(25.0),
                  color: Colors.white,
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Text(
                          'Login',
                          style: TextStyle(color: Colors.grey, fontSize: 30),
                        ),
                        SizedBox(height: 50),
                        AuthButton(
                          assetImage: 'assets/images/google.png',
                          text: 'Continue com Google',
                          onPressed: () async {
                            try {
                              await provider2.signInWithGoogle();
                              if (provider2.authModel!.authUserModel != null) {
                                QuickAlertSucess().quickAlertSucess(context);
                              }
                            } catch (e) {
                              QuickalertError().quickAlertError(context, e);
                            }
                          },
                        ),
                        SizedBox(height: 20),
                        AuthButton(
                          assetImage: 'assets/images/apple.png',
                          text: 'Continue com Apple',
                          onPressed: () async {
                            try {
                              await provider2.signInWithGoogle();
                              if (provider2.authModel!.authUserModel != null) {
                                QuickAlertSucess().quickAlertSucess(context);
                              }
                            } catch (e) {
                              QuickalertError().quickAlertError(context, e);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),*/
      ),
    );
  }
}
