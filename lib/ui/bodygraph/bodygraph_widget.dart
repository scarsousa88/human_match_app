import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui';

class BodygraphData {
  final Set<String> definedCenters;
  final Set<String> definedChannels;
  final Set<int> consciousGates;
  final Set<int> designGates;

  const BodygraphData({
    required this.definedCenters,
    required this.definedChannels,
    required this.consciousGates,
    required this.designGates,
  });
}

class BodygraphWidget extends StatelessWidget {
  final BodygraphData data;
  final double height;

  const BodygraphWidget({super.key, required this.data, this.height = 540});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: height,
          width: constraints.maxWidth,
          decoration: BoxDecoration(
            color: const Color(0xFF0F0B1E),
            borderRadius: BorderRadius.circular(32),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: CustomPaint(
              painter: _BodygraphPainter(data),
              size: Size(constraints.maxWidth, height),
            ),
          ),
        );
      },
    );
  }
}

class _BodygraphPainter extends CustomPainter {
  final BodygraphData d;
  _BodygraphPainter(this.d);

  static const Color designRed = Color(0xFFE53935);
  static const Color personalityWhite = Colors.white;
  static const Color shapeBg = Color(0xFF1A1726);

  @override
  void paint(Canvas canvas, Size size) {
    final centers = _getCenterPositions(size);
    final gatePos = _calculateGatePositions(centers);

    _drawSilhouette(canvas, size);
    _drawChannels(canvas, gatePos);
    _drawCenters(canvas, centers, gatePos);
  }

  void _drawSilhouette(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.01)..style = PaintingStyle.fill;
    final path = Path();
    final w = size.width; final h = size.height;
    path.moveTo(w * 0.5, h * 0.02);
    path.cubicTo(w * 0.4, h * 0.02, w * 0.38, h * 0.12, w * 0.4, h * 0.16);
    path.lineTo(w * 0.25, h * 0.25);
    path.quadraticBezierTo(w * 0.1, h * 0.35, w * 0.12, h * 0.5);
    path.quadraticBezierTo(w * 0.1, h * 0.8, w * 0.2, h * 0.98);
    path.lineTo(w * 0.8, h * 0.98);
    path.quadraticBezierTo(w * 0.9, h * 0.8, w * 0.88, h * 0.5);
    path.quadraticBezierTo(w * 0.9, h * 0.35, w * 0.8, h * 0.25);
    path.lineTo(w * 0.6, h * 0.16);
    path.cubicTo(w * 0.62, h * 0.12, w * 0.6, h * 0.02, w * 0.5, h * 0.02);
    canvas.drawPath(path, paint);
  }

  void _drawChannels(Canvas canvas, Map<int, Offset> gatePos) {
    final connections = _getChannelDefinitions();
    for (var conn in connections) {
      final gates = conn['id'].split('-').map(int.parse).toList();
      final p1 = gatePos[gates[0]];
      final p2 = gatePos[gates[1]];
      if (p1 == null || p2 == null) continue;
      
      final isG1 = d.consciousGates.contains(gates[0]) || d.designGates.contains(gates[0]);
      final isG2 = d.consciousGates.contains(gates[1]) || d.designGates.contains(gates[1]);
      
      if (!isG1 && !isG2) continue;

      final curve = conn['curve'] ?? 0.0;
      _drawChannelPath(canvas, p1, p2, gates[0], gates[1], curve);
    }
  }

  void _drawChannelPath(Canvas canvas, Offset start, Offset end, int g1, int g2, double curveFactor) {
    final path = Path()..moveTo(start.dx, start.dy);
    if (curveFactor == 0) {
      path.lineTo(end.dx, end.dy);
    } else {
      final midX = (start.dx + end.dx) / 2 + (end.dy - start.dy) * curveFactor;
      final midY = (start.dy + end.dy) / 2 + (start.dx - end.dx) * curveFactor;
      path.quadraticBezierTo(midX, midY, end.dx, end.dy);
    }

    final List<PathMetric> metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) return;
    final metric = metrics.first;
    final halfLen = metric.length / 2;

    _drawSegment(canvas, metric, 0, halfLen, g1);
    _drawSegment(canvas, metric, halfLen, metric.length, g2);
  }

  void _drawSegment(Canvas canvas, PathMetric metric, double s, double e, int gate) {
    final isC = d.consciousGates.contains(gate);
    final isD = d.designGates.contains(gate);
    if (!isC && !isD) return;

    final seg = metric.extractPath(s, e);
    final paint = Paint()..style = PaintingStyle.stroke..strokeCap = StrokeCap.butt;

    if (isC && isD) {
      canvas.drawPath(seg, paint..color = personalityWhite..strokeWidth = 4);
      canvas.drawPath(seg, paint..color = designRed..strokeWidth = 1.5);
    } else if (isC) {
      canvas.drawPath(seg, paint..color = personalityWhite..strokeWidth = 4);
    } else if (isD) {
      canvas.drawPath(seg, paint..color = designRed..strokeWidth = 4);
    }
  }

  void _drawCenters(Canvas canvas, Map<String, Offset> centers, Map<int, Offset> gatePos) {
    final Map<String, List<int>> centerGates = _getCenterGateMapping();

    centers.forEach((name, p) {
      final isDef = d.definedCenters.any((c) => c.toLowerCase().replaceAll(" ", "") == name.toLowerCase().replaceAll(" ", ""));
      _drawCenterShape(canvas, p, name, isDef);
      
      for (int gate in centerGates[name] ?? []) {
        final pos = gatePos[gate];
        if (pos != null) {
          final active = d.consciousGates.contains(gate) || d.designGates.contains(gate);
          if (active) _drawGatePoint(canvas, pos, gate);
        }
      }
    });
  }

  void _drawCenterShape(Canvas canvas, Offset c, String name, bool isDef) {
    final fill = Paint()..color = isDef ? _getCenterColor(name) : shapeBg..style = PaintingStyle.fill;
    final border = Paint()..color = Colors.white.withOpacity(isDef ? 0.4 : 0.05)..style = PaintingStyle.stroke..strokeWidth = 1;
    final path = Path(); double s = 18;

    if (name == 'Head') _addTriangle(path, c, s, up: true);
    else if (name == 'Ajna') _addTriangle(path, c, s, up: false);
    else if (['Throat', 'Sacral', 'Root'].contains(name)) path.addRect(Rect.fromCenter(center: c, width: s * 2.4, height: s * 2.4));
    else if (name == 'G') _addDiamond(path, c, s * 1.5);
    else if (name == 'Ego') _addTriangle(path, c + const Offset(10, 8), s * 0.8, up: true);
    else if (['Spleen', 'Solar Plexus'].contains(name)) _addTriangle(path, c, s * 1.4, up: true);

    canvas.drawPath(path, fill);
    canvas.drawPath(path, border);
  }

  void _drawGatePoint(Canvas canvas, Offset p, int gate) {
    canvas.drawCircle(p, 6.5, Paint()..color = Colors.black);
    final tp = TextPainter(
      text: TextSpan(
        text: gate.toString(),
        style: const TextStyle(fontSize: 7.2, color: Colors.white, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, p - Offset(tp.width / 2, tp.height / 2));
  }

  Map<int, Offset> _calculateGatePositions(Map<String, Offset> centers) {
    final Map<int, Offset> pos = {};
    const double s = 18;
    void add(int g, Offset c, double dx, double dy) => pos[g] = c + Offset(dx * s, dy * s);

    final h = centers['Head']!; add(64, h, -0.4, 0.4); add(61, h, 0, 0.4); add(63, h, 0.4, 0.4);
    final a = centers['Ajna']!; add(47, a, -0.5, -0.4); add(24, a, 0, -0.4); add(4, a, 0.5, -0.4); add(17, a, -0.4, 0.6); add(43, a, 0, 0.6); add(11, a, 0.4, 0.6);
    final t = centers['Throat']!; add(62, t, -0.6, -1.2); add(23, t, 0, -1.2); add(56, t, 0.6, -1.2); add(16, t, -1.1, -0.5); add(20, t, -1.1, 0); add(31, t, -1.1, 0.5); add(35, t, 1.1, -0.5); add(12, t, 1.1, 0); add(45, t, 1.1, 0.5); add(8, t, -0.3, 1.2); add(33, t, 0.3, 1.2);
    final g = centers['G']!; add(1, g, 0, -1.2); add(13, g, 0.8, -0.8); add(25, g, 1.2, 0); add(46, g, 0.8, 0.8); add(2, g, 0, 1.2); add(15, g, -0.8, 0.8); add(10, g, -1.2, 0); add(7, g, -0.8, -0.8);
    final eg = centers['Ego']!; add(21, eg, -0.3, -0.5); add(51, eg, -0.8, 0.5); add(26, eg, 0.2, 1.0); add(40, eg, 0.6, 0.6);
    final sc = centers['Sacral']!; add(5, sc, -0.6, -1.2); add(14, sc, 0, -1.2); add(29, sc, 0.6, -1.2); add(34, sc, -1.1, 0); add(27, sc, 1.1, 0); add(59, sc, 1.1, 0.6); add(42, sc, -0.6, 1.2); add(3, sc, 0, 1.2); add(9, sc, 0.6, 1.2);
    final r = centers['Root']!; add(53, r, -0.6, -1.2); add(60, r, 0, -1.2); add(52, r, 0.6, -1.2); add(54, r, -1.1, -0.5); add(38, r, -1.1, 0); add(58, r, -1.1, 0.5); add(19, r, 1.1, -0.5); add(39, r, 1.1, 0); add(41, r, 1.1, 0.5);
    final sp = centers['Spleen']!; add(48, sp, -0.2, -0.5); add(57, sp, -0.8, 0.2); add(44, sp, -0.5, 1.2); add(50, sp, 0.5, 0.5); add(32, sp, 0.2, 1.2); add(28, sp, -1.0, 0.8); add(18, sp, -0.8, 1.4);
    final sx = centers['Solar Plexus']!; add(36, sx, 0.2, -0.5); add(22, sx, 0.8, 0.2); add(37, sx, 0.5, 1.2); add(6, sx, -0.5, 0.5); add(49, sx, -0.2, 1.2); add(55, sx, 1.0, 0.8); add(30, sx, 0.8, 1.4);
    return pos;
  }

  Map<String, List<int>> _getCenterGateMapping() => {
    'Head': [64, 61, 63], 'Ajna': [47, 24, 4, 17, 43, 11], 'Throat': [62, 23, 56, 16, 20, 31, 8, 33, 45, 12, 35],
    'G': [1, 7, 13, 10, 25, 15, 46, 2], 'Ego': [21, 51, 26, 40], 'Spleen': [48, 57, 44, 50, 32, 28, 18],
    'Solar Plexus': [36, 22, 37, 6, 49, 55, 30], 'Sacral': [5, 14, 29, 34, 27, 59, 42, 3, 9], 'Root': [53, 60, 52, 19, 39, 41, 54, 38, 58],
  };

  List<Map<String, dynamic>> _getChannelDefinitions() => [
    {'id': '64-47'}, {'id': '61-24'}, {'id': '63-4'}, {'id': '17-62'}, {'id': '43-23'}, {'id': '11-56'},
    {'id': '16-48', 'curve': -0.4}, {'id': '20-57', 'curve': -0.2}, {'id': '20-10'}, {'id': '31-7', 'curve': -0.1}, {'id': '8-1'}, {'id': '33-13', 'curve': 0.1},
    {'id': '45-21', 'curve': 0.2}, {'id': '35-36', 'curve': 0.3}, {'id': '12-22', 'curve': 0.15}, {'id': '10-34'}, {'id': '10-57'}, {'id': '25-51'},
    {'id': '15-5', 'curve': -0.1}, {'id': '2-14'}, {'id': '46-29', 'curve': 0.1}, {'id': '34-20'}, {'id': '59-6'}, {'id': '3-60'}, {'id': '54-32', 'curve': -0.15},
    {'id': '38-28', 'curve': -0.3}, {'id': '58-18', 'curve': -0.45}, {'id': '19-49', 'curve': 0.15}, {'id': '39-55', 'curve': 0.3}, {'id': '41-30', 'curve': 0.45}
  ];

  Color _getCenterColor(String name) {
    if (name == 'G' || name == 'Head') return const Color(0xFFFFF176);
    if (name == 'Ajna') return const Color(0xFF4CAF50);
    if (name == 'Sacral' || name == 'Ego') return const Color(0xFFE53935);
    return const Color(0xFFBCAAA4);
  }

  void _addTriangle(Path path, Offset c, double s, {required bool up}) {
    if (up) { path.moveTo(c.dx, c.dy - s); path.lineTo(c.dx + s * 1.4, c.dy + s); path.lineTo(c.dx - s * 1.4, c.dy + s); }
    else { path.moveTo(c.dx, c.dy + s); path.lineTo(c.dx + s * 1.4, c.dy - s); path.lineTo(c.dx - s * 1.4, c.dy - s); }
    path.close();
  }

  void _addDiamond(Path path, Offset c, double s) { path.moveTo(c.dx, c.dy - s); path.lineTo(c.dx + s, c.dy); path.lineTo(c.dx, c.dy + s); path.lineTo(c.dx - s, c.dy); path.close(); }

  Map<String, Offset> _getCenterPositions(Size size) {
    final w = size.width; final h = size.height;
    return {
      'Head': Offset(w * 0.5, h * 0.08), 'Ajna': Offset(w * 0.5, h * 0.18), 'Throat': Offset(w * 0.5, h * 0.30),
      'G': Offset(w * 0.5, h * 0.44), 'Ego': Offset(w * 0.70, h * 0.48), 'Spleen': Offset(w * 0.28, h * 0.58),
      'Solar Plexus': Offset(w * 0.72, h * 0.58), 'Sacral': Offset(w * 0.5, h * 0.66), 'Root': Offset(w * 0.5, h * 0.82),
    };
  }

  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}