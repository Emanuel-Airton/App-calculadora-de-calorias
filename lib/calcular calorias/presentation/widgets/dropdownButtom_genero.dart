import 'package:app_calorias_diarias/auth/presentation/providers/auth_provider.dart';
import 'package:app_calorias_diarias/calcular%20calorias/presentation/providers/calorias_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DropdownbuttomGenero extends StatefulWidget {
  const DropdownbuttomGenero({super.key});

  @override
  State<DropdownbuttomGenero> createState() => _DropdownbuttomGeneroState();
}

class _DropdownbuttomGeneroState extends State<DropdownbuttomGenero> {
  List<String> itens = ['masculino', 'feminino'];
  String? _value;
  @override
  Widget build(BuildContext context) {
    //final provider = Provider.of<CaloriasProvider>(context, listen: false);
    final provider = context.read<UserProfileProvider>();
    return DropdownButtonFormField(
      validator: (value) {
        if (value == null) {
          return 'Selecione o gênero';
        }
        return null;
      },
      borderRadius: BorderRadius.circular(15),
      hint: Text(
        'Selecione o gênero',
        style: TextStyle(fontSize: 13, color: Colors.grey),
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(
          context,
        ).colorScheme.inversePrimary.withOpacity(0.2),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      value: provider.authProvider.authModel?.authUserModel?.genero ?? _value,
      items: itens
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(
                e.toString(),
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          )
          .toList(),
      onChanged: (novoValor) {
        setState(() {
          _value = novoValor.toString();
          debugPrint(_value.toString());
          //provider.authUserModel?.genero = _value;
          provider.updateProfile(genero: _value);
        });
      },
    );
  }
}
