import 'package:app_calorias_diarias/auth/presentation/providers/auth_provider.dart';
import 'package:app_calorias_diarias/auth/presentation/providers/userProfile_provider.dart';
import 'package:app_calorias_diarias/calcular%20calorias/presentation/providers/calorias_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DropdownbuttomNivelatividade extends StatefulWidget {
  const DropdownbuttomNivelatividade({super.key});

  @override
  State<DropdownbuttomNivelatividade> createState() =>
      _DropdownbuttomNivelatividadeState();
}

class _DropdownbuttomNivelatividadeState
    extends State<DropdownbuttomNivelatividade> {
  List<Map<String, String>> itens = [
    {'situação': 'Sedentário', 'complemento': '(pouca ou nenhuma atividade)'},
    {'situação': 'Levemente ativo', 'complemento': '(1 a 3 vezes na semana)'},
    {
      'situação': 'Moderadamente ativo',
      'complemento': '(3 a 5 vezes na semana)',
    },
    {'situação': 'Muito ativo', 'complemento': '(5 ou 6 vezes/semana)'},
    {
      'situação': 'Extremamente ativo',
      'complemento': '(exercícios diários intensos)',
    },
  ];
  String? _value;

  @override
  Widget build(BuildContext context) {
    //final provider = Provider.of<CaloriasProvider>(context, listen: false);
    final provider = context.read<UserProfileProvider>();
    return LayoutBuilder(
      builder: (context, constraints) {
        return DropdownButtonFormField(
          validator: (value) {
            if (value == null) {
              return 'Informe seu nível de atividade';
            }
            return null;
          },
          isExpanded: true,
          borderRadius: BorderRadius.circular(15),
          hint: Text(
            'Selecione seu nível de atividade',
            style: TextStyle(color: Colors.grey),
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
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
          value:
              provider.authProvider.authModel?.authUserModel?.nivelAtividade ??
              _value,
          items: itens
              .map(
                (e) => DropdownMenuItem(
                  value: e['situação'],
                  child: SizedBox(
                    width: constraints.maxWidth, // 90% da largura disponível
                    child: Text(
                      '${e['situação'].toString()} ${e['complemento'].toString()}',
                      style: TextStyle(color: Colors.grey[600]),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: (novoValor) {
            setState(() {
              _value = novoValor.toString();
              debugPrint(novoValor.toString());
              //provider.authUserModel?.nivelAtividade = _value;
              provider.updateProfile(nivelAtividade: _value);
            });
          },
        );
      },
    );
  }
}
