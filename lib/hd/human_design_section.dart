import 'package:flutter/material.dart';

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
  static const int _flexPlanet = 6;
  static const int _flexPill = 4;

  @override
  Widget build(BuildContext context) {
    final type = _translateType((hd['type'] ?? '—').toString());
    final authority = _translateAuthority((hd['authority'] ?? '—').toString());
    final strategy = _translateStrategy((hd['strategy'] ?? '—').toString());

    final signature = _titleCase((hd['signature'] ?? '—').toString());
    final notSelfTheme = _titleCase((hd['notSelfTheme'] ?? '—').toString());
    final definition = (hd['definition'] ?? '—').toString();
    final incarnationCross = (hd['incarnationCross'] ?? '—').toString();

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
                _InfoLine(icon: Icons.person_outline, label: 'Tipo', value: type),
                const SizedBox(height: 10),
                _InfoLine(icon: Icons.favorite_outline, label: 'Autoridade', value: authority),
                const SizedBox(height: 10),
                _InfoLine(icon: Icons.alt_route_outlined, label: 'Estratégia', value: strategy),
                const SizedBox(height: 10),
                _InfoLine(icon: Icons.badge_outlined, label: 'Perfil', value: profile),
                const SizedBox(height: 10),
                _InfoLine(icon: Icons.auto_awesome_outlined, label: 'Signature', value: signature),
                const SizedBox(height: 10),
                _InfoLine(icon: Icons.warning_amber_outlined, label: 'Not‑self', value: notSelfTheme),
                const SizedBox(height: 10),
                _InfoLine(icon: Icons.hub_outlined, label: 'Definition', value: definition),
                const SizedBox(height: 10),
                _InfoLine(icon: Icons.add_road_outlined, label: 'Cross', value: incarnationCross),
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
  // Compare table
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

  static String _translateType(String type) {
    switch (type.trim().toLowerCase()) {
      case 'generator':
        return 'Gerador';
      case 'manifesting generator':
        return 'Gerador Manifestante';
      case 'manifestor':
        return 'Manifestador';
      case 'projector':
        return 'Projetor';
      case 'reflector':
        return 'Refletor';
      default:
        return _titleCase(type);
    }
  }

  static String _translateAuthority(String s) {
    final t = s.trim();
    if (t.isEmpty || t == '—') return '—';
    switch (t.toLowerCase()) {
      case 'emotional':
      case 'emocional':
        return 'Emocional';
      case 'sacral':
        return 'Sacral';
      case 'splenic':
      case 'esplénica':
      case 'esplenica':
        return 'Esplénica';
      case 'ego':
      case 'egoic':
        return 'Ego';
      case 'self-projected':
      case 'auto-projetada':
      case 'auto projetada':
        return 'Auto-projetada';
      case 'mental':
        return 'Mental';
      default:
        return _titleCase(t);
    }
  }

  static String _translateStrategy(String s) {
    final t = s.trim();
    if (t.isEmpty || t == '—') return '—';
    switch (t.toLowerCase()) {
      case 'informar':
      case 'to inform':
        return 'Informar';
      case 'esperar para responder':
      case 'wait to respond':
        return 'Esperar para responder';
      case 'esperar convite':
      case 'esperar pelo convite':
      case 'wait for the invitation':
        return 'Esperar pelo convite';
      case 'esperar ciclo lunar':
      case 'wait a lunar cycle':
        return 'Esperar ciclo lunar';
      default:
        return _titleCase(t);
    }
  }

  static String _centerPt(String s) {
    final k = s.trim();
    switch (k) {
      case 'head':
      case 'Head':
        return 'Cabeça';
      case 'ajna':
      case 'Ajna':
        return 'Ajna';
      case 'throat':
      case 'Throat':
        return 'Garganta';
      case 'g':
      case 'G':
        return 'Identidade (G)';
      case 'ego':
      case 'Ego':
      case 'Heart':
      case 'Will':
        return 'Ego (Coração)';
      case 'spleen':
      case 'Spleen':
        return 'Baço';
      case 'solarPlexus':
      case 'Solar Plexus':
      case 'SolarPlexus':
        return 'Plexo Solar';
      case 'sacral':
      case 'Sacral':
        return 'Sacral';
      case 'root':
      case 'Root':
        return 'Raiz';
      default:
        return k;
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
    final centerItems = definedCenters.map(HumanDesignSection._centerPt).toList()..sort();
    final channelItems = definedChannels;

    final maxLen = centerItems.length > channelItems.length ? centerItems.length : channelItems.length;
    final authorityLabel = authorityCenter == null ? null : HumanDesignSection._centerPt(authorityCenter!);

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
                Expanded(child: Center(child: Text('Centros definidos', style: titleStyle))),
                const SizedBox(width: 10),
                Expanded(child: Center(child: Text('Canais', style: titleStyle))),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 10),
            if (maxLen == 0)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Nenhum dado disponível.',
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
                  '* $authorityLabel é o centro autoritário (Authority)',
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
            child: headerCell('Design', '(Inconsciente)'),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          flex: _flexPlanet,
          child: Align(
            alignment: Alignment.center,
            child: Text('Astros', style: titleStyle),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          flex: _flexPill,
          child: Align(
            alignment: Alignment.center,
            child: headerCell('Personalidade', '(Consciente)'),
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
    final namePt = _planetNamePt(row.body);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: _flexPill,
            child: _Pill(text: row.designGL, tone: _PillTone.design),
          ),
          const SizedBox(width: 10),
          Flexible(
            flex: _flexPlanet,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(sym, style: const TextStyle(fontSize: 17)),
                const SizedBox(width: 6),
                Text(
                  namePt,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: (Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14) + 1,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            flex: _flexPill,
            child: _Pill(text: row.consciousGL, tone: _PillTone.conscious),
          ),
        ],
      ),
    );
  }

  String _planetNamePt(String body) {
    switch (body) {
      case 'Sun': return 'Sol';
      case 'Earth': return 'Terra';
      case 'Moon': return 'Lua';
      case 'Mercury': return 'Mercúrio';
      case 'Venus': return 'Vénus';
      case 'Mars': return 'Marte';
      case 'Jupiter': return 'Júpiter';
      case 'Saturn': return 'Saturno';
      case 'Uranus': return 'Urano';
      case 'Neptune': return 'Neptuno';
      case 'Pluto': return 'Plutão';
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
