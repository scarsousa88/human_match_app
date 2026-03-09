import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'bodygraph_data.dart';

class BodygraphWidget extends StatefulWidget {
  final BodygraphData data;
  const BodygraphWidget({super.key, required this.data});

  @override
  State<BodygraphWidget> createState() => _BodygraphWidgetState();
}

class _BodygraphWidgetState extends State<BodygraphWidget> {
  String? _svgString;
  String? _silhouetteSvg;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAndProcessSvg();
  }

  @override
  void didUpdateWidget(BodygraphWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _loadAndProcessSvg();
    }
  }

  Future<void> _loadAndProcessSvg() async {
    try {
      String rawSvg = await rootBundle.loadString('assets/bodygraph/bodygraph_blank.svg');
      String silSvg = await rootBundle.loadString('assets/bodygraph/bodygraph_silhouette.svg');

      // Corrigir a silhueta para garantir que o flutter_svg a renderize bem
      silSvg = silSvg.replaceAll('xlink:href', 'href');
      silSvg = silSvg.replaceAll('fill="transparent"', 'fill="none"');
      if (!silSvg.contains('xmlns:xlink')) {
        silSvg = silSvg.replaceFirst('<svg', '<svg xmlns:xlink="http://www.w3.org/1999/xlink"');
      }

      String processedSvg = _processSvg(rawSvg, widget.data);

      if (mounted) {
        setState(() {
          _svgString = processedSvg;
          _silhouetteSvg = silSvg;
          _error = null;
        });
      }
    } catch (e) {
      debugPrint('Erro no BodygraphWidget: $e');
      if (mounted) {
        setState(() {
          _error = e.toString();
        });
      }
    }
  }

  String _darkenHex(String hex, double factor) {
    if (hex.length != 7 || !hex.startsWith('#')) return hex;
    Color color = Color(int.parse(hex.substring(1, 7), radix: 16) + 0xFF000000);
    int red = (color.red * (1 - factor)).round().clamp(0, 255);
    int green = (color.green * (1 - factor)).round().clamp(0, 255);
    int blue = (color.blue * (1 - factor)).round().clamp(0, 255);
    return '#${red.toRadixString(16).padLeft(2, '0')}${green.toRadixString(16).padLeft(2, '0')}${blue.toRadixString(16).padLeft(2, '0')}';
  }

  String _processSvg(String raw, BodygraphData data) {
    // 1. Limpeza de filtros e sombras que podem ocultar a silhueta
    String processed = raw.replaceAll(RegExp(r'<filter[\s\S]*?</filter>'), '');
    processed = processed.replaceAll('filter="url(#drop-shadow)"', '');

    // 2. Tornar áreas não definidas quase transparentes (fill-opacity="0.1")
    // para que a silhueta no fundo apareça através delas.
    processed = processed.replaceAll('fill="#fff"', 'fill="#ffffff" fill-opacity="0.1"');

    final allActiveGates = {...data.consciousGates, ...data.designGates};

    var gradients = '''
    <linearGradient id="gradientForVerticalChannels" x1="0%" y1="0%" x2="100%" y2="0%"><stop offset="50%" stop-color="#A44344" /><stop offset="50%" stop-color="black" /></linearGradient>
    <linearGradient id="gradientForHorizontalChannels" x1="0%" y1="0%" x2="0%" y2="100%"><stop offset="50%" stop-color="#A44344" /><stop offset="50%" stop-color="black" /></linearGradient>
    <linearGradient id="gradientForDiagonalChannels" x1="0%" y1="0%" x2="100%" y2="100%"><stop offset="50%" stop-color="#A44344" /><stop offset="50%" stop-color="black" /></linearGradient>
    <linearGradient id="gradientForSpleenRootChannels" x1="100%" y1="0%" x2="4%" y2="100%"><stop offset="50%" stop-color="#A44344" /><stop offset="50%" stop-color="black" /></linearGradient>
    <linearGradient id="gradientForSolarPlexusRootChannels" x1="4%" y1="0%" x2="100%" y2="100%"><stop offset="50%" stop-color="#A44344" /><stop offset="50%" stop-color="black" /></linearGradient>
    <linearGradient id="gradientFor59_6" x1="9%" y1="25%" x2="50%" y2="100%"><stop offset="50%" stop-color="#A44344" /><stop offset="50%" stop-color="black" /></linearGradient>
    <linearGradient id="gradientFor50_27" x1="50%" y1="0%" x2="9%" y2="75%"><stop offset="50%" stop-color="#A44344" /><stop offset="50%" stop-color="black" /></linearGradient>
    <linearGradient id="gradientFor25_51" x1="100%" y1="0%" x2="4%" y2="100%"><stop offset="50%" stop-color="#A44344" /><stop offset="50%" stop-color="black" /></linearGradient>
    <linearGradient id="gradientForGate34" x1="100%" y1="0%" x2="4%" y2="100%"><stop offset="50%" stop-color="#A44344" /><stop offset="50%" stop-color="black" /></linearGradient>
    <linearGradient id="gradientForGate10Connect" x1="100%" y1="90%" x2="0%" y2="0%"><stop offset="50%" stop-color="#A44344" /><stop offset="50%" stop-color="black" /></linearGradient>
    ''';

    final centerColors = {
      'Head': '#F9F6C4', 'Ajna': '#48BB78', 'Throat': '#655144', 'Spleen': '#655144',
      'Ego': '#F56565', 'G': '#F9F6C4', 'SolarPlexus': '#655144', 'Sacral': '#F56565', 'Root': '#655144',
    };

    centerColors.forEach((id, color) {
      final darker = _darkenHex(color, 0.4);
      gradients += '<linearGradient id="${id.toLowerCase()}Gradient" x1="0%" y1="0%" x2="0%" y2="140%"><stop offset="0%" stop-color="$color" /><stop offset="100%" stop-color="$darker" /></linearGradient>';
    });

    if (processed.contains('<defs>')) {
      processed = processed.replaceFirst('<defs>', '<defs>$gradients');
    } else {
      processed = processed.replaceFirst('<svg', '<svg><defs>$gradients</defs>');
    }

    data.definedChannels.forEach((channel) {
      final parts = channel.split('-');
      if(parts.length != 2) return;
      final gateA = int.tryParse(parts[0]);
      final gateB = int.tryParse(parts[1]);
      if (gateA == null || gateB == null) return;

      final centerPair = _getCenterPairForChannel(gateA, gateB);
      if (centerPair.isNotEmpty) {
        for (var centerId in centerPair) {
            final gradientFill = 'url(#${centerId.toLowerCase()}Gradient)';
            // Substituir o fill-opacity="0.1" por opacity total quando o centro está definido
            final regex = RegExp('(<g id="$centerId"[^>]*>\\s*<path[^>]*?)fill="[^"]*"(?:\\s+fill-opacity="[^"]*")?');
            processed = processed.replaceFirstMapped(regex, (m) => '${m.group(1)}fill="$gradientFill" fill-opacity="1.0"');
        }
      }
    });

    for (int i = 1; i <= 64; i++) {
      if (!allActiveGates.contains(i)) continue;

      final isC = data.consciousGates.contains(i);
      final isD = data.designGates.contains(i);
      String fill = isC ? 'black' : '#A44344';
      if (isC && isD) {
        fill = _getGradientForChannel(i);
      }

      processed = processed.replaceFirstMapped(RegExp('id="Gate$i"\\s+[^>]*fill="[^"]*"(?:\\s+fill-opacity="[^"]*")?'), (m) => m.group(0)!.replaceFirst(RegExp('fill="[^"]*"'), 'fill="$fill"').replaceFirst(RegExp('fill-opacity="[^"]*"'), 'fill-opacity="1.0"'));
      processed = processed.replaceFirstMapped(RegExp('id="GateText$i"[^>]*fill="[^"]*"'), (m) => m.group(0)!.replaceFirst(RegExp('fill="[^"]*"'), 'fill="#343434"'));
      final bgRegex = RegExp('(<g id="GateTextBg$i"[^>]*>\\s*<(?:path|circle)[^>]*?)fill="[^"]*"(?:\\s+fill-opacity="[^"]*")?');
      processed = processed.replaceFirstMapped(bgRegex, (m) => '${m.group(1)}fill="#EFEFEF" fill-opacity="1.0"');
    }

    if ((data.consciousGates.contains(34) && data.consciousGates.contains(20)) ||
        (data.consciousGates.contains(34) && data.consciousGates.contains(10)) ||
        (data.consciousGates.contains(57) && data.consciousGates.contains(20))) {
      processed = _applyIntegration(processed, 'black');
    } else if ((data.designGates.contains(34) && data.designGates.contains(20)) ||
               (data.designGates.contains(34) && data.designGates.contains(10)) ||
               (data.designGates.contains(57) && data.designGates.contains(20))) {
      processed = _applyIntegration(processed, '#A44344');
    }

    return processed;
  }

  String _getGradientForChannel(int gate) {
      if (gate == 10) return 'url(#gradientForHorizontalChannels)';
      if (gate == 50 || gate == 27) return 'url(#gradientFor50_27)';
      if (gate == 6 || gate == 59) return 'url(#gradientFor59_6)';
      if ([16, 48, 57, 20].contains(gate)) return 'url(#gradientForGate10Connect)';
      if ([32, 54, 28, 38, 58, 18].contains(gate)) return 'url(#gradientForSpleenRootChannels)';
      if (gate == 34) return 'url(#gradientForGate34)';
      if (gate == 25 || gate == 51) return 'url(#gradientFor25_51)';
      if ([44, 26, 45, 21, 12, 22, 35, 36, 37, 40].contains(gate)) return 'url(#gradientForDiagonalChannels)';
      if ([19, 49, 39, 55, 41, 30].contains(gate)) return 'url(#gradientForSolarPlexusRootChannels)';
      return 'url(#gradientForVerticalChannels)';
  }

  List<String> _getCenterPairForChannel(int gateA, int gateB) {
      final channels = {
        '1-8': ['G', 'Throat'], '7-31': ['G', 'Throat'], '13-33': ['G', 'Throat'], '10-20': ['G', 'Throat'],
        '43-23': ['Ajna', 'Throat'], '17-62': ['Ajna', 'Throat'], '11-56': ['Ajna', 'Throat'],
        '64-47': ['Head', 'Ajna'], '61-24': ['Head', 'Ajna'], '63-4': ['Head', 'Ajna'],
        '21-45': ['Ego', 'Throat'], '35-36': ['Throat', 'SolarPlexus'], '12-22': ['Throat', 'SolarPlexus'],
        '34-20': ['Sacral', 'Throat'], '57-20': ['Spleen', 'Throat'], '16-48': ['Throat', 'Spleen'],
        '52-9': ['Root', 'Sacral'], '53-42': ['Root', 'Sacral'], '60-3': ['Root', 'Sacral'],
        '2-14': ['G', 'Sacral'], '5-15': ['G', 'Sacral'], '29-46': ['Sacral', 'G'],
        '27-50': ['Sacral', 'Spleen'], '34-57': ['Sacral', 'Spleen'],
        '6-59': ['SolarPlexus', 'Sacral'], '19-49': ['Root', 'SolarPlexus'], '39-55': ['Root', 'SolarPlexus'], '41-30': ['Root', 'SolarPlexus'],
        '54-32': ['Root', 'Spleen'], '58-18': ['Root', 'Spleen'], '38-28': ['Root', 'Spleen'],
        '25-51': ['G', 'Ego'], '44-26': ['Spleen', 'Ego'], '37-40': ['SolarPlexus', 'Ego']
      };
      final key = gateA < gateB ? '$gateA-$gateB' : '$gateB-$gateA';
      return channels[key] ?? [];
  }

  String _applyIntegration(String svg, String fill) {
    var res = svg;
    for (var id in ['GateSpan', 'GateConnect10', 'GateConnect34']) {
      res = res.replaceFirstMapped(RegExp('id="$id"[^>]*fill="[^"]*"(?:\\s+fill-opacity="[^"]*")?'), (m) => m.group(0)!.replaceFirst(RegExp('fill="[^"]*"'), 'fill="$fill"').replaceFirst(RegExp('fill-opacity="[^"]*"'), 'fill-opacity="1.0"'));
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) return Center(child: Text('Erro: $_error', style: const TextStyle(color: Colors.white)));
    if (_svgString == null || _silhouetteSvg == null) return const Center(child: Padding(padding: EdgeInsets.symmetric(vertical: 40), child: CircularProgressIndicator()));
    
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Silhueta de fundo (SVG estático processado)
            // Usamos ColorFiltered para forçar a silhueta a ser branca/clara sobre o fundo escuro
            Opacity(
              opacity: 0.6,
              child: ColorFiltered(
                colorFilter: const ColorFilter.mode(Colors.white54, BlendMode.srcIn),
                child: SvgPicture.string(
                  _silhouetteSvg!,
                  width: constraints.maxWidth,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // Bodygraph processado dinamicamente com transparência nas áreas vazias
            SvgPicture.string(
              _svgString!,
              width: constraints.maxWidth,
              fit: BoxFit.contain,
            ),
          ],
        );
      },
    );
  }
}
