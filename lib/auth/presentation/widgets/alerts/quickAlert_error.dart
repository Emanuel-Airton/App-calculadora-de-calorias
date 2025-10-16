import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class QuickalertError {
  Future<dynamic> quickAlertError(BuildContext context, Object error) async {
    return await QuickAlert.show(
      context: context,
      title: error.toString(),
      type: QuickAlertType.error,
      onConfirmBtnTap: () async {
        Navigator.pop(context);
      },
    );
  }
}
