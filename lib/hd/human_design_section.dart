import 'package:flutter/material.dart';
import 'package:human_match_app/l10n/app_localizations.dart';
import '../ui/bodygraph/bodygraph_widget.dart';

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

    final authorityCenterRaw = (hd['authorityCenter'] ?? '').toString().trim();
    final authorityCenter = authorityCenterRaw.isEmpty ? null : authorityCenterRaw;

    final definedCenters = (hd['definedCenters'] as List?)?.map((e) => e.toString()).toSet() ?? {};
    final definedChannels = (hd['definedChannels'] as List?)?.map((e) => e.toString()).toSet() ?? {};

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1) Visual Bodygraph (The heart of the request)
        BodygraphWidget(data: bodygraphData),
        
        const SizedBox(height: 16),

        // 2) KPI zone
        Card(
          elevation: 0,
          color: Colors.black26,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _InfoLine(icon: Icons.person_outline, label: l10n.hdType, value: type),
                const SizedBox(height: 10),
                _InfoLine(icon: Icons.favorite_outline, label: l10n.hdAuthority, value: authority),
                const SizedBox(height: 10),
                _InfoLine(icon: Icons.alt_route_outlined, label: l10n.hdStrategy, value: strategy),
                const SizedBox(height: 10),
                _InfoLine(icon: Icons.badge_outlined, label: l10n.hdProfile, value: profile),
                const SizedBox(height: 10),
                _InfoLine(icon: Icons.auto_awesome_outlined, label: l10n.hdSignature, value: signature),
                const SizedBox(height: 10),
                _InfoLine(icon: Icons.warning_amber_outlined, label: l10n.hdNotSelf, value: notSelfTheme),
                const SizedBox(height: 10),
                _InfoLine(icon: Icons.hub_outlined, label: l10n.hdDefinition, value: definition),
                const SizedBox(height: 10),
                _InfoLine(icon: Icons.add_road_outlined, label: l10n.hdIncarnationCross, value: incarnationCross),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // 3) Centers + Channels
        _CentersChannelsTable(
          definedCenters: definedCenters.toList(),
          definedChannels: (definedChannels.map(_normalizeChannel).toList()..sort()),
          authorityCenter: authorityCenter,
        ),

        const SizedBox(height: 12),

        // 4) Activations table
        Card(
          elevation: 0,
          color: Colors.black26,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                const _ActivationHeader(),
                const SizedBox(height: 10),
                Divider(height: 1, color: Colors.white.withOpacity(0.1)),
                const SizedBox(height: 10),
                ...rows.map((r) => _ActivationCompareRow(row: r)),
              ],
            ),
          ),
        ),
      ],
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

  static String _normalizeChannel(String s) {
    final parts = s.split('-');
    if (parts.length != 2) return s;
    final a = int.tryParse(parts[0]); final b = int.tryParse(parts[1]);
    if (a == null || b == null) return s;
    return (a < b) ? '$a-$b' : '$b-$a';
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

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.icon, required this.label, required this.value});
  final IconData icon; final String label; final String value;
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(flex: 5, child: Row(children: [Icon(icon, size: 18, color: HumanDesignSection.goldColor), const SizedBox(width: 8), Expanded(child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)))])),
      Expanded(flex: 7, child: Align(alignment: Alignment.centerRight, child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold), textAlign: TextAlign.right))),
    ]);
  }
}

class _CentersChannelsTable extends StatelessWidget {
  const _CentersChannelsTable({required this.definedCenters, required this.definedChannels, required this.authorityCenter});
  final List<String> definedCenters; final List<String> definedChannels; final String? authorityCenter;
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
    final authK = authorityCenter == null ? null : _norm(authorityCenter!);
    final maxLen = keys.length > definedChannels.length ? keys.length : definedChannels.length;
    return Card(
      elevation: 0, color: Colors.black26, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(padding: const EdgeInsets.all(12), child: Column(children: [
        Row(children: [
          Expanded(child: Center(child: Text(l10n.hdEnergyCenters, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
          const SizedBox(width: 10),
          Expanded(child: Center(child: Text(l10n.hdChannels, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
        ]),
        const SizedBox(height: 10), Divider(height: 1, color: Colors.white10), const SizedBox(height: 10),
        ...List.generate(maxLen, (i) {
          final cK = i < keys.length ? keys[i] : null; final ch = i < definedChannels.length ? definedChannels[i] : null;
          final isDef = cK != null && normDef.contains(cK); final isAuth = cK != null && authK == cK;
          return Padding(padding: const EdgeInsets.only(bottom: 10), child: Row(children: [
            Expanded(child: cK == null ? const SizedBox() : _Pill(text: HumanDesignSection.centerL10n(context, cK), tone: isDef ? (isAuth ? _PillTone.authority : _PillTone.conscious) : _PillTone.undefined)),
            const SizedBox(width: 10),
            Expanded(child: ch == null ? const SizedBox() : _Pill(text: ch, tone: _PillTone.conscious)),
          ]));
        }),
      ])),
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