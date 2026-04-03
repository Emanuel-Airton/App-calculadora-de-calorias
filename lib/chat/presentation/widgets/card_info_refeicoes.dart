import 'package:app_calorias_diarias/chat/domain/models/refeicao_model.dart';
import 'package:flutter/material.dart';

class CardInfoRefeicoes extends StatelessWidget {
  RefeicaoModel? refeicao;
  CardInfoRefeicoes({super.key, this.refeicao});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      //  color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho da refeição
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  refeicao?.nomeRefeicao.toString() ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  '${refeicao?.macros?['calorias'] ?? 0}kcal',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Alimentos
            /*  Text(
              'Alimentos:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),*/
            const SizedBox(height: 5),
            Wrap(
              spacing: 8,
              runSpacing: 5,
              children: refeicao!.alimentos!.map((alimento) {
                return Chip(
                  side: BorderSide.none,
                  label: Text(alimento),
                  color: WidgetStatePropertyAll(
                    Theme.of(
                      context,
                    ).colorScheme.inversePrimary.withOpacity(0.5),
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                );
              }).toList(),
            ),

            const SizedBox(height: 10),

            // Macros
            Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Theme.of(
                  context,
                ).colorScheme.inversePrimary.withOpacity(0.2),
              ),
              child: Column(
                children: [
                  Text(
                    'Macronutrientes',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMacroChip(
                        '🥩 Proteína',
                        '${refeicao?.macros?['proteinas'] ?? 0}g',
                      ),
                      _buildMacroChip(
                        '🍚 Carboidrato',
                        '${refeicao?.macros?['carboidratos'] ?? 0}g',
                      ),
                      _buildMacroChip(
                        '🥑 Gordura',
                        '${refeicao?.macros?['gorduras'] ?? 0}g',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroChip(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
