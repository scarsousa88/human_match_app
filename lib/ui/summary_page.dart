import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../utils/astro_utils.dart';

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
    this.astroData,
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
  final Map<String, dynamic>? astroData;

  @override
  Widget build(BuildContext context) {
    // Cores fiéis ao estilo "Cosmic"
    const cosmicBg = Color(0xFF0F0B1E); // Roxo muito escuro/preto
    const goldColor = Color(0xFFE6B325); // Dourado do website
    final l10n = AppLocalizations.of(context)!;

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
            title: l10n.astroTitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- BIG 3 ---
                Text(l10n.astroBig3, style: const TextStyle(color: goldColor, fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 12),
                _AstroRow(symbol: '☉', label: l10n.zodiacSign, value: zodiacSign),
                const SizedBox(height: 12),
                _AstroRow(symbol: '☾', label: l10n.astroMoonSign, value: getSign(astroData?['moon'])),
                const SizedBox(height: 12),
                _AstroRow(symbol: '⬆️', label: l10n.ascendant, value: ascSignFromData),

                const SizedBox(height: 20),
                const Divider(color: Colors.white12),
                const SizedBox(height: 12),

                // --- PLANETAS PESSOAIS ---
                Text(l10n.astroPersonalPlanets, style: const TextStyle(color: goldColor, fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 12),
                _AstroRow(symbol: '☿', label: l10n.astroMercurySign, value: getSign(astroData?['mercury'])),
                const SizedBox(height: 12),
                _AstroRow(symbol: '♀', label: l10n.astroVenusSign, value: getSign(astroData?['venus'])),
                const SizedBox(height: 12),
                _AstroRow(symbol: '♂', label: l10n.astroMarsSign, value: getSign(astroData?['mars'])),

                const SizedBox(height: 20),
                const Divider(color: Colors.white12),
                const SizedBox(height: 12),

                // --- PLANETAS SOCIAIS E GERACIONAIS ---
                Text(l10n.astroSocialGenerationalPlanets, style: const TextStyle(color: goldColor, fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 12),
                _AstroRow(symbol: '♃', label: l10n.hdPlanetJupiter, value: getSign(astroData?['jupiter'])),
                const SizedBox(height: 12),
                _AstroRow(symbol: '♄', label: l10n.hdPlanetSaturn, value: getSign(astroData?['saturn'])),
                const SizedBox(height: 12),
                _AstroRow(symbol: '♅', label: l10n.hdPlanetUranus, value: getSign(astroData?['uranus'])),
                const SizedBox(height: 12),
                _AstroRow(symbol: '♆', label: l10n.hdPlanetNeptune, value: getSign(astroData?['neptune'])),
                const SizedBox(height: 12),
                _AstroRow(symbol: '♇', label: l10n.hdPlanetPluto, value: getSign(astroData?['pluto'])),

                const SizedBox(height: 20),
                const Divider(color: Colors.white12),
                const SizedBox(height: 12),

                // --- MC E NODOS LUNARES ---
                Text(l10n.astroMCNodes, style: const TextStyle(color: goldColor, fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 12),
                _AstroRow(symbol: '🎯', label: l10n.astroMC, value: astroData?['mcSign'] ?? '—'),
                const SizedBox(height: 12),
                _AstroRow(symbol: '☊', label: l10n.astroNorthNode, value: getSign(astroData?['northNode'])),
                const SizedBox(height: 12),
                _AstroRow(symbol: '☋', label: l10n.astroSouthNode, value: getSign(astroData?['southNode'])),
                
                if (astroData?['houses'] != null) ...[
                  const SizedBox(height: 24),
                  const Divider(color: Colors.white12),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.home_outlined, color: goldColor, size: 18),
                      const SizedBox(width: 8),
                      Text(l10n.astroHouses, style: const TextStyle(color: goldColor, fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3.8,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: (astroData!['houses'] as List).length,
                    itemBuilder: (context, index) {
                      final houseNum = index + 1;
                      final lon = (astroData!['houses'] as List)[index] as num;
                      final sign = getZodiacSign(context, lon.toDouble());
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.03),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white.withOpacity(0.05)),
                        ),
                        child: Row(
                          children: [
                            Text(
                              '$houseNum',
                              style: const TextStyle(color: goldColor, fontWeight: FontWeight.w900, fontSize: 11),
                            ),
                            const VerticalDivider(color: Colors.white12, indent: 4, endIndent: 4, width: 16),
                            Expanded(
                              child: Text(
                                sign,
                                style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],

                if (astroData?['aspects'] != null && (astroData!['aspects'] as List).isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const Divider(color: Colors.white12),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.link, color: goldColor, size: 18),
                      const SizedBox(width: 8),
                      Text(l10n.astroAspects, style: const TextStyle(color: goldColor, fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: (astroData!['aspects'] as List).map((a) {
                      final aspect = a as Map;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.03),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white.withOpacity(0.05)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                aspect['p1Name'].toString(),
                                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                aspect['type'].toString(),
                                style: const TextStyle(color: goldColor, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                aspect['p2Name'].toString(),
                                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
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

  String get ascSignFromData => astroData?['ascSign'] ?? ascendant;

  String getSign(dynamic data) {
    if (data is Map && data['sign'] != null) return data['sign'];
    return '—';
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

class _AstroRow extends StatelessWidget {
  const _AstroRow({required this.symbol, required this.label, required this.value});
  final String symbol;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    const goldColor = Color(0xFFE6B325);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          child: Text(symbol, style: const TextStyle(fontSize: 18, color: goldColor), textAlign: TextAlign.center),
        ),
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
- "Próximo passo": 1 action concreta para hoje, em 1 frase.
- Não incluir cronogramas, dias da semana, nem "plano semanal".

Contexto do utilizador:
Nome: {FIRST_NAME}
Human Design (resumo): {HD_SUMMARY}
Astrologia: Signo {ZODIAC_SIGN}, Ascendente {ASCENDANT}
Numerologia: {NUMEROLOGY_SUMMARY}

Responde apenas com o texto final da secção Insights.
''';
}
