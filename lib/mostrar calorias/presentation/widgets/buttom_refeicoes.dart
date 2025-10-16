import 'package:app_calorias_diarias/chat/presentation/views/chat_refeicoes_view.dart';
import 'package:app_calorias_diarias/chat/presentation/providers/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ButtomRefeicoes extends StatelessWidget {
  const ButtomRefeicoes({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        final chatProvider = Provider.of<ChatProvider>(context, listen: false);
        chatProvider.obterRefeicoesCache();
        // await chatprovider.limparCache();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatRefeicoesView()),
        );
      },
      child: Text('Refeições diárias'),
    );
  }
}
