import 'package:app_calorias_diarias/auth/presentation/providers/auth_provider.dart';
import 'package:app_calorias_diarias/calcular%20calorias/presentation/providers/calorias_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TouglebuttonObjetivo extends StatefulWidget {
  const TouglebuttonObjetivo({super.key});

  @override
  State<TouglebuttonObjetivo> createState() => _TouglebuttonObjetivoState();
}

class _TouglebuttonObjetivoState extends State<TouglebuttonObjetivo> {
  final isSelected = [
    {'obj': 'Ganhar massa', 'valor': false},
    {'obj': 'Emagrecer', 'valor': false},
  ];
  List? list;
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<UserProfileProvider>(context, listen: false);
    if (provider.authProvider.authModel?.authUserModel?.objetivo != null) {
      for (int i = 0; i < isSelected.length; i++) {
        if (isSelected[i].containsValue(
          provider.authProvider.authModel?.authUserModel?.objetivo,
        )) {
          isSelected[i]['valor'] = true;
          debugPrint(isSelected[i].toString());
          break;
        }
      }
    }
    list = isSelected;
  }

  @override
  Widget build(BuildContext context) {
    //final provider = Provider.of<CaloriasProvider>(context, listen: false);
    final provider = context.read<UserProfileProvider>();

    return ToggleButtons(
      borderWidth: 3,
      constraints: BoxConstraints(maxWidth: double.maxFinite),
      color: Colors.grey[700],
      selectedColor: Theme.of(context).colorScheme.inversePrimary,
      selectedBorderColor: Theme.of(context).colorScheme.inversePrimary,
      fillColor: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.08),
      splashColor: Theme.of(
        context,
      ).colorScheme.inversePrimary.withOpacity(0.12),
      hoverColor: Theme.of(
        context,
      ).colorScheme.inversePrimary.withOpacity(0.04),
      borderRadius: BorderRadius.circular(15.0),
      isSelected: list!.map<bool>((e) => e['valor']).toList(),
      onPressed: (index) {
        setState(() {
          for (int indice = 0; indice < list!.length; indice++) {
            if (indice == index) {
              list![indice]['valor'] = !list![indice]['valor'];
              //debugPrint(isSelected[indice]['obj'].toString());
              provider.updateProfile(
                objetivo: isSelected[indice]['obj'].toString(),
              );
            } else {
              list![indice]['valor'] = false;
            }
          }
        });
      },
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Ganhar massa'),
        ),
        Padding(padding: const EdgeInsets.all(8.0), child: Text('Emagrecer')),
      ],
    );
  }
}
