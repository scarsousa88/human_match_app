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
  final String birthDateText;
  final String birthPlaceText;
  final String humanDesignAsIs;
  final String zodiacSign;
  final String ascendant;
  final Map<String, String> numerologyMap;
  final String insightsText;
  final Future<void> Function(BuildContext context) onRequestTips;

  @override
  Widget build(BuildContext context) {
    // Cores fiéis ao estilo "Cosmic"
    const cosmicBg = Color(0xFF0F0B1E); // Roxo muito escuro/preto
    const goldColor = Color(0xFFE6B325); // Dourado do website

    return Scaffold(
      backgroundColor: cosmicBg,
      appBar: AppBar(
        backgroundColor: cosmicBg,
        elevation: 0,
        centerTitle: true,
        leading: const Icon(Icons.menu, color: Colors.white70),
        title: const _CosmicDNABadge(),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        children: [
          _Section(
            title: 'Resumo',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoRow(icon: Icons.cake_outlined, label: 'Data de nascimento', value: birthDateText),
                const SizedBox(height: 12),
                _InfoRow(icon: Icons.place_outlined, label: 'Local de nascimento', value: birthPlaceText),
              ],
            ),
          ),

          _Section(
            title: 'Human Design',
            subtitle: 'Informação base do teu desenho energético.',
            child: _MultilineBox(text: humanDesignAsIs),
          ),

          _Section(
            title: 'Astrologia',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoRow(icon: Icons.wb_sunny_outlined, label: 'Signo', value: zodiacSign),
                const SizedBox(height: 12),
                _InfoRow(icon: Icons.north_outlined, label: 'Ascendente', value: ascendant),
              ],
            ),
          ),

          _Section(
            title: 'Numerologia',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final e in numerologyMap.entries) ...[
                  _InfoRow(icon: Icons.tag_outlined, label: e.key, value: e.value),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          ),

          _Section(
            title: 'Insights',
            subtitle: 'Análise integrada da tua essência.',
            trailing: TextButton.icon(
              onPressed: () => _showPromptDialog(context),
              icon: const Icon(Icons.tips_and_updates_outlined, color: goldColor, size: 18),
              label: const Text('Prompt', style: TextStyle(color: goldColor, fontSize: 12)),
            ),
            child: _MultilineBox(text: insightsText),
          ),

          _Section(
            title: 'Dica diária e semanal',
            subtitle: 'Carrega no botão para obter orientação personalizada.',
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: goldColor,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => onRequestTips(context),
                icon: const Icon(Icons.auto_awesome_outlined),
                label: const Text('OBTER DICA', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1)),
              ),
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
        backgroundColor: const Color(0xFF1A162B),
        title: const Text('Prompt Insights', style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: SelectableText(buildInsightsPromptTemplate(), style: const TextStyle(color: Colors.white70)),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Fechar', style: TextStyle(color: Color(0xFFE6B325)))),
        ],
      ),
    );
  }
}

class _CosmicDNABadge extends StatelessWidget {
  const _CosmicDNABadge();

  @override
  Widget build(BuildContext context) {
    const goldColor = Color(0xFFE6B325);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: goldColor, width: 1.2),
        // Leve brilho de fundo opcional para destacar como no site
        color: goldColor.withOpacity(0.05),
      ),
      child: const Text(
        'DISCOVER YOUR COSMIC DNA',
        style: TextStyle(
          color: goldColor,
          fontSize: 10.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.6,
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child, this.subtitle, this.trailing});

  final String title;
  final Widget child;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    const goldColor = Color(0xFFE6B325);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 28.0, right: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  if (trailing != null) trailing!,
                ],
              ),
              const SizedBox(height: 6),
              Container(
                height: 2.5,
                width: 35,
                decoration: BoxDecoration(
                  color: goldColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 28.0, right: 16.0),
            child: Text(
              subtitle!,
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ),
        ],
        const SizedBox(height: 18),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Card(
            elevation: 0,
            color: Colors.white.withOpacity(0.04),
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.white.withOpacity(0.08)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: child,
            ),
          ),
        ),
        const SizedBox(height: 36),
      ],
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
    const goldColor = Color(0xFFE6B325);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: goldColor),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white38, fontSize: 11, letterSpacing: 0.5),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.black26,
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: SelectableText(
        t,
        style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 13.5, height: 1.55),
      ),
    );
  }
}

String buildInsightsPromptTemplate() {
  return '''
Tu és um assistente de autoconhecimento. Cria uma secção "Insights" curta e prática (máx. 1200 caracteres), em PT-PT, sem plano semanal e sem calendário.

Formato obrigatório (exatamente estes títulos):
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
