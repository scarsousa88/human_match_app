import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

bool _tzReady = false;

Future<void> initTimezones() async {
  if (_tzReady) return;
  tz.initializeTimeZones();
  _tzReady = true;
}

DateTime localBirthToUtc({
  required String tzId,
  required int year,
  required int month,
  required int day,
  required int hour,
  required int minute,
}) {
  final loc = tz.getLocation(tzId);
  final local = tz.TZDateTime(loc, year, month, day, hour, minute);
  return local.toUtc();
}