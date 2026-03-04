class SwissEphFfi {
  void setEphePath(String path) {
    throw UnsupportedError("Swiss Ephemeris não suportado no Web.");
  }

  double? calcLonUt({required double jdUt, required int planetId}) {
    throw UnsupportedError("Swiss Ephemeris não suportado no Web.");
  }

  double? calcAscUt({
    required double jdUt,
    required double lat,
    required double lon,
  }) {
    throw UnsupportedError("Swiss Ephemeris não suportado no Web.");
  }
}

SwissEphFfi loadSwissEph() {
  throw UnsupportedError("Swiss Ephemeris não suportado no Web.");
}