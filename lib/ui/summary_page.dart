import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../utils/astro_utils.dart';
import 'bodygraph/bodygraph_widget.dart';

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
    this.hdBase, // New field to support the bodygraph
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
  final Map<String, dynamic>? hdBase;

  @override
  Widget build(BuildContext context) {
    const cosmicBg = Color(0xFF0F0B1E);
    const goldColor = Color(0xFFE6B325);
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
          if (hdBase != null) 
            _Section(
              title: 'Mapa do Corpo',
              subtitle: 'A tua estrutura energética visual.',
              child: BodygraphWidget(data: _buildBodygraphData(hdBase!)),
            ),

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
                Text(l10n.astroMCNodes, style: const TextStyle(color: goldColor, fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 12),
                _AstroRow(symbol: '🎯', label: l10n.astroMC, value: astroData?['mcSign'] ?? '—'),
                const SizedBox(height: 12),
                _AstroRow(symbol: '☊', label: l10n.astroNorthNode, value: getSign(astroData?['northNode'])),
                const SizedBox(height: 12),
                _AstroRow(symbol: '☋', label: l10n.astroSouthNode, value: getSign(astroData?['southNode'])),
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
            child: _MultilineBox(text: insightsText),
          ),

          _Section(
            title: 'Orientação Diária',
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

  BodygraphData _buildBodygraphData(Map<String, dynamic> hd) {
    final definedCenters = (hd['definedCenters'] as List?)?.map((e) => e.toString()).toSet() ?? {};
    final definedChannels = (hd['definedChannels'] as List?)?.map((e) => e.toString()).toSet() ?? {};
    final activations = (hd['activations'] as List?)?.whereType<Map>().toList() ?? [];

    final consciousGates = activations
        .where((a) => a['conscious'] == true)
        .map((a) => a['gate'] as int? ?? 0)
        .where((g) => g > 0)
        .toSet();

    final designGates = activations
        .where((a) => a['conscious'] == false)
        .map((a) => a['gate'] as int? ?? 0)
        .where((g) => g > 0)
        .toSet();

    return BodygraphData(
      definedCenters: definedCenters,
      definedChannels: definedChannels,
      consciousGates: consciousGates,
      designGates: designGates,
    );
  }

  String get ascSignFromData => astroData?['ascSign'] ?? ascendant;

  String getSign(dynamic data) {
    if (data is Map && data['sign'] != null) return data['sign'];
    return '—';
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
        color: goldColor.withOpacity(0.05),
      ),
      child: const Text(
        'DISCOVER YOUR COSMIC DNA',
        style: TextStyle(color: goldColor, fontSize: 10.5, fontWeight: FontWeight.w800, letterSpacing: 1.6),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child, this.subtitle});
  final String title; final Widget child; final String? subtitle;
  @override
  Widget build(BuildContext context) {
    const goldColor = Color(0xFFE6B325);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 28.0, right: 16.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title.toUpperCase(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.2)),
            const SizedBox(height: 6),
            Container(height: 2.5, width: 35, decoration: BoxDecoration(color: goldColor, borderRadius: BorderRadius.circular(2))),
          ]),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 10),
          Padding(padding: const EdgeInsets.only(left: 28.0, right: 16.0), child: Text(subtitle!, style: const TextStyle(color: Colors.white54, fontSize: 12))),
        ],
        const SizedBox(height: 18),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Card(
            elevation: 0, color: Colors.white.withOpacity(0.04), margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: Colors.white.withOpacity(0.08))),
            child: Padding(padding: const EdgeInsets.all(20), child: child),
          ),
        ),
        const SizedBox(height: 36),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value});
  final IconData icon; final String label; final String value;
  @override
  Widget build(BuildContext context) {
    const goldColor = Color(0xFFE6B325);
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, size: 20, color: goldColor),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 11, letterSpacing: 0.5)),
        const SizedBox(height: 3),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14)),
      ])),
    ]);
  }
}

class _MultilineBox extends StatelessWidget {
  const _MultilineBox({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5));
  }
}

class _AstroRow extends StatelessWidget {
  const _AstroRow({required this.symbol, required this.label, required this.value});
  final String symbol; final String label; final String value;
  @override
  Widget build(BuildContext context) {
    const goldColor = Color(0xFFE6B325);
    return Row(children: [
      Expanded(flex: 3, child: Row(children: [
        SizedBox(width: 24, child: Text(symbol, style: const TextStyle(fontSize: 18, color: goldColor), textAlign: TextAlign.center)),
        const SizedBox(width: 8),
        Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white70, fontSize: 13))),
      ])),
      Expanded(flex: 2, child: Align(alignment: Alignment.centerRight, child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold), textAlign: TextAlign.right))),
    ]);
  }
}