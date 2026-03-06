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
  // We give more space to the side columns (Design/Personality) to avoid clipping and allow more detail.
  static const int _flexPlanet = 2;
  static const int _flexPill = 3;

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
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                const _ActivationHeader(),
                const SizedBox(height: 10),
                const Divider(height: 1),
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

    const hiddenBodies = <String>{'TrueNode', 'SouthNode'};

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
        return l10n.hdGen;
      case 'manifesting generator':
        return l10n.hdMG;
      case 'manifestor':
        return l10n.hdMan;
      case 'projector':
        return l10n.hdProj;
      case 'reflector':
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
      case 'esperar para responder':
      case 'wait to respond':
        return l10n.hdStrResp;
      case 'esperar convite':
      case 'esperar pelo convite':
      case 'wait for the invitation':
      case 'esperar la invitación':
      case 'attendre l\'invitation':
        return l10n.hdStrInv;
      case 'esperar ciclo lunar':
      case 'wait a lunar cycle':
      case 'esperar un ciclo lunar':
      case 'attendre um cycle lunaire':
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
        return l10n.hdSigSat;
      case 'success':
        return l10n.hdSigSuc;
      case 'peace':
        return l10n.hdSigPea;
      case 'surprise':
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
        return l10n.hdNotFru;
      case 'bitterness':
        return l10n.hdNotBit;
      case 'anger':
        return l10n.hdNotAng;
      case 'disappointment':
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
        return l10n.hdDefSin;
      case 'split':
      case 'split definition':
        return l10n.hdDefSpl;
      case 'triple split':
      case 'triple split definition':
        return l10n.hdDefTri;
      case 'quadruple split':
      case 'quadruple split definition':
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
    final labelStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: (Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14) + 1,
        );
    final valueStyle = Theme.of(context).textTheme.titleSmall?.copyWith(
          fontSize: (Theme.of(context).textTheme.titleSmall?.fontSize ?? 14) + 1,
        );

    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Row(
            children: [
              Icon(icon, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text(label, style: labelStyle)),
            ],
          ),
        ),
        Expanded(
          flex: 7,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(value, style: valueStyle, textAlign: TextAlign.right),
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final centerItems = definedCenters.map((s) => HumanDesignSection.centerL10n(context, s)).toList()..sort();
    final channelItems = definedChannels;

    final maxLen = centerItems.length > channelItems.length ? centerItems.length : channelItems.length;
    final authorityLabel = authorityCenter == null ? null : HumanDesignSection.centerL10n(context, authorityCenter!);

    final titleStyle = Theme.of(context).textTheme.titleSmall?.copyWith(
          fontSize: (Theme.of(context).textTheme.titleSmall?.fontSize ?? 14) + 1,
        );

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Center(child: Text(l10n.hdDefinedCenters, style: titleStyle))),
                const SizedBox(width: 10),
                Expanded(child: Center(child: Text(l10n.hdChannels, style: titleStyle))),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 10),
            if (maxLen == 0)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  l10n.hdNoData,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: (Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14) + 1,
                      ),
                ),
              )
            else
              ...List.generate(maxLen, (i) {
                final c = i < centerItems.length ? centerItems[i] : null;
                final ch = i < channelItems.length ? channelItems[i] : null;
                final isAuthority = authorityLabel != null && c == authorityLabel;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: c == null
                            ? const SizedBox()
                            : _Pill(
                                text: c,
                                tone: isAuthority ? _PillTone.authority : _PillTone.conscious,
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
              const Divider(height: 1),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n.hdAuthorityNotice(authorityLabel),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: (Theme.of(context).textTheme.bodySmall?.fontSize ?? 12) + 1,
                      ),
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
    final titleStyle = Theme.of(context).textTheme.titleSmall?.copyWith(
          fontSize: (Theme.of(context).textTheme.titleSmall?.fontSize ?? 14) + 1,
        );
    final subStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          fontSize: (Theme.of(context).textTheme.bodySmall?.fontSize ?? 12) + 1,
        );

    Widget headerCell(String top, String bottom) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            top,
            style: titleStyle,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            bottom,
            style: subStyle,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );
    }

    return Row(
      children: [
        Flexible(
          flex: _flexPill,
          child: Align(
            alignment: Alignment.center,
            child: headerCell(l10n.hdDesign, l10n.hdUnconscious),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          flex: _flexPlanet,
          child: Align(
            alignment: Alignment.center,
            child: Text(l10n.hdPlanets, style: titleStyle),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          flex: _flexPill,
          child: Align(
            alignment: Alignment.center,
            child: headerCell(l10n.hdPersonality, l10n.hdConscious),
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
                Text(sym, style: const TextStyle(fontSize: 17)),
                const SizedBox(width: 4),
                Text(
                  name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: (Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14) + 1,
                      ),
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

enum _PillTone { conscious, design, authority }

class _Pill extends StatelessWidget {
  const _Pill({required this.text, required this.tone});
  final String text;
  final _PillTone tone;

  @override
  Widget build(BuildContext context) {
    final isDash = text.trim() == '—';

    Color border;
    Color bg;

    switch (tone) {
      case _PillTone.conscious:
        border = Colors.white.withValues(alpha: 0.35);
        bg = Colors.white.withValues(alpha: 0.08);
        break;
      case _PillTone.design:
        border = Colors.redAccent.withValues(alpha: 0.45);
        bg = Colors.redAccent.withValues(alpha: 0.07);
        break;
      case _PillTone.authority:
        border = Colors.purpleAccent.withValues(alpha: 0.45);
        bg = Colors.purpleAccent.withValues(alpha: 0.12);
        break;
    }

    final Color fg = isDash
        ? (Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.6) ?? Colors.white.withValues(alpha: 0.6))
        : (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: bg,
        border: Border.all(color: border),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: fg,
                fontSize: (Theme.of(context).textTheme.titleSmall?.fontSize ?? 14) + 1,
              ),
        ),
      ),
    );
  }
}
