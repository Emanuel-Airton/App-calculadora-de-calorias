import 'package:app_calorias_diarias/auth/presentation/providers/userProfile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:provider/provider.dart';

class TextformfieldAltura extends StatefulWidget {
  const TextformfieldAltura({super.key});

  @override
  State<TextformfieldAltura> createState() => _TextformfieldAlturaState();
}

class _TextformfieldAlturaState extends State<TextformfieldAltura> {
  late MaskedTextController maskedTextController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final provider = Provider.of<UserProfileProvider>(context, listen: false);
    maskedTextController = MaskedTextController(mask: '000');
    if (provider.authProvider.authModel?.authUserModel?.altura != null) {
      maskedTextController.text = provider
          .authProvider
          .authModel!
          .authUserModel!
          .altura
          .toString();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    maskedTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('reload');

    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return 'Informe a altura';
        }
        return null;
      },
      onChanged: (value) {
        /*   final provider = Provider.of<CaloriasProvider>(context, listen: false);
        provider.authUserModel?.altura = double.tryParse(value) ?? 0;*/
        final provider = context.read<UserProfileProvider>();
        provider.updateProfile(altura: double.tryParse(value) ?? 0);
      },
      controller: maskedTextController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        // icon: Icon(Icons.height),
        filled: true,
        fillColor: Theme.of(
          context,
        ).colorScheme.inversePrimary.withOpacity(0.3),
        hint: Text('Altura em cm', style: TextStyle(color: Colors.grey)),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(15),
        ),
        suffixText: 'cm',
      ),
    );
  }
}
