import 'package:flutter/material.dart';

class SummaryPage extends StatelessWidget {
  const SummaryPage({
    super.key,
    required this.fullName,
    required this.birthDateText,
    required this.birthPlaceText,
    required this.humanDesignAsIs,
    required this.zodiacSign,
    required this.ascendant,
    required this.numerologyMap,
    required this.insightsText,
    required this.onRequestTips,
  });

  final String fullName;
  final String birthDateText;     // ex: "12/03/1991 14:25"
  final String birthPlaceText;    // ex: "Lisboa, Portugal" (as is)

  final String humanDesignAsIs;   // “as is”
  final String zodiacSign;        // ex: "Peixes"
  final String ascendant;         // ex: "Virgem"

  final Map<String, String> numerologyMap; // 4 resultados

  final String insightsText; // “as is” vindo do Firestore

  /// Deve mostrar anúncio antes de carregar a dica.
  final Future<void> Function(BuildContext context) onRequestTips;

  String get firstName {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    return parts.isEmpty ? '' : parts.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resumo')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionCard(
            title: 'Resumo',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Olá $firstName', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 12),
                _InfoRow(
                  icon: Icons.cake_outlined,
                  label: 'Data de nascimento',
                  value: birthDateText,
                ),
                const SizedBox(height: 8),
                _InfoRow(
                  icon: Icons.place_outlined,
                  label: 'Local de nascimento',
                  value: birthPlaceText,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          _SectionCard(
            title: 'Human Design',
            subtitle: 'Mantemos “as is” por agora (vai mudar em breve).',
            child: _MultilineBox(text: humanDesignAsIs),
          ),
          const SizedBox(height: 12),

          _SectionCard(
            title: 'Astrologia',
            child: Column(
              children: [
                _InfoRow(
                  icon: Icons.wb_sunny_outlined,
                  label: 'Signo',
                  value: zodiacSign,
                ),
                const SizedBox(height: 8),
                _InfoRow(
                  icon: Icons.north_outlined,
                  label: 'Ascendente',
                  value: ascendant,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          _SectionCard(
            title: 'Numerologia',
            child: Column(
              children: [
                for (final e in numerologyMap.entries) ...[
                  _InfoRow(icon: Icons.tag_outlined, label: e.key, value: e.value),
                  const SizedBox(height: 8),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),

          _SectionCard(
            title: 'Insights',
            subtitle: 'Mostramos “as is”. (Sem plano semanal.)',
            trailing: TextButton.icon(
              onPressed: () => _showPromptDialog(context),
              icon: const Icon(Icons.tips_and_updates_outlined),
              label: const Text('Prompt'),
            ),
            child: _MultilineBox(text: insightsText),
          ),
          const SizedBox(height: 12),

          _SectionCard(
            title: 'Dica diária e semanal',
            subtitle: 'Carrega no botão para obter dica (com anúncio antes).',
            child: FilledButton.icon(
              onPressed: () => onRequestTips(context),
              icon: const Icon(Icons.auto_awesome_outlined),
              label: const Text('Obter dica'),
            ),
          ),
        ],
      ),
    );
  }

  void _showPromptDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Prompt melhorado (Insights)'),
        content: SingleChildScrollView(
          child: SelectableText(buildInsightsPromptTemplate()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Fechar')),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child, this.subtitle, this.trailing});

  final String title;
  final Widget child;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
                if (trailing != null) ...[trailing!],
              ],
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
            ],
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 2),
              Text(value, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}

class _MultilineBox extends StatelessWidget {
  const _MultilineBox({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final t = text.trim().isEmpty ? '—' : text.trim();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: SelectableText(t),
    );
  }
}

/// Prompt melhorado (sem plano semanal)
String buildInsightsPromptTemplate() {
  return '''
Tu és um assistente de autoconhecimento. Cria uma secção "Insights" curta e prática (máx. 1200 caracteres), em PT-PT, sem plano semanal e sem calendário.

Formato obrigatório (exatamente estes títulos):
Essência:
Essência:
Forças:
Atenções:
Próximo passo:

Regras:
- "Essência": 2-3 frases.
- "Forças": 3 bullets.
- "Atenções": 3 bullets (tom cuidadoso, sem alarmismo).
- "Próximo passo": 1 ação concreta para hoje, em 1 frase.
- Não incluir cronogramas, dias da semana, nem "plano semanal".

Contexto do utilizador:
Nome: {FIRST_NAME}
Human Design (resumo): {HD_SUMMARY}
Astrologia: Signo {ZODIAC_SIGN}, Ascendente {ASCENDANT}
Numerologia: {NUMEROLOGY_SUMMARY}

Responde apenas com o texto final da secção Insights.
''';
}