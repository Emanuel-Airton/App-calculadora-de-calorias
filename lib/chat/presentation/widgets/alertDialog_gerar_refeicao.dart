import 'package:app_calorias_diarias/auth/presentation/providers/auth_provider.dart';
import 'package:app_calorias_diarias/chat/presentation/providers/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlertdialogGerarRefeicao extends StatefulWidget {
  const AlertdialogGerarRefeicao({super.key});

  @override
  State<AlertdialogGerarRefeicao> createState() =>
      _AlertdialogGerarRefeicaoState();
}

class _AlertdialogGerarRefeicaoState extends State<AlertdialogGerarRefeicao> {
  static const List<String> listCarboidratos = [
    'arroz',
    'cuscuz',
    'macarrão',
    'batata doce',
    'batata inglesa',
    'tapioca',
    'pão',
    'aveia',
    'frutas',
  ];
  static const List<String> listProteinas = [
    'carne bovina',
    'frango',
    'peixe',
    'ovos',
    'queijo',
    'whey protein',
  ];
  List<String> listaCarboReserva = [];
  List<String> listaProteinaReserva = [];

  List<String> list = [];
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProfileProvider>(context, listen: false);

    final chatprovider = Provider.of<ChatProvider>(context, listen: false);

    return AlertDialog(
      title: Text(
        'Gerar plano alimentar',
        style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold),
      ),

      actions: [
        ElevatedButton(
          onPressed: () {
            chatprovider.verificarUltimaRequisicao();

            chatprovider.gerarRefeicoes(
              provider
                  .authProvider
                  .authModel!
                  .authUserModel!
                  .macronutrientesDiarios!,
              provider.authProvider.authModel!.authUserModel!.objetivo!,
            );

            Navigator.pop(context);
          },
          child: Text('Gerar plano'),
        ),
        ElevatedButton(
          onPressed: () {
            provider
                .authProvider
                .authModel
                ?.authUserModel
                ?.macronutrientesDiarios
                ?.listFontesCarboidratos
                ?.clear();
            provider
                .authProvider
                .authModel
                ?.authUserModel
                ?.macronutrientesDiarios
                ?.listFontesProteinas
                ?.clear();

            Navigator.pop(context);
          },
          child: Text('Cancelar'),
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selecione suas fontes de carboidratos diárias',
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w700),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            height: 200,
            width: MediaQuery.sizeOf(context).width * 0.9,
            decoration: BoxDecoration(
              color: Colors.grey[300],

              borderRadius: BorderRadius.circular(15),
            ),
            child: Wrap(
              spacing: 4,
              children: listCarboidratos.map((e) {
                //  Map<String, bool> map = {e: false};
                //list.add(map);

                return FilterChip(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(15),
                  ),
                  side: BorderSide.none,
                  selectedColor: Theme.of(context).colorScheme.inversePrimary,
                  selected: listaCarboReserva.contains(e),
                  onSelected: (selected) {
                    setState(() {
                      listCarboidratos.contains(e);
                      //_isSelected = selected;
                      if (selected) {
                        listaCarboReserva.add(e);
                      } else {
                        listaCarboReserva.removeWhere(
                          (element) => element == e,
                        );
                      }
                      if (listaCarboReserva.isNotEmpty) {
                        provider
                                .authProvider
                                .authModel
                                ?.authUserModel
                                ?.macronutrientesDiarios
                                ?.listFontesCarboidratos =
                            listaCarboReserva;
                      }

                      //  debugPrint('lista: ${provider.authUserModel.macronutrientesDiarios?.listFontesCarboidratos.toString()}');
                    });
                  },
                  label: Text(
                    e,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Selecione suas fontes de proteinas diárias',
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w700),
          ),
          Container(
            padding: EdgeInsets.all(8.0),

            height: 200,
            width: MediaQuery.sizeOf(context).width * 0.9,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Wrap(
              spacing: 4,
              children: listProteinas.map((e) {
                return FilterChip(
                  selectedColor: Theme.of(context).colorScheme.inversePrimary,

                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(15),
                  ),
                  label: Text(
                    e,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  selected: listaProteinaReserva.contains(e),
                  onSelected: (value) {
                    setState(() {
                      if (value) {
                        listaProteinaReserva.add(e);
                      } else {
                        listaProteinaReserva.removeWhere(
                          (element) => element == e,
                        );
                      }
                      if (listaProteinaReserva.isNotEmpty) {
                        provider
                                .authProvider
                                .authModel
                                ?.authUserModel
                                ?.macronutrientesDiarios
                                ?.listFontesProteinas =
                            listaProteinaReserva;
                      }

                      // debugPrint('lista: ${provider.authUserModel.macronutrientesDiarios?.listFontesProteinas.toString()}');
                    });
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
