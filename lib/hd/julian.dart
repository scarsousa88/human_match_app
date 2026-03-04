// lib/hd/julian.dart
//
// Minimal Julian Day helpers (UTC).
//
// - julianDayUtc(DateTime) -> JD (UT)
// - utcFromJulianDayUtc(JD) -> DateTime.utc
//
// Note: Human Design only needs UT and ecliptic longitudes; this is sufficient.

double julianDayUtc(DateTime utc) {
  final u = utc.toUtc();

  final y = u.year;
  final m = u.month;
  final dayFrac = u.day +
      (u.hour +
          (u.minute +
              (u.second + (u.millisecond + u.microsecond / 1000.0) / 1000.0) / 60.0) /
              60.0) /
          24.0;

  int yy = y;
  int mm = m;
  if (mm <= 2) {
    yy -= 1;
    mm += 12;
  }

  final a = (yy / 100).floor();
  final b = 2 - a + (a / 4).floor();

  return (365.25 * (yy + 4716)).floorToDouble() +
      (30.6001 * (mm + 1)).floorToDouble() +
      dayFrac +
      b -
      1524.5;
}

DateTime utcFromJulianDayUtc(double jdUt) {
  // Algorithm adapted from standard astronomical conversions.
  // jdUt is Julian Day in UT.
  final jd = jdUt + 0.5;
  final z = jd.floor();
  final f = jd - z;

  int a = z;
  if (z >= 2299161) {
    final alpha = ((z - 1867216.25) / 36524.25).floor();
    a = z + 1 + alpha - (alpha / 4).floor();
  }

  final b = a + 1524;
  final c = ((b - 122.1) / 365.25).floor();
  final d = (365.25 * c).floor();
  final e = ((b - d) / 30.6001).floor();

  final day = b - d - (30.6001 * e).floor() + f;

  int month = (e < 14) ? e - 1 : e - 13;
  int year = (month > 2) ? c - 4716 : c - 4715;

  final dayInt = day.floor();
  final dayFraction = day - dayInt;

  final totalSeconds = dayFraction * 86400.0;
  final hour = (totalSeconds / 3600).floor();
  final minute = ((totalSeconds - hour * 3600) / 60).floor();
  final second = (totalSeconds - hour * 3600 - minute * 60);

  final secInt = second.floor();
  final millis = ((second - secInt) * 1000).round();

  return DateTime.utc(year, month, dayInt, hour, minute, secInt, millis);
}