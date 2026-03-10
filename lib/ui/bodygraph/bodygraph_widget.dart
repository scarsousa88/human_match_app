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
      const String blankPath = 'assets/bodygraph/bodygraph_blank.svg';
      const String silPath = 'assets/bodygraph/bodygraph_silhouette.svg';

      final String rawSvg = await rootBundle.loadString(blankPath);
      final String silSvg = await rootBundle.loadString(silPath);

      String processedSil = silSvg.replaceAll('xlink:href', 'href');
      processedSil = processedSil.replaceAll('fill="transparent"', 'fill="none"');
      if (!processedSil.contains('xmlns:xlink')) {
        processedSil = processedSil.replaceFirst('<svg', '<svg xmlns:xlink="http://www.w3.org/1999/xlink"');
      }

      String processedSvg = _processSvg(rawSvg, widget.data);

      if (mounted) {
        setState(() {
          _svgString = processedSvg;
          _silhouetteSvg = processedSil;
          _error = null;
        });
      }
    } catch (e) {
      debugPrint('ERRO BODYGRAPH: $e');
      if (mounted) {
        setState(() {
          _error = 'Erro ao processar gráfico: $e';
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
    String processed = raw.replaceAll(RegExp(r'<filter[\s\S]*?</filter>'), '');
    processed = processed.replaceAll('filter="url(#drop-shadow)"', '');
    processed = processed.replaceAll('fill="#fff"', 'fill="#ffffff" fill-opacity="0.1"');

    final allActiveGates = {...data.consciousGates, ...data.designGates};
    String dynamicGradients = '';

    // Gradiente Unificado Rigoroso para o complexo 57-20-Span
    dynamicGradients += '<linearGradient id="gradIntegration" gradientUnits="userSpaceOnUse" x1="100" y1="850" x2="250" y2="650"><stop offset="50%" stop-color="#A44344" /><stop offset="50%" stop-color="white" /></linearGradient>';

    final centerColors = {
      'Head': '#F9F6C4', 'Ajna': '#48BB78', 'Throat': '#655144', 'Spleen': '#655144',
      'Ego': '#F56565', 'G': '#F9F6C4', 'SolarPlexus': '#655144', 'Sacral': '#F56565', 'Root': '#655144',
    };

    centerColors.forEach((id, color) {
      final darker = _darkenHex(color, 0.4);
      dynamicGradients += '<linearGradient id="${id.toLowerCase()}Gradient" x1="0%" y1="0%" x2="0%" y2="140%"><stop offset="0%" stop-color="$color" /><stop offset="100%" stop-color="$darker" /></linearGradient>';
    });

    // Centros
    data.definedChannels.forEach((channel) {
      final parts = channel.split('-');
      if(parts.length != 2) return;
      final gateA = int.tryParse(parts[0]);
      final gateB = int.tryParse(parts[1]);
      if (gateA == null || gateB == null) return;
      final centerPair = _getCenterPairForChannel(gateA, gateB);
      for (var centerId in centerPair) {
          final gradientFill = 'url(#${centerId.toLowerCase()}Gradient)';
          final regex = RegExp('(<g id="$centerId"[^>]*>\\s*<path[^>]*?)fill="[^"]*"(?:\\s+fill-opacity="[^"]*")?');
          processed = processed.replaceFirstMapped(regex, (m) => '${m.group(1)}fill="$gradientFill" fill-opacity="1.0"');
      }
    });

    // Gates - Processamento Individual para Máximo Rigor
    for (int i = 1; i <= 64; i++) {
      if (!allActiveGates.contains(i)) continue;
      final isC = data.consciousGates.contains(i);
      final isD = data.designGates.contains(i);
      
      String fill;
      if (isC && isD) {
        // Apenas 20 e 57 usam o gradiente unificado para evitar seams no 57-20
        if ([20, 57].contains(i)) {
          fill = 'url(#gradIntegration)';
        } else {
          // Porta 10, 34 e todas as outras usam o Parser Geométrico para perfeição longitudinal
          final pathMatch = RegExp('id="Gate$i"\\s+(?:d|points)="([^"]+)"').firstMatch(raw);
          final grad = pathMatch != null ? _generateDynamicGradient('Gate$i', pathMatch.group(1)!, '#A44344', 'white') : null;
          if (grad != null) {
            dynamicGradients += grad;
            fill = 'url(#gradGate$i)';
          } else { fill = 'white'; }
        }
      } else {
        fill = isC ? 'white' : '#A44344';
      }

      processed = processed.replaceFirstMapped(RegExp('id="Gate$i"\\s+[^>]*fill="[^"]*"(?:\\s+fill-opacity="[^"]*")?'), 
        (m) => m.group(0)!.replaceFirst(RegExp('fill="[^"]*"'), 'fill="$fill"').replaceFirst(RegExp('fill-opacity="[^"]*"'), 'fill-opacity="1.0"'));
      
      processed = processed.replaceFirstMapped(RegExp('id="GateText$i"[^>]*fill="[^"]*"'), (m) => m.group(0)!.replaceFirst(RegExp('fill="[^"]*"'), 'fill="#343434"'));
      final bgRegex = RegExp('(<g id="GateTextBg$i"[^>]*>\\s*<(?:path|circle)[^>]*?)fill="[^"]*"(?:\\s+fill-opacity="[^"]*")?');
      processed = processed.replaceFirstMapped(bgRegex, (m) => '${m.group(1)}fill="#EFEFEF" fill-opacity="1.0"');
    }

    // Sistema de Integração - Correção Rigorosa de Sobreposição
    final integrationIds = ['GateSpan', 'GateConnect10', 'GateConnect34'];
    for (var id in integrationIds) {
      bool isDefined = false;
      if (id == 'GateSpan') {
        isDefined = data.definedChannels.any((c) => c.contains('57-20') || c.contains('20-57'));
      } else if (id == 'GateConnect10') {
        isDefined = data.definedChannels.any((c) => c.contains('10-'));
      } else if (id == 'GateConnect34') {
        isDefined = data.definedChannels.any((c) => c.contains('34-'));
      }

      if (isDefined) {
        // Conectores pequenos usam o gradiente unificado ou o seu próprio conforme a peça que tocam
        String gradFill = (id == 'GateSpan') ? 'url(#gradIntegration)' : 'white';
        if (id == 'GateConnect10' || id == 'GateConnect34') {
           final pathMatch = RegExp('id="$id"\\s+(?:d|points)="([^"]+)"').firstMatch(raw);
           final grad = pathMatch != null ? _generateDynamicGradient(id, pathMatch.group(1)!, '#A44344', 'white') : null;
           if (grad != null) { dynamicGradients += grad; gradFill = 'url(#grad$id)'; }
        }

        processed = processed.replaceFirstMapped(RegExp('id="$id"[^>]*fill="[^"]*"(?:\\s+fill-opacity="[^"]*")?'),
          (m) => m.group(0)!.replaceFirst(RegExp('fill="[^"]*"'), 'fill="$gradFill"').replaceFirst(RegExp('fill-opacity="[^"]*"'), 'fill-opacity="1.0"'));
      }
    }

    if (processed.contains('<defs>')) {
      processed = processed.replaceFirst('<defs>', '<defs>$dynamicGradients');
    } else {
      processed = processed.replaceFirst('<svg', '<svg><defs>$dynamicGradients</defs>');
    }

    return processed;
  }

  String? _generateDynamicGradient(String id, String d, String colorD, String colorC) {
    final List<Offset> points = [];
    final regExp = RegExp(r'([a-zA-Z])|([-+]?\d*\.?\d+)');
    final matches = regExp.allMatches(d);
    String currentCommand = '';
    Offset currentPos = Offset.zero;
    List<double> params = [];
    
    void flush() {
      if (currentCommand.isEmpty) return;
      final isRel = currentCommand == currentCommand.toLowerCase();
      final cmd = currentCommand.toUpperCase();
      if (cmd == 'M' || cmd == 'L') {
        for (int i = 0; i < params.length; i += 2) {
          if (i + 1 >= params.length) break;
          final p = Offset(params[i], params[i+1]);
          currentPos = isRel ? currentPos + p : p;
          points.add(currentPos);
        }
      } else if (cmd == 'H') {
        for (var v in params) { currentPos = Offset(isRel ? currentPos.dx + v : v, currentPos.dy); points.add(currentPos); }
      } else if (cmd == 'V') {
        for (var v in params) { currentPos = Offset(currentPos.dx, isRel ? currentPos.dy + v : v); points.add(currentPos); }
      }
      params.clear();
    }
    for (final m in matches) {
      if (m.group(1) != null) { flush(); currentCommand = m.group(1)!; }
      else { params.add(double.parse(m.group(2)!)); }
    }
    flush();
    if (points.isEmpty) {
      final parts = d.split(RegExp(r'[ ,]+')).where((s) => s.isNotEmpty).toList();
      for (int i = 0; i < parts.length; i += 2) if (i+1 < parts.length) points.add(Offset(double.parse(parts[i]), double.parse(parts[i+1])));
    }
    if (points.length < 3) return null;
    
    double minLenSq = double.infinity;
    Offset start = points[0], end = points[1];
    for (int i = 0; i < points.length; i++) {
      final p1 = points[i], p2 = points[(i + 1) % points.length];
      final lenSq = (p2.dx - p1.dx) * (p2.dx - p1.dx) + (p2.dy - p1.dy) * (p2.dy - p1.dy);
      if (lenSq > 10.0 && lenSq < minLenSq) { minLenSq = lenSq; start = p1; end = p2; }
    }
    if ((end.dx - start.dx).abs() > (end.dy - start.dy).abs()) {
       if (end.dx < start.dx) { final t = start; start = end; end = t; }
    } else if (end.dy < start.dy) { final t = start; start = end; end = t; }

    return '<linearGradient id="grad$id" gradientUnits="userSpaceOnUse" x1="${start.dx}" y1="${start.dy}" x2="${end.dx}" y2="${end.dy}"><stop offset="50%" stop-color="$colorD" /><stop offset="50%" stop-color="white" /></linearGradient>';
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

  @override
  Widget build(BuildContext context) {
    if (_error != null) return Center(child: Padding(padding: const EdgeInsets.all(20), child: Text('$_error', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 13))));
    if (_svgString == null || _silhouetteSvg == null) return const Center(child: Padding(padding: EdgeInsets.symmetric(vertical: 40), child: CircularProgressIndicator()));
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(alignment: Alignment.center, children: [
        Opacity(opacity: 0.6, child: ColorFiltered(colorFilter: const ColorFilter.mode(Colors.white54, BlendMode.srcIn), child: SvgPicture.string(_silhouetteSvg!, width: constraints.maxWidth, fit: BoxFit.contain))),
        SvgPicture.string(_svgString!, width: constraints.maxWidth, fit: BoxFit.contain),
      ]);
    });
  }
}
