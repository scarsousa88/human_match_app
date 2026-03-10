// lib/calc/hd_constants.dart

/// Gate order around the zodiac starting at the Human Design mandala offset.
/// This is the standard 64-gate sequence used in HD calculations.
const List<int> hdGateOrder = [
  25, 17, 21, 51, 42, 3, 27, 24, 2, 23, 8, 20, 16, 35, 45, 12,
  15, 52, 39, 53, 62, 56, 31, 33, 7, 4, 29, 59, 40, 64, 47, 6,
  46, 18, 48, 57, 32, 50, 28, 44, 1, 43, 14, 34, 9, 5, 26, 11,
  10, 58, 38, 54, 61, 60, 41, 19, 13, 49, 30, 55, 37, 63, 22, 36,
];

/// Each gate spans 360/64 degrees.
const double hdGateSizeDeg = 360.0 / 64.0; // 5.625 degrees

/// Mandala offset: the first gate in the sequence (Gate 25) starts at ~28°15' Pisces.
/// Pisces starts at 330°, so 330 + 28.25 = 358.25°.
const double hdStartDeg = 358.25; // 28°15' Pisces in tropical longitude

enum HdCenter {
  head,
  ajna,
  throat,
  g,
  ego,
  spleen,
  solarPlexus,
  sacral,
  root,
}

enum HdType {
  generator,
  manifestingGenerator,
  manifestor,
  projector,
  reflector,
}

/// All 36 channels: gateA-gateB and the two centers they connect.
class HdChannel {
  final int a;
  final int b;
  final HdCenter c1;
  final HdCenter c2;

  const HdChannel(this.a, this.b, this.c1, this.c2);
}

/// Channel list (pairings are standard).
const List<HdChannel> hdChannels = [
  // G <-> Throat
  HdChannel(1, 8, HdCenter.g, HdCenter.throat),
  HdChannel(7, 31, HdCenter.g, HdCenter.throat),
  HdChannel(13, 33, HdCenter.g, HdCenter.throat),
  HdChannel(10, 20, HdCenter.g, HdCenter.throat),

  // Ajna <-> Throat
  HdChannel(43, 23, HdCenter.ajna, HdCenter.throat),
  HdChannel(17, 62, HdCenter.ajna, HdCenter.throat),
  HdChannel(11, 56, HdCenter.ajna, HdCenter.throat),

  // Head <-> Ajna
  HdChannel(64, 47, HdCenter.head, HdCenter.ajna),
  HdChannel(61, 24, HdCenter.head, HdCenter.ajna),
  HdChannel(63, 4, HdCenter.head, HdCenter.ajna),

  // Throat <-> Ego
  HdChannel(21, 45, HdCenter.ego, HdCenter.throat),

  // Throat <-> Solar Plexus
  HdChannel(35, 36, HdCenter.throat, HdCenter.solarPlexus),
  HdChannel(12, 22, HdCenter.throat, HdCenter.solarPlexus),

  // Throat <-> Sacral
  HdChannel(34, 20, HdCenter.sacral, HdCenter.throat),

  // Throat <-> Spleen
  HdChannel(57, 20, HdCenter.spleen, HdCenter.throat),

  // Throat <-> G (already above) + Throat <-> Root (manifesting channels)
  HdChannel(16, 48, HdCenter.throat, HdCenter.spleen),
  HdChannel(52, 9, HdCenter.root, HdCenter.sacral),
  HdChannel(53, 42, HdCenter.root, HdCenter.sacral),
  HdChannel(60, 3, HdCenter.root, HdCenter.sacral),

  // G <-> Sacral
  HdChannel(2, 14, HdCenter.g, HdCenter.sacral),
  HdChannel(5, 15, HdCenter.g, HdCenter.sacral),
  HdChannel(29, 46, HdCenter.sacral, HdCenter.g),

  // Sacral <-> Spleen
  HdChannel(27, 50, HdCenter.sacral, HdCenter.spleen),
  HdChannel(34, 57, HdCenter.sacral, HdCenter.spleen),

  // Sacral <-> Solar Plexus
  HdChannel(6, 59, HdCenter.solarPlexus, HdCenter.sacral),

  // Root <-> Solar Plexus
  HdChannel(19, 49, HdCenter.root, HdCenter.solarPlexus),
  HdChannel(39, 55, HdCenter.root, HdCenter.solarPlexus),
  HdChannel(41, 30, HdCenter.root, HdCenter.solarPlexus),

  // Root <-> Spleen
  HdChannel(54, 32, HdCenter.root, HdCenter.spleen),
  HdChannel(58, 18, HdCenter.root, HdCenter.spleen),
  HdChannel(38, 28, HdCenter.root, HdCenter.spleen),

  // Ego <-> G
  HdChannel(25, 51, HdCenter.g, HdCenter.ego),

  // Ego <-> Spleen
  HdChannel(44, 26, HdCenter.spleen, HdCenter.ego),

  // Ego <-> Solar Plexus
  HdChannel(37, 40, HdCenter.solarPlexus, HdCenter.ego),
];
