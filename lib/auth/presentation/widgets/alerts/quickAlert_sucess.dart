import 'package:app_calorias_diarias/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class QuickAlertSucess {
  Future<dynamic> quickAlertSucess(BuildContext context) async {
    return await QuickAlert.show(
      context: context,
      title: 'Usuario logado',
      type: QuickAlertType.success,

      onConfirmBtnTap: () {
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Splashscreen()),
        );
      },
    );
  }
}
