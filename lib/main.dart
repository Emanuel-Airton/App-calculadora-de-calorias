import 'package:app_calorias_diarias/auth/domain/models/auth_user_model.dart';
import 'package:app_calorias_diarias/auth/presentation/providers/auth_provider.dart';
import 'package:app_calorias_diarias/calcular%20calorias/domain/models/calorias_model.dart';
import 'package:app_calorias_diarias/calcular%20calorias/presentation/providers/calorias_provider.dart';
import 'package:app_calorias_diarias/chat/domain/models/macronutrientes.dart';
import 'package:app_calorias_diarias/chat/domain/models/plano_alimentar_model.dart';
import 'package:app_calorias_diarias/chat/domain/models/refeicao_model.dart';
import 'package:app_calorias_diarias/chat/presentation/providers/chat_provider.dart';
import 'package:app_calorias_diarias/splashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  // Registrar os adaptadores manualmente
  Hive.registerAdapter(PlanoAlimentarAdapter());
  Hive.registerAdapter(RefeicaoModelAdapter());

  Hive.registerAdapter((AuthUserModelAdapter()));
  Hive.registerAdapter((MacronutrientesModelAdapter()));
  Hive.registerAdapter((CaloriasModelAdapter()));

  // Abrir a caixa
  await Hive.openBox<PlanoAlimentar>('planoAlimentarBox');
  await Hive.openBox<AuthUserModel>('userProfile');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider.listen()),

        ChangeNotifierProxyProvider<AuthProvider, UserProfileProvider>(
          create: (context) =>
              UserProfileProvider(context.read<AuthProvider>()),
          update: (context, authProvider, profileProvider) =>
              profileProvider!..updateFromAuth(authProvider),
        ),

        ChangeNotifierProvider(create: (context) => CaloriasProvider()),
        ChangeNotifierProvider(create: (context) => ChatProvider()),
        //  ChangeNotifierProvider(create: (context) => AuthProvider.listen()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        buttonTheme: ButtonThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xA7FFEB01)),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.tealAccent),
      ),
      home: Splashscreen(),
    );
  }
}
