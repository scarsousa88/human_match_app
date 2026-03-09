import 'package:flutter/material.dart';
import 'package:human_match_app/l10n/app_localizations.dart';

/// UI presenter for Human Design base data coming from Firestore.
/// Expects a map like: data['humanDesignBase'].
///
/// New fields supported (if present):
/// - signature
/// - notSelfTheme
/// - definition
/// - incarnationCross
/// - authorityCenter
class HumanDesignSection extends StatelessWidget {
  const HumanDesignSection({
    super.key,
    required this.hd,
  });

  final Map<String, dynamic> hd;

  // Keep table alignment consistent between header and rows.
  static const int _flexPlanet = 2;
  static const int _flexPill = 3;
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

    final definedCenters =
        (hd['definedCenters'] as List?)?.map((e) => e.toString()).toList() ??
            const <String>[];
    final definedChannels =
        (hd['definedChannels'] as List?)?.map((e) => e.toString()).toList() ??
            const <String>[];

    final activationsRaw = hd['activations'];
    final activations = (activationsRaw is List)
        ? activationsRaw
            .whereType<Map>()
            .map((m) => m.cast<String, dynamic>())
            .toList()
        : <Map<String, dynamic>>[];

    final conscious = activations.where((a) => a['conscious'] == true).toList();
    final design = activations.where((a) => a['conscious'] == false).toList();

    final profile = _computeProfile(hd, conscious, design);
    final rows = _buildCompareRows(conscious, design);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1) KPI zone
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

        const SizedBox(height: 1),

        // 2) Centers + Channels (Table structure)
        _CentersChannelsTable(
          definedCenters: definedCenters,
          definedChannels: (definedChannels.map(_normalizeChannel).toList()..sort()),
          authorityCenter: authorityCenter,
        ),

        const SizedBox(height: 12),

        // 3) Activations table
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

  // -------------------------
  // Profile
  // -------------------------

  static String _computeProfile(
    Map<String, dynamic> hd,
    List<Map<String, dynamic>> conscious,
    List<Map<String, dynamic>> design,
  ) {
    final direct = (hd['profile'] ?? '').toString().trim();
    if (direct.isNotEmpty) return direct;

    int? pSunLine;
    for (final a in conscious) {
      if ((a['body'] ?? '').toString() == 'Sun' && a['line'] is int) {
        pSunLine = a['line'] as int;
        break;
      }
    }

    int? dSunLine;
    for (final a in design) {
      if ((a['body'] ?? '').toString() == 'Sun' && a['line'] is int) {
        dSunLine = a['line'] as int;
        break;
      }
    }

    if (pSunLine != null && dSunLine != null) {
      return '$pSunLine/$dSunLine';
    }
    return '—';
  }

  // -------------------------
  // Design / Astros / Personality table
  // -------------------------

  static List<_CompareRow> _buildCompareRows(
    List<Map<String, dynamic>> conscious,
    List<Map<String, dynamic>> design,
  ) {
    const order = <String>[
      'Sun',
      'Earth',
      'Moon',
      'Mercury',
      'Venus',
      'Mars',
      'Jupiter',
      'Saturn',
      'Uranus',
      'Neptune',
      'Pluto',
    ];

    const hiddenBodies = <String>{
      'TrueNode', 
      'SouthNode', 
      'NorthNode', 
      'North Node', 
      'South Node'
    };

    final cMap = <String, Map<String, dynamic>>{};
    for (final a in conscious) {
      final body = (a['body'] ?? '').toString();
      if (body.isNotEmpty) cMap[body] = a;
    }

    final dMap = <String, Map<String, dynamic>>{};
    for (final a in design) {
      final body = (a['body'] ?? '').toString();
      if (body.isNotEmpty) dMap[body] = a;
    }

    final rows = <_CompareRow>[];

    for (final body in order) {
      final c = cMap[body];
      final d = dMap[body];
      if (c == null && d == null) continue;

      rows.add(_CompareRow(
        body: body,
        consciousGL: _gl(c),
        designGL: _gl(d),
      ));
    }

    final allBodies = {...cMap.keys, ...dMap.keys};
    for (final body in allBodies) {
      if (order.contains(body)) continue;
      if (hiddenBodies.contains(body)) continue;
      rows.add(_CompareRow(
        body: body,
        consciousGL: _gl(cMap[body]),
        designGL: _gl(dMap[body]),
      ));
    }

    return rows;
  }

  static String _gl(Map<String, dynamic>? a) {
    if (a == null) return '—';
    final gate = a['gate'];
    final line = a['line'];
    if (gate is int && line is int) return '$gate.$line';
    return '—';
  }

  static String _normalizeChannel(String s) {
    final parts = s.split('-');
    if (parts.length != 2) return s;
    final a = int.tryParse(parts[0]);
    final b = int.tryParse(parts[1]);
    if (a == null || b == null) return s;
    return (a < b) ? '$a-$b' : '$b-$a';
  }

  // -------------------------
  // Translations
  // -------------------------

  static String _translateType(BuildContext context, String type) {
    final l10n = AppLocalizations.of(context)!;
    switch (type.trim().toLowerCase()) {
      case 'generator':
      case 'gerador':
        return l10n.hdGen;
      case 'manifesting generator':
      case 'gerador manifestador':
        return l10n.hdMG;
      case 'manifestor':
      case 'manifestador':
        return l10n.hdMan;
      case 'projector':
      case 'projetor':
        return l10n.hdProj;
      case 'reflector':
      case 'refletor':
        return l10n.hdRef;
      default:
        return _titleCase(type);
    }
  }

  static String _translateAuthority(BuildContext context, String s) {
    final l10n = AppLocalizations.of(context)!;
    final t = s.trim();
    if (t.isEmpty || t == '—') return '—';
    switch (t.toLowerCase()) {
      case 'emotional':
      case 'emocional':
        return l10n.hdAuthEmo;
      case 'sacral':
        return l10n.hdAuthSac;
      case 'splenic':
      case 'esplénica':
      case 'esplenica':
        return l10n.hdAuthSpl;
      case 'ego':
      case 'egoic':
        return l10n.hdAuthEgo;
      case 'self-projected':
      case 'auto-projetada':
      case 'auto projetada':
      case 'autoproyectada':
        return l10n.hdAuthSelf;
      case 'mental':
        return l10n.hdAuthMen;
      case 'lunar':
        return l10n.hdAuthLun;
      default:
        return _titleCase(t);
    }
  }

  static String _translateStrategy(BuildContext context, String s) {
    final l10n = AppLocalizations.of(context)!;
    final t = s.trim();
    if (t.isEmpty || t == '—') return '—';
    switch (t.toLowerCase()) {
      case 'informar':
      case 'to inform':
        return l10n.hdStrInf;
      case 'responder':
      case 'to respond':
      case 'esperar para responder':
      case 'wait to respond':
        return l10n.hdStrResp;
      case 'responder e informar':
      case 'to respond and inform':
        return l10n.hdStrRespInf;
      case 'esperar convite':
      case 'esperar pelo convite':
      case 'wait for the invitation':
      case 'esperar la invitación':
      case 'attendre l\'invitation':
      case 'wait for invitation':
        return l10n.hdStrInv;
      case 'esperar ciclo lunar':
      case 'wait a lunar cycle':
      case 'esperar un ciclo lunar':
      case 'attendre um cycle lunaire':
      case 'wait for a lunar cycle':
        return l10n.hdStrLun;
      default:
        return _titleCase(t);
    }
  }

  static String _translateSignature(BuildContext context, String s) {
    final l10n = AppLocalizations.of(context)!;
    final t = s.trim().toLowerCase();
    if (t.isEmpty || t == '—') return '—';
    switch (t) {
      case 'satisfaction':
      case 'satisfação':
        return l10n.hdSigSat;
      case 'success':
      case 'sucesso':
        return l10n.hdSigSuc;
      case 'peace':
      case 'paz':
        return l10n.hdSigPea;
      case 'surprise':
      case 'surpresa':
        return l10n.hdSigSur;
      default:
        return _titleCase(s);
    }
  }

  static String _translateNotSelf(BuildContext context, String s) {
    final l10n = AppLocalizations.of(context)!;
    final t = s.trim().toLowerCase();
    if (t.isEmpty || t == '—') return '—';
    switch (t) {
      case 'frustration':
      case 'frustração':
        return l10n.hdNotFru;
      case 'bitterness':
      case 'amargura':
        return l10n.hdNotBit;
      case 'anger':
      case 'raiva':
        return l10n.hdNotAng;
      case 'disappointment':
      case 'desilusão':
      case 'desapontamento':
        return l10n.hdNotDis;
      default:
        return _titleCase(s);
    }
  }

  static String _translateDefinition(BuildContext context, String s) {
    final l10n = AppLocalizations.of(context)!;
    final t = s.trim().toLowerCase();
    if (t.isEmpty || t == '—') return '—';
    switch (t) {
      case 'single':
      case 'single definition':
      case 'definição única':
        return l10n.hdDefSin;
      case 'split':
      case 'split definition':
      case 'definição partida':
        return l10n.hdDefSpl;
      case 'triple split':
      case 'triple split definition':
      case 'definição tripla':
        return l10n.hdDefTri;
      case 'quadruple split':
      case 'quadruple split definition':
      case 'definição quádrupla':
        return l10n.hdDefQua;
      default:
        return _titleCase(s);
    }
  }

  static String _translateCross(BuildContext context, String s) {
    final l10n = AppLocalizations.of(context)!;
    var t = s.trim();
    if (t.isEmpty || t == '—') return '—';
    t = t.replaceFirst('Right Angle', l10n.hdCrossRight);
    t = t.replaceFirst('Left Angle', l10n.hdCrossLeft);
    t = t.replaceFirst('Juxtaposition', l10n.hdCrossJuxta);
    t = t.replaceFirst('Cross of', l10n.hdCrossOf);
    return t;
  }

  static String centerL10n(BuildContext context, String s) {
    final l10n = AppLocalizations.of(context)!;
    final k = s.trim().toLowerCase();
    switch (k) {
      case 'head':
        return l10n.hdCenterHead;
      case 'ajna':
        return l10n.hdCenterAjna;
      case 'throat':
        return l10n.hdCenterThroat;
      case 'g':
      case 'identity':
        return l10n.hdCenterG;
      case 'ego':
      case 'heart':
      case 'will':
        return l10n.hdCenterEgo;
      case 'spleen':
        return l10n.hdCenterSpleen;
      case 'solarplexus':
      case 'solar plexus':
        return l10n.hdCenterSolar;
      case 'sacral':
        return l10n.hdCenterSacral;
      case 'root':
        return l10n.hdCenterRoot;
      default:
        return s;
    }
  }

  static String _titleCase(String s) {
    final t = s.trim();
    if (t.isEmpty || t == '—') return '—';
    if (RegExp(r'^\d+/\d+$').hasMatch(t)) return t;

    final parts = t.split(RegExp(r'\s+'));
    return parts
        .map((w) {
          if (w.isEmpty) return w;
          final lower = w.toLowerCase();
          return lower[0].toUpperCase() + lower.substring(1);
        })
        .join(' ');
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Row(
            children: [
              Icon(icon, size: 18, color: HumanDesignSection.goldColor),
              const SizedBox(width: 8),
              Expanded(child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600))),
            ],
          ),
        ),
        Expanded(
          flex: 7,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold), textAlign: TextAlign.right),
          ),
        ),
      ],
    );
  }
}

class _CentersChannelsTable extends StatelessWidget {
  const _CentersChannelsTable({
    required this.definedCenters,
    required this.definedChannels,
    required this.authorityCenter,
  });

  final List<String> definedCenters;
  final List<String> definedChannels;
  final String? authorityCenter;

  String _normalizeKey(String s) {
    final k = s.trim().toLowerCase();
    if (k == 'ego' || k == 'will' || k == 'heart') return 'heart';
    if (k == 'solarplexus' || k == 'solar plexus') return 'solar plexus';
    return k;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    const allCenterKeys = [
      'head',
      'ajna',
      'throat',
      'g',
      'heart',
      'solar plexus',
      'spleen',
      'sacral',
      'root',
    ];

    final normalizedDefined = definedCenters.map(_normalizeKey).toSet();
    final authKey = authorityCenter == null ? null : _normalizeKey(authorityCenter!);

    final channelItems = definedChannels;
    final maxLen = allCenterKeys.length > channelItems.length ? allCenterKeys.length : channelItems.length;

    final authorityLabel = authorityCenter == null ? null : HumanDesignSection.centerL10n(context, authorityCenter!);

    return Card(
      elevation: 0,
      color: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Center(child: Text(l10n.hdEnergyCenters, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
                const SizedBox(width: 10),
                Expanded(child: Center(child: Text(l10n.hdChannels, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
              ],
            ),
            const SizedBox(height: 10),
            Divider(height: 1, color: Colors.white10),
            const SizedBox(height: 10),
            ...List.generate(maxLen, (i) {
              final cKey = i < allCenterKeys.length ? allCenterKeys[i] : null;
              final ch = i < channelItems.length ? channelItems[i] : null;

              final isDefined = cKey != null && normalizedDefined.contains(cKey);
              final isAuthority = cKey != null && authKey == cKey;
              final cName = cKey == null ? null : HumanDesignSection.centerL10n(context, cKey);

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: cName == null
                          ? const SizedBox()
                          : _Pill(
                              text: cName,
                              tone: isDefined
                                  ? (isAuthority ? _PillTone.authority : _PillTone.conscious)
                                  : _PillTone.undefined,
                            ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ch == null
                          ? const SizedBox()
                          : _Pill(
                              text: ch,
                              tone: _PillTone.conscious,
                            ),
                    ),
                  ],
                ),
              );
            }),
            if (authorityLabel != null) ...[
              Divider(height: 1, color: Colors.white10),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n.hdAuthorityNotice(authorityLabel),
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CompareRow {
  final String body;
  final String consciousGL;
  final String designGL;

  const _CompareRow({
    required this.body,
    required this.consciousGL,
    required this.designGL,
  });
}

class _ActivationHeader extends StatelessWidget {
  const _ActivationHeader();

  static const int _flexPlanet = HumanDesignSection._flexPlanet;
  static const int _flexPill = HumanDesignSection._flexPill;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Flexible(
          flex: _flexPill,
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n.hdDesign, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                Text(l10n.hdUnconscious, style: const TextStyle(color: Colors.white38, fontSize: 11)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          flex: _flexPlanet,
          child: Align(
            alignment: Alignment.center,
            child: Text(l10n.hdPlanets, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          flex: _flexPill,
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n.hdPersonality, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                Text(l10n.hdConscious, style: const TextStyle(color: Colors.white38, fontSize: 11)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ActivationCompareRow extends StatelessWidget {
  const _ActivationCompareRow({required this.row});
  final _CompareRow row;

  static const int _flexPlanet = HumanDesignSection._flexPlanet;
  static const int _flexPill = HumanDesignSection._flexPill;

  @override
  Widget build(BuildContext context) {
    final sym = _planetSymbol(row.body);
    final name = _planetName(context, row.body);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: _flexPill,
            child: _Pill(text: row.designGL, tone: _PillTone.design),
          ),
          const SizedBox(width: 12),
          Flexible(
            flex: _flexPlanet,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(sym, style: const TextStyle(fontSize: 17, color: HumanDesignSection.goldColor)),
                const SizedBox(width: 4),
                Text(
                  name,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            flex: _flexPill,
            child: _Pill(text: row.consciousGL, tone: _PillTone.conscious),
          ),
        ],
      ),
    );
  }

  String _planetName(BuildContext context, String body) {
    final l10n = AppLocalizations.of(context)!;
    switch (body) {
      case 'Sun': return l10n.hdPlanetSun;
      case 'Earth': return l10n.hdPlanetEarth;
      case 'Moon': return l10n.hdPlanetMoon;
      case 'Mercury': return l10n.hdPlanetMercury;
      case 'Venus': return l10n.hdPlanetVenus;
      case 'Mars': return l10n.hdPlanetMars;
      case 'Jupiter': return l10n.hdPlanetJupiter;
      case 'Saturn': return l10n.hdPlanetSaturn;
      case 'Uranus': return l10n.hdPlanetUranus;
      case 'Neptune': return l10n.hdPlanetNeptune;
      case 'Pluto': return l10n.hdPlanetPluto;
      default: return body;
    }
  }

  String _planetSymbol(String body) {
    switch (body) {
      case 'Sun': return '☉';
      case 'Earth': return '⊕';
      case 'Moon': return '☾';
      case 'Mercury': return '☿';
      case 'Venus': return '♀';
      case 'Mars': return '♂';
      case 'Jupiter': return '♃';
      case 'Saturn': return '♄';
      case 'Uranus': return '♅';
      case 'Neptune': return '♆';
      case 'Pluto': return '♇';
      default: return '•';
    }
  }
}

enum _PillTone { conscious, design, authority, undefined }

class _Pill extends StatelessWidget {
  const _Pill({required this.text, required this.tone});
  final String text;
  final _PillTone tone;

  @override
  Widget build(BuildContext context) {
    Color border;
    Color bg;
    Color fg = Colors.white;

    switch (tone) {
      case _PillTone.conscious:
        border = Colors.white.withOpacity(0.15);
        bg = Colors.white10;
        break;
      case _PillTone.design:
        border = Colors.redAccent.withOpacity(0.2);
        bg = Colors.redAccent.withOpacity(0.08);
        break;
      case _PillTone.authority:
        border = Colors.purpleAccent.withOpacity(0.3);
        bg = Colors.purpleAccent.withOpacity(0.12);
        break;
      case _PillTone.undefined:
        border = Colors.white.withOpacity(0.05);
        bg = Colors.transparent;
        fg = Colors.white38;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: bg,
        border: Border.all(color: border),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: fg, fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
