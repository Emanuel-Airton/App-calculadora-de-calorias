import 'package:app_calorias_diarias/chat/domain/models/refeicao_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
            Text(
              '🍽️ Alimentos:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
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
                    ).colorScheme.inversePrimary.withOpacity(0.4),
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                );
              }).toList(),
            ),

            const SizedBox(height: 10),

            // Macros
            Text(
              '📊 Macronutrientes:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
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
    );
  }

  Widget _buildMacroChip(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
