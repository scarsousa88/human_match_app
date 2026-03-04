double julianDayUtc(DateTime utc) {
  final y = utc.year;
  final m = utc.month;
  final d = utc.day +
      (utc.hour + (utc.minute + utc.second / 60.0) / 60.0) / 24.0;

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
      d +
      b -
      1524.5;
}