import 'package:flutter/material.dart';
import 'package:human_match_app/l10n/app_localizations.dart';
import 'package:human_match_app/hd/hd_data_utils.dart';
import '../ui/bodygraph/bodygraph_widget.dart';
import '../ui/bodygraph/bodygraph_data.dart';

class HumanDesignSection extends StatelessWidget {
  const HumanDesignSection({
    super.key,
    required this.hd,
  });

  final Map<String, dynamic> hd;

  static const Color goldColor = Color(0xFFE6B325);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final type = _translateType(context, (hd['type'] ?? '—').toString());
    final authority = _translateAuthority(context, (hd['authority'] ?? '—').toString());
    final strategy = _translateStrategy(context, (hd['strategy'] ?? '—').toString());
    final signature = _translateSignature(context, (hd['signature'] ?? '—').toString());
    final notSelfTheme = _translateNotSelf(context, (hd['notSelfTheme'] ?? '—').toString());
    final definition = _translateDefinition(context, (hd['definition'] ?? '—').toString());
    final incarnationCross = _translateCross(context, (hd['incarnationCross'] ?? '—').toString());

    final activationsRaw = hd['activations'];
    final activations = (activationsRaw is List)
        ? activationsRaw.whereType<Map>().map((m) => m.cast<String, dynamic>()).toList()
        : <Map<String, dynamic>>[];

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

    final definedCenters = (hd['definedCenters'] as List?)?.map((e) => e.toString()).toSet() ?? {};
    final definedChannels = (hd['definedChannels'] as List?)?.map((e) => e.toString()).toSet() ?? {};

    final bodygraphData = BodygraphData(
      definedCenters: definedCenters,
      definedChannels: definedChannels,
      consciousGates: consciousGates,
      designGates: designGates,
    );

    final conscious = activations.where((a) => a['conscious'] == true).toList();
    final design = activations.where((a) => a['conscious'] == false).toList();
    final profile = _computeProfile(hd, conscious, design);
    final rows = _buildCompareRows(conscious, design);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1) Principais Indicadores
          Text(l10n.hdIndicators, style: const TextStyle(color: goldColor, fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 12),
          _IndicatorsTable(
            type: type,
            authority: authority,
            strategy: strategy,
            profile: profile,
            signature: signature,
            notSelf: notSelfTheme,
            definition: definition,
            cross: incarnationCross,
          ),

          const SizedBox(height: 20),
          const Divider(color: Colors.white12),
          const SizedBox(height: 12),

          // 2) Bodygraph
          Text(l10n.hdBodygraph, style: const TextStyle(color: goldColor, fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 12),
          BodygraphWidget(data: bodygraphData),

          const SizedBox(height: 20),
          const Divider(color: Colors.white12),
          const SizedBox(height: 12),

          // 3) Centros
          Text(l10n.hdEnergyCenters, style: const TextStyle(color: goldColor, fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 12),
          _CentersTable(definedCenters: definedCenters),

          const SizedBox(height: 20),
          const Divider(color: Colors.white12),
          const SizedBox(height: 12),

          // 4) Canais
          Text(l10n.hdChannelsUser, style: const TextStyle(color: goldColor, fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 12),
          _ChannelsTable(definedChannels: definedChannels.toList()),

          const SizedBox(height: 20),
          const Divider(color: Colors.white12),
          const SizedBox(height: 12),

          // 5) Portas
          Text(l10n.hdGatesUser, style: const TextStyle(color: goldColor, fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 12),
          _GatesTable(consciousGates: consciousGates, designGates: designGates),

          const SizedBox(height: 20),
          const Divider(color: Colors.white12),
          const SizedBox(height: 12),

          // 6) Ativações (Astros)
          Text(l10n.hdPlanetaryActivation, style: const TextStyle(color: goldColor, fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 16),
          const _ActivationHeader(),
          const SizedBox(height: 10),
          Divider(height: 1, color: Colors.white.withOpacity(0.1)),
          const SizedBox(height: 10),
          ...rows.map((r) => _ActivationCompareRow(row: r)),
        ],
      ),
    );
  }

  static String _computeProfile(Map<String, dynamic> hd, List<Map<String, dynamic>> conscious, List<Map<String, dynamic>> design) {
    final direct = (hd['profile'] ?? '').toString().trim();
    if (direct.isNotEmpty) return direct;
    int? pSunLine;
    for (final a in conscious) { if ((a['body'] ?? '').toString() == 'Sun' && a['line'] is int) { pSunLine = a['line'] as int; break; } }
    int? dSunLine;
    for (final a in design) { if ((a['body'] ?? '').toString() == 'Sun' && a['line'] is int) { dSunLine = a['line'] as int; break; } }
    return (pSunLine != null && dSunLine != null) ? '$pSunLine/$dSunLine' : '—';
  }

  static List<_CompareRow> _buildCompareRows(List<Map<String, dynamic>> conscious, List<Map<String, dynamic>> design) {
    const order = ['Sun','Earth','Moon','Mercury','Venus','Mars','Jupiter','Saturn','Uranus','Neptune','Pluto'];
    final cMap = { for (var a in conscious) (a['body'] ?? '').toString(): a };
    final dMap = { for (var a in design) (a['body'] ?? '').toString(): a };
    final rows = <_CompareRow>[];
    for (final body in order) {
      final c = cMap[body]; final d = dMap[body];
      if (c != null || d != null) rows.add(_CompareRow(body: body, consciousGL: _gl(c), designGL: _gl(d)));
    }
    return rows;
  }

  static String _gl(Map<String, dynamic>? a) {
    if (a == null) return '—';
    final gate = a['gate']; final line = a['line'];
    return (gate is int && line is int) ? '$gate.$line' : '—';
  }

  static String _translateType(BuildContext context, String type) {
    final l10n = AppLocalizations.of(context)!;
    switch (type.trim().toLowerCase()) {
      case 'generator': case 'gerador': return l10n.hdGen;
      case 'manifesting generator': case 'gerador manifestador': return l10n.hdMG;
      case 'manifestor': case 'manifestador': return l10n.hdMan;
      case 'projector': case 'projetor': return l10n.hdProj;
      case 'reflector': case 'refletor': return l10n.hdRef;
      default: return _titleCase(type);
    }
  }

  static String _translateAuthority(BuildContext context, String s) {
    final l10n = AppLocalizations.of(context)!;
    final t = s.trim().toLowerCase();
    if (t.isEmpty || t == '—') return '—';
    if (t.contains('emot')) return l10n.hdAuthEmo;
    if (t.contains('sacral')) return l10n.hdAuthSac;
    if (t.contains('splen')) return l10n.hdAuthSpl;
    if (t.contains('ego')) return l10n.hdAuthEgo;
    if (t.contains('self')) return l10n.hdAuthSelf;
    if (t.contains('mental')) return l10n.hdAuthMen;
    if (t.contains('lunar')) return l10n.hdAuthLun;
    return _titleCase(s);
  }

  static String _translateStrategy(BuildContext context, String s) {
    final l10n = AppLocalizations.of(context)!;
    final t = s.trim().toLowerCase();
    if (t.isEmpty || t == '—') return '—';
    if (t.contains('inform') && t.contains('respond')) return l10n.hdStrRespInf;
    if (t.contains('inform')) return l10n.hdStrInf;
    if (t.contains('respond')) return l10n.hdStrResp;
    if (t.contains('invit')) return l10n.hdStrInv;
    if (t.contains('lunar')) return l10n.hdStrLun;
    return _titleCase(s);
  }

  static String _translateSignature(BuildContext context, String s) {
    final l10n = AppLocalizations.of(context)!;
    final t = s.trim().toLowerCase();
    if (t == 'satisfaction') return l10n.hdSigSat;
    if (t == 'success') return l10n.hdSigSuc;
    if (t == 'peace') return l10n.hdSigPea;
    if (t == 'surprise') return l10n.hdSigSur;
    return _titleCase(s);
  }

  static String _translateNotSelf(BuildContext context, String s) {
    final l10n = AppLocalizations.of(context)!;
    final t = s.trim().toLowerCase();
    if (t == 'frustration') return l10n.hdNotFru;
    if (t == 'bitterness') return l10n.hdNotBit;
    if (t == 'anger') return l10n.hdNotAng;
    if (t == 'disappointment') return l10n.hdNotDis;
    return _titleCase(s);
  }

  static String _translateDefinition(BuildContext context, String s) {
    final l10n = AppLocalizations.of(context)!;
    final t = s.trim().toLowerCase();
    if (t.contains('single')) return l10n.hdDefSin;
    if (t.contains('split') && !t.contains('triple') && !t.contains('quad')) return l10n.hdDefSpl;
    if (t.contains('triple')) return l10n.hdDefTri;
    if (t.contains('quad')) return l10n.hdDefQua;
    return _titleCase(s);
  }

  static String _translateCross(BuildContext context, String s) {
    final l10n = AppLocalizations.of(context)!;
    var t = s.trim();
    t = t.replaceFirst('Right Angle', l10n.hdCrossRight).replaceFirst('Left Angle', l10n.hdCrossLeft).replaceFirst('Juxtaposition', l10n.hdCrossJuxta).replaceFirst('Cross of', l10n.hdCrossOf);
    return t;
  }

  static String centerL10n(BuildContext context, String s) {
    final l10n = AppLocalizations.of(context)!;
    final k = s.trim().toLowerCase();
    if (k.contains('head')) return l10n.hdCenterHead;
    if (k.contains('ajna')) return l10n.hdCenterAjna;
    if (k.contains('throat')) return l10n.hdCenterThroat;
    if (k == 'g' || k.contains('identity')) return l10n.hdCenterG;
    if (k.contains('ego') || k.contains('heart') || k.contains('will')) return l10n.hdCenterEgo;
    if (k.contains('spleen')) return l10n.hdCenterSpleen;
    if (k.contains('solar')) return l10n.hdCenterSolar;
    if (k.contains('sacral')) return l10n.hdCenterSacral;
    if (k.contains('root')) return l10n.hdCenterRoot;
    return s;
  }

  static String _titleCase(String s) {
    final t = s.trim();
    if (t.isEmpty || t == '—' || RegExp(r'^\d+/\d+$').hasMatch(t)) return t;
    return t.split(RegExp(r'\s+')).map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1).toLowerCase()).join(' ');
  }
}

class _IndicatorsTable extends StatelessWidget {
  const _IndicatorsTable({
    required this.type, required this.authority, required this.strategy,
    required this.profile, required this.signature, required this.notSelf,
    required this.definition, required this.cross,
  });
  final String type, authority, strategy, profile, signature, notSelf, definition, cross;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final items = [
      {'key': 'type', 'label': l10n.hdType, 'value': type, 'icon': Icons.person_outline},
      {'key': 'authority', 'label': l10n.hdAuthority, 'value': authority, 'icon': Icons.favorite_outline},
      {'key': 'strategy', 'label': l10n.hdStrategy, 'value': strategy, 'icon': Icons.alt_route_outlined},
      {'key': 'profile', 'label': l10n.hdProfile, 'value': profile, 'icon': Icons.badge_outlined},
      {'key': 'signature', 'label': l10n.hdSignature, 'value': signature, 'icon': Icons.auto_awesome_outlined},
      {'key': 'notSelf', 'label': l10n.hdNotSelf, 'value': notSelf, 'icon': Icons.warning_amber_outlined},
      {'key': 'definition', 'label': l10n.hdDefinition, 'value': definition, 'icon': Icons.hub_outlined},
      {'key': 'cross', 'label': l10n.hdIncarnationCross, 'value': cross, 'icon': Icons.add_road_outlined},
    ];

    return Column(
      children: items.map((item) {
        final desc = HdDataUtils.getIndicatorDescription(context, item['key'] as String);
        final valDesc = HdDataUtils.getIndicatorValueDescription(context, item['key'] as String, item['value'] as String);

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(item['icon'] as IconData, size: 18, color: HumanDesignSection.goldColor),
                  const SizedBox(width: 8),
                  Text(item['label'] as String, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  Text(item['value'] as String, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                ],
              ),
              if (desc.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(desc, style: const TextStyle(color: HumanDesignSection.goldColor, fontSize: 11, fontWeight: FontWeight.w500)),
              ],
              if (valDesc.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(valDesc, style: const TextStyle(color: Colors.white60, fontSize: 12, height: 1.4)),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _CentersTable extends StatelessWidget {
  const _CentersTable({required this.definedCenters});
  final Set<String> definedCenters;

  String _norm(String s) {
    final k = s.toLowerCase();
    if (k.contains('ego') || k.contains('will') || k.contains('heart')) return 'heart';
    if (k.contains('solar')) return 'solar plexus';
    return k;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const keys = ['head','ajna','throat','g','heart','solar plexus','spleen','sacral','root'];
    final normDef = definedCenters.map(_norm).toSet();

    return Column(
      children: keys.map((k) {
        final isDef = normDef.contains(k);
        final name = HumanDesignSection.centerL10n(context, k);
        final status = isDef ? l10n.hdDefined : l10n.hdUndefined;
        final desc = HdDataUtils.getCenterDescription(context, k, isDef);

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDef ? Colors.orangeAccent.withOpacity(0.3) : Colors.white10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(status, style: TextStyle(color: isDef ? Colors.orangeAccent : Colors.white38, fontSize: 12, fontWeight: FontWeight.w500)),
                ],
              ),
              if (desc.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(desc, style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.4)),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _ChannelsTable extends StatelessWidget {
  const _ChannelsTable({required this.definedChannels});
  final List<String> definedChannels;

  String _normalizeChannel(String s) {
    final parts = s.split('-');
    if (parts.length != 2) return s;
    final a = int.tryParse(parts[0]); final b = int.tryParse(parts[1]);
    if (a == null || b == null) return s;
    return (a < b) ? '$a-$b' : '$b-$a';
  }

  @override
  Widget build(BuildContext context) {
    final sorted = definedChannels.map(_normalizeChannel).toList()..sort();
    if (sorted.isEmpty) return const SizedBox();

    return Column(
      children: sorted.map((ch) {
        final name = HdDataUtils.getChannelName(ch);
        final desc = HdDataUtils.getChannelDescription(ch);

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("$ch: $name", style: const TextStyle(color: HumanDesignSection.goldColor, fontWeight: FontWeight.bold, fontSize: 14)),
              if (desc.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _GatesTable extends StatelessWidget {
  const _GatesTable({required this.consciousGates, required this.designGates});
  final Set<int> consciousGates;
  final Set<int> designGates;

  @override
  Widget build(BuildContext context) {
    final allGates = {...consciousGates, ...designGates}.toList()..sort();
    if (allGates.isEmpty) return const SizedBox();

    return Column(
      children: allGates.map((g) {
        final isConscious = consciousGates.contains(g);
        final isDesign = designGates.contains(g);
        final name = HdDataUtils.getGateName(g);
        final desc = HdDataUtils.getGateDescription(g);

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("Gate $g: $name", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                  const Spacer(),
                  if (isConscious) _GatePill(text: "P", color: Colors.black, borderColor: Colors.white24),
                  if (isDesign) ...[
                    const SizedBox(width: 4),
                    _GatePill(text: "D", color: const Color(0xFFA44344), borderColor: Colors.transparent),
                  ],
                ],
              ),
              if (desc.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(color: Colors.white60, fontSize: 11)),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _GatePill extends StatelessWidget {
  const _GatePill({required this.text, required this.color, required this.borderColor});
  final String text; final Color color; final Color borderColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: borderColor),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
    );
  }
}

class _CompareRow {
  final String body; final String consciousGL; final String designGL;
  const _CompareRow({required this.body, required this.consciousGL, required this.designGL});
}

class _ActivationHeader extends StatelessWidget {
  const _ActivationHeader();
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(children: [
      Flexible(flex: 3, child: Align(alignment: Alignment.center, child: Column(mainAxisSize: MainAxisSize.min, children: [Text(l10n.hdDesign, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)), Text(l10n.hdUnconscious, style: const TextStyle(color: Colors.white38, fontSize: 11))]))),
      const SizedBox(width: 12),
      Flexible(flex: 2, child: Align(alignment: Alignment.center, child: Text(l10n.hdPlanets, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)))),
      const SizedBox(width: 12),
      Flexible(flex: 3, child: Align(alignment: Alignment.center, child: Column(mainAxisSize: MainAxisSize.min, children: [Text(l10n.hdPersonality, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)), Text(l10n.hdConscious, style: const TextStyle(color: Colors.white38, fontSize: 11))]))),
    ]);
  }
}

class _ActivationCompareRow extends StatelessWidget {
  const _ActivationCompareRow({required this.row}); final _CompareRow row;
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(bottom: 10), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Flexible(flex: 3, child: _Pill(text: row.designGL, tone: _PillTone.design)),
      const SizedBox(width: 12),
      Flexible(flex: 2, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(_planetSymbol(row.body), style: const TextStyle(fontSize: 17, color: HumanDesignSection.goldColor)),
        const SizedBox(width: 4),
        Text(_planetName(context, row.body), style: const TextStyle(color: Colors.white, fontSize: 14)),
      ])),
      const SizedBox(width: 12),
      Flexible(flex: 3, child: _Pill(text: row.consciousGL, tone: _PillTone.conscious)),
    ]));
  }
  String _planetName(BuildContext context, String body) {
    final l10n = AppLocalizations.of(context)!;
    switch (body) {
      case 'Sun': return l10n.hdPlanetSun; case 'Earth': return l10n.hdPlanetEarth; case 'Moon': return l10n.hdPlanetMoon;
      case 'Mercury': return l10n.hdPlanetMercury; case 'Venus': return l10n.hdPlanetVenus; case 'Mars': return l10n.hdPlanetMars;
      case 'Jupiter': return l10n.hdPlanetJupiter; case 'Saturn': return l10n.hdPlanetSaturn; case 'Uranus': return l10n.hdPlanetUranus;
      case 'Neptune': return l10n.hdPlanetNeptune; case 'Pluto': return l10n.hdPlanetPluto; default: return body;
    }
  }
  String _planetSymbol(String body) {
    switch (body) {
      case 'Sun': return '☉'; case 'Earth': return '⊕'; case 'Moon': return '☾'; case 'Mercury': return '☿'; case 'Venus': return '♀';
      case 'Mars': return '♂'; case 'Jupiter': return '♃'; case 'Saturn': return '♄'; case 'Uranus': return '♅'; case 'Neptune': return '♆';
      case 'Pluto': return '♇'; default: return '•';
    }
  }
}

enum _PillTone { conscious, design, authority, undefined }

class _Pill extends StatelessWidget {
  const _Pill({required this.text, required this.tone});
  final String text; final _PillTone tone;
  @override
  Widget build(BuildContext context) {
    Color border; Color bg; Color fg = Colors.white;
    switch (tone) {
      case _PillTone.conscious: border = Colors.white.withOpacity(0.15); bg = Colors.white10; break;
      case _PillTone.design: border = Colors.redAccent.withOpacity(0.2); bg = Colors.redAccent.withOpacity(0.08); break;
      case _PillTone.authority: border = Colors.purpleAccent.withOpacity(0.3); bg = Colors.purpleAccent.withOpacity(0.12); break;
      case _PillTone.undefined: border = Colors.white.withOpacity(0.05); bg = Colors.transparent; fg = Colors.white38; break;
    }
    return Container(padding: const EdgeInsets.symmetric(vertical: 8), decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: bg, border: Border.all(color: border)), child: Center(child: Text(text, style: TextStyle(color: fg, fontSize: 13, fontWeight: FontWeight.w600))));
  }
}
