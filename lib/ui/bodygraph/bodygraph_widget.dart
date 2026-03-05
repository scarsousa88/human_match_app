import 'package:flutter/material.dart';

class BodygraphData {
  final Set<String> definedCenters;   // {"Sacral","Throat",...}
  final Set<String> definedChannels;  // {"34-20",...} (normalizados)
  final Set<int> activeGates;         // {34,20,...}

  const BodygraphData({
    required this.definedCenters,
    required this.definedChannels,
    required this.activeGates,
  });
}

class BodygraphWidget extends StatelessWidget {
  final BodygraphData data;
  final double height;

  const BodygraphWidget({super.key, required this.data, this.height = 520});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CustomPaint(
        painter: _BodygraphPainter(data),
      ),
    );
  }
}

class _BodygraphPainter extends CustomPainter {
  final BodygraphData d;
  _BodygraphPainter(this.d);

  @override
  void paint(Canvas canvas, Size size) {
    final definedPaint = Paint()
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..color = Colors.black;

    final undefinedPaint = Paint()
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..color = Colors.black.withValues(alpha: 0.25);

    // Centers (positions normalized)
    final centers = <String, Offset>{
      'Head': Offset(size.width * 0.5, size.height * 0.08),
      'Ajna': Offset(size.width * 0.5, size.height * 0.18),
      'Throat': Offset(size.width * 0.5, size.height * 0.30),
      'G': Offset(size.width * 0.5, size.height * 0.44),
      'Ego': Offset(size.width * 0.72, size.height * 0.44),
      'Spleen': Offset(size.width * 0.28, size.height * 0.54),
      'SolarPlexus': Offset(size.width * 0.72, size.height * 0.54),
      'Sacral': Offset(size.width * 0.5, size.height * 0.62),
      'Root': Offset(size.width * 0.5, size.height * 0.78),
    };

    // Draw centers (simple circles for MVP)
    for (final entry in centers.entries) {
      final name = entry.key;
      final c = entry.value;
      final isDefined = d.definedCenters.contains(name);

      final fill = Paint()
        ..style = PaintingStyle.fill
        ..color = isDefined ? Colors.black : Colors.white;

      final border = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..color = Colors.black.withValues(alpha: isDefined ? 1.0 : 0.4);

      final r = (name == 'G') ? 22.0 : 20.0;
      canvas.drawCircle(c, r, fill);
      canvas.drawCircle(c, r, border);

      // label mini
      final tp = TextPainter(
        text: TextSpan(
          text: _short(name),
          style: TextStyle(
            fontSize: 10,
            color: isDefined ? Colors.white : Colors.black.withValues(alpha: 0.6),
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, c - Offset(tp.width / 2, tp.height / 2));
    }

    // Channels (MVP subset; we'll expand later)
    // Use List<Offset> to avoid record "a/b" issues.
    final channelLines = <String, List<Offset>>{
      '34-20': [centers['Sacral']!, centers['Throat']!],
      '10-57': [centers['G']!, centers['Spleen']!],
      '59-6': [centers['Sacral']!, centers['SolarPlexus']!],
      '3-60': [centers['Sacral']!, centers['Root']!],
      '1-8': [centers['G']!, centers['Throat']!],
    };

    for (final e in channelLines.entries) {
      final id = _normChannelId(e.key);
      final isDefined = d.definedChannels.contains(id);
      final a = e.value[0];
      final b = e.value[1];

      canvas.drawLine(a, b, isDefined ? definedPaint : undefinedPaint);
    }

    // Gate dots (visual-only MVP)
    final gatePaintOn = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black;

    final gatePaintOff = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black.withValues(alpha: 0.15);

    const dotR = 4.0;

    int i = 0;
    for (final c in centers.entries) {
      final base = c.value + const Offset(0, 28);

      for (int k = 0; k < 4; k++) {
        final gateId = 1000 + (i * 4 + k); // placeholder visual
        final on = d.activeGates.contains(gateId);

        canvas.drawCircle(
          base + Offset((k - 1.5) * 12, 0),
          dotR,
          on ? gatePaintOn : gatePaintOff,
        );
      }

      i++;
    }
  }

  String _short(String name) {
    switch (name) {
      case 'SolarPlexus':
        return 'SP';
      default:
        return name.substring(0, 1);
    }
  }

  String _normChannelId(String s) {
    final parts = s.split('-');
    final a = int.parse(parts[0]);
    final b = int.parse(parts[1]);
    return (a < b) ? '$a-$b' : '$b-$a';
  }

  @override
  bool shouldRepaint(covariant _BodygraphPainter oldDelegate) => oldDelegate.d != d;
}