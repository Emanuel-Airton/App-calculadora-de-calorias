import 'package:app_calorias_diarias/auth/presentation/providers/auth_provider.dart';
import 'package:app_calorias_diarias/auth/presentation/providers/userProfile_provider.dart';
import 'package:app_calorias_diarias/calcular%20calorias/presentation/providers/calorias_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:provider/provider.dart';

class TextFormFieldIdade extends StatefulWidget {
  const TextFormFieldIdade({super.key});

  @override
  State<TextFormFieldIdade> createState() => _TextFormFieldIdadeState();
}

class _TextFormFieldIdadeState extends State<TextFormFieldIdade> {
  late MaskedTextController maskedTextController;
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<UserProfileProvider>(context, listen: false);
    maskedTextController = MaskedTextController(mask: '000');
    if (provider.authProvider.authModel?.authUserModel?.idade != null) {
      maskedTextController.text = provider
          .authProvider
          .authModel!
          .authUserModel!
          .idade
          .toString();
    }
  }

  @override
  void dispose() {
    super.dispose();
    maskedTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (value) {
        /* final provider = Provider.of<CaloriasProvider>(context, listen: false);
        provider.authUserModel.idade = int.tryParse(value) ?? 0;*/
        final provider = context.read<UserProfileProvider>();
        provider.updateProfile(idade: int.tryParse(value) ?? 0);
      },
      validator: (value) {
        if (value!.isEmpty) {
          return 'Informe a idade';
        }
        return null;
      },
      controller: maskedTextController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        // icon: Icon(Icons.height),
        filled: true,
        fillColor: Theme.of(
          context,
        ).colorScheme.inversePrimary.withOpacity(0.3),
        hint: Text('idade', style: TextStyle(color: Colors.grey)),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(15),
        ),
        suffixText: 'Anos',
      ),
    );
  }
}
