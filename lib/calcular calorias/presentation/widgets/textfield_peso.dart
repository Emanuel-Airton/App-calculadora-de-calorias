import 'package:app_calorias_diarias/auth/presentation/providers/auth_provider.dart';
import 'package:app_calorias_diarias/calcular%20calorias/presentation/providers/calorias_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:provider/provider.dart';

class TextFieldPeso extends StatefulWidget {
  const TextFieldPeso({super.key});

  @override
  State<TextFieldPeso> createState() => _TextFieldPesoState();
}

class _TextFieldPesoState extends State<TextFieldPeso> {
  late MaskedTextController controller;
  @override
  void initState() {
    final provider = Provider.of<UserProfileProvider>(context, listen: false);
    controller = MaskedTextController(
      mask:
          provider.authProvider.authModel?.authUserModel?.peso
                  .toString()
                  .length ==
              4
          ? '00.0'
          : '000.0',
      translator: {'0': RegExp(r'[0-9]')},
    );
    if (provider.authProvider.authModel?.authUserModel?.peso != null) {
      controller.text = provider.authProvider.authModel!.authUserModel!.peso
          .toString();
    }
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    debugPrint('dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return 'Informe o peso';
        }
        return null;
      },
      controller: controller,
      onChanged: (value) {
        /*   final provider = Provider.of<UserProfileProvider>(
          context,
          listen: false,
        );*/
        controller.mask = controller.text.length == 2 ? '00.0' : '000.0';
        final provider = context.read<UserProfileProvider>();
        if (value.isNotEmpty) {
          //  provider.peso = double.tryParse(value) ?? 0;
          provider.updateProfile(peso: double.tryParse(value) ?? 0.0);
        }
      },
      // maxLength: 5,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        // icon: Icon(Icons.scale),
        filled: true,
        fillColor: Theme.of(
          context,
        ).colorScheme.inversePrimary.withOpacity(0.3),
        hint: Text('Peso em kg', style: TextStyle(color: Colors.grey)),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(15),
        ),
        suffixText: 'Kg',
      ),
    );
  }
}
