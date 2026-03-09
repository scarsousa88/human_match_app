import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../l10n/app_localizations.dart';
import '../../places/places.dart';
import '../../hd/swiss_ephemeris_service.dart';
import '../../calc/human_design.dart';
import '../../calc/numerology.dart';
import '../../utils/astro_utils.dart';
import '../loading_widget.dart';
import '../widgets/common_ui.dart';

class ProfileInputScreen extends StatefulWidget {
  const ProfileInputScreen({super.key});

  @override
  State<ProfileInputScreen> createState() => _ProfileInputScreenState();
}

class _ProfileInputScreenState extends State<ProfileInputScreen> {
  final nameCtrl = TextEditingController();
  final _birthDateController = TextEditingController();
  final _birthTimeController = TextEditingController();

  DateTime? birthDate;
  TimeOfDay? birthTime;
  bool saving = false;

  List<Place> _places = [];
  String? _country;
  Place? _city;
  String? _tempCityName;

  bool _isNameLocked = false;
  bool _isDateLocked = false;
  bool _showDeleteOption = false;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    await _loadExistingProfile();
    await _loadPlaces();
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    _birthDateController.dispose();
    _birthTimeController.dispose();
    super.dispose();
  }

  Future<void> _loadExistingProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snap = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if (!snap.exists) {
      if (mounted) setState(() => _showDeleteOption = false);
      return;
    }

    final data = snap.data() ?? {};
    if (mounted) {
      setState(() {
        final existingName = (data['name'] ?? '').toString().trim();
        nameCtrl.text = existingName;
        _isNameLocked = existingName.isNotEmpty;
        _showDeleteOption = existingName.isNotEmpty;

        final birthDateStr = (data['birthDateStr'] ?? '').toString().trim();
        if (birthDateStr.isNotEmpty) {
          try {
            birthDate = DateTime.parse(birthDateStr);
            _isDateLocked = true;
          } catch (_) {}
        }
        final birthTimeStr = (data['birthTimeStr'] ?? '').toString().trim();
        if (birthTimeStr.isNotEmpty) {
          try {
            final parts = birthTimeStr.split(':');
            birthTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
          } catch (_) {}
        }

        final placeData = data['place'] as Map?;
        if (placeData != null) {
          _country = placeData['country']?.toString();
          _tempCityName = placeData['city']?.toString();
        }
      });
    }
  }

  Future<void> _loadPlaces() async {
    final list = await PlacesRepository.loadEuropePlaces();
    if (!mounted) return;
    setState(() {
      _places = list;
      final countries = _countries();

      // Se não houver país definido (novo perfil), tenta detetar pela localização/locale do dispositivo
      if (_country == null || !countries.contains(_country)) {
        final detected = _detectUserCountry(countries);
        _country = detected ?? (countries.isNotEmpty ? countries.first : null);
      }

      final cities = _citiesForCountry(_country);

      if (_tempCityName != null) {
        final match = cities.where((p) => p.city == _tempCityName).toList();
        if (match.isNotEmpty) {
          _city = match.first;
        } else {
          _city = cities.isNotEmpty ? cities.first : null;
        }
      } else {
        _city = cities.isNotEmpty ? cities.first : null;
      }
    });
  }

  List<String> _countries() {
    final s = <String>{};
    for (final p in _places) { s.add(p.country); }
    final out = s.toList()..sort();
    return out;
  }

  List<Place> _citiesForCountry(String? country) {
    if (country == null) return [];
    final out = _places.where((p) => p.country == country).toList()..sort((a, b) => a.city.compareTo(b.city));
    return out;
  }

  String? _detectUserCountry(List<String> availableCountries) {
    try {
      final code = WidgetsBinding.instance.platformDispatcher.locale.countryCode?.toUpperCase();
      if (code == null) return null;

      const isoToCountry = {
        'AL': 'Albania', 'AD': 'Andorra', 'AT': 'Austria', 'BY': 'Belarus', 'BE': 'Belgium',
        'BA': 'Bosnia and Herzegovina', 'BG': 'Bulgaria', 'HR': 'Croatia', 'CY': 'Cyprus',
        'CZ': 'Czechia', 'DK': 'Denmark', 'EE': 'Estonia', 'FI': 'Finland', 'FR': 'France',
        'DE': 'Germany', 'GR': 'Greece', 'HU': 'Hungary', 'IS': 'Iceland', 'IE': 'Ireland',
        'IT': 'Italy', 'LV': 'Latvia', 'LI': 'Liechtenstein', 'LT': 'Lithuania', 'LU': 'Luxembourg',
        'MT': 'Malta', 'MD': 'Moldova', 'MC': 'Monaco', 'ME': 'Montenegro', 'NL': 'Netherlands',
        'MK': 'North Macedonia', 'NO': 'Norway', 'PL': 'Poland', 'PT': 'Portugal', 'RO': 'Romania',
        'SM': 'San Marino', 'RS': 'Serbia', 'SK': 'Slovakia', 'SI': 'Slovenia', 'ES': 'Spain',
        'SE': 'Sweden', 'CH': 'Switzerland', 'TR': 'Turkey', 'UA': 'Ukraine', 'GB': 'United Kingdom',
        'VA': 'Vatican City', 'US': 'United States', 'CA': 'Canada', 'MX': 'Mexico', 'BR': 'Brazil',
        'AR': 'Argentina', 'CL': 'Chile', 'JP': 'Japan', 'CN': 'China', 'IN': 'India', 'SG': 'Singapore',
        'AE': 'United Arab Emirates', 'AU': 'Australia', 'NZ': 'New Zealand',
      };

      final name = isoToCountry[code];
      if (name != null && availableCountries.contains(name)) {
        return name;
      }
    } catch (_) {}
    return null;
  }

  void _toast(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  String _p2(int n) => n.toString().padLeft(2, '0');

  String _fmtDate(DateTime? d) {
    if (d == null) return '...';
    return '${_p2(d.day)}/${_p2(d.month)}/${d.year}';
  }

  String _fmtTime(TimeOfDay? t) {
    if (t == null) return '...';
    return '${_p2(t.hour)}:${_p2(t.minute)}';
  }

  Future<void> _pickDateWheel() async {
    final now = DateTime.now();
    final initial = birthDate ?? DateTime(2000, 1, 1);
    DateTime temp = initial;
    final l10n = AppLocalizations.of(context)!;
    final picked = await showModalBottomSheet<DateTime>(
      context: context,
      useSafeArea: true,
      builder: (context) {
        return _CupertinoPickerSheet(
          title: l10n.birthDate,
          onCancel: () => Navigator.pop(context),
          onDone: () => Navigator.pop(context, temp),
          child: SizedBox(
            height: 220,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              dateOrder: DatePickerDateOrder.dmy,
              initialDateTime: initial,
              minimumDate: DateTime(1900, 1, 1),
              maximumDate: now,
              onDateTimeChanged: (d) => temp = DateTime(d.year, d.month, d.day),
            ),
          ),
        );
      },
    );
    if (picked != null) setState(() => birthDate = picked);
  }

  Future<void> _pickTimeWheel() async {
    final initial = birthTime ?? TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      initialEntryMode: TimePickerEntryMode.dialOnly,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => birthTime = picked);
  }

  tz.TZDateTime _toLocalTz(DateTime d, TimeOfDay t, String tzId) {
    final loc = tz.getLocation(tzId);
    return tz.TZDateTime(loc, d.year, d.month, d.day, t.hour, t.minute);
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final uid = user.uid;
    final name = nameCtrl.text.trim();

    if (name.isEmpty || birthDate == null || birthTime == null || _city == null) {
      _toast(l10n.errorFillProfile);
      return;
    }

    final place = _city!;
    final birthLocal = _toLocalTz(birthDate!, birthTime!, place.tzId);
    final birthUtc = birthLocal.toUtc();

    setState(() => saving = true);
    try {
      final swe = SwissEphemerisService();
      await swe.init();
      final asc = swe.calcAscendantLongitudeUtc(birthUtc, lat: place.lat, lon: place.lon);
      final hd = HumanDesignCalculator(swe);
      final hdRes = await hd.calculate(birthUtc: birthUtc, lat: place.lat, lon: place.lon);
      final numRes = computeNumerology(fullName: name, birthDate: birthDate!);

      final hdData = hdRes.toJson();
      final sunLon = findBodyLongitude(hdData, true, 'Sun') ?? 0.0;

      final userRef = FirebaseFirestore.instance.collection('users').doc(uid);

      await userRef.set({
        'name': name,
        'email': user.email,
        'birthPlaceLabel': place.label,
        'place': {
          'country': place.country,
          'city': place.city,
          'label': place.label,
          'lat': place.lat,
          'lon': place.lon,
          'tzId': place.tzId,
        },
        'birthDateStr': '${birthDate!.year}-${_p2(birthDate!.month)}-${_p2(birthDate!.day)}',
        'birthTimeStr': '${_p2(birthTime!.hour)}:${_p2(birthTime!.minute)}',
        'birthUtc': birthUtc.toIso8601String(),
        'birthTzId': place.tzId,
        'astro': {
          'ascendantDeg': asc,
          'ascendantSign': getZodiacSign(context, asc),
          'sunSign': getZodiacSign(context, sunLon),
          'sunDeg': sunLon,
        },
        'humanDesignBase': hdData,
        'numerology': numRes.toJson(),
        'updatedAt': FieldValue.serverTimestamp(),
        'aiGates': {
          'dailyTip': FieldValue.delete(),
          'profile': FieldValue.delete(),
        }
      }, SetOptions(merge: true));

      try {
        await userRef.collection('aiInsights').doc('latest').delete();
        final now = DateTime.now();
        final todayKey = '${now.year}-${_p2(now.month)}-${_p2(now.day)}';
        await userRef.collection('dailyTips').doc(todayKey).delete();
      } catch (_) {}

      if (mounted) {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) _toast(l10n.errorSavingProfile(e.toString()));
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final countries = _countries();
    final cities = _citiesForCountry(_country);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editProfile),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(),
          )
        ],
      ),
      body: Shell(
        child: ListView(
          children: [
            PrimaryCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.baseData, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  Text(l10n.baseDataDesc, style: TextStyle(color: cs.onSurfaceVariant)),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Text(l10n.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              contentPadding: EdgeInsets.zero,
                              content: Stack(
                                children: [
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: IconButton(
                                      icon: const Icon(Icons.close, size: 20),
                                      onPressed: () => Navigator.pop(ctx),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(maxWidth: 260),
                                      child: Text(
                                        l10n.nameNumerologyInfo,
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: Icon(Icons.info_outline, size: 18, color: cs.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nameCtrl,
                    enabled: !_isNameLocked,
                    decoration: const InputDecoration(
                      hintText: "",
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _isDateLocked ? null : _pickDateWheel,
                          icon: const Icon(Icons.cake_outlined),
                          label: Text(birthDate == null ? l10n.selectDate : _fmtDate(birthDate)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _pickTimeWheel,
                          icon: const Icon(Icons.schedule),
                          label: Text(birthTime == null ? l10n.selectTime : _fmtTime(birthTime)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_places.isEmpty)
                    const Center(child: Padding(padding: EdgeInsets.all(12), child: LoadingWidget()))
                  else ...[
                    DropdownButtonFormField<String>(
                      key: ValueKey('country_$_country'),
                      initialValue: _country,
                      decoration: InputDecoration(labelText: l10n.country),
                      items: countries.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (v) {
                        setState(() {
                          _country = v;
                          final newCities = _citiesForCountry(_country);
                          _city = newCities.isNotEmpty ? newCities.first : null;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<Place>(
                      key: ValueKey('city_$_city'),
                      initialValue: _city,
                      decoration: InputDecoration(labelText: l10n.city),
                      items: cities.map((p) => DropdownMenuItem(value: p, child: Text(p.city))).toList(),
                      onChanged: (v) => setState(() => _city = v),
                    ),
                  ],
                  const SizedBox(height: 14),
                  ElevatedButton(
                    onPressed: saving ? null : _save,
                    child: saving ? const LoadingWidget(size: 24) : Text(l10n.saveProfile),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            if (_showDeleteOption)
              Center(
                child: TextButton.icon(
                  onPressed: () async {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user == null) return;
                    
                    final token = await user.getIdToken(true);
                    final locale = Localizations.localeOf(context).languageCode;
                    
                    final uri = Uri.parse('https://humanmatch.app/delete-account')
                        .replace(queryParameters: {
                          'lang': locale,
                          'token': token,
                          'uid': user.uid,
                        });

                    if (await canLaunchUrl(uri)) {
                      await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );

                      // Removido o logout automático daqui.
                      // O logout será agora realizado apenas quando o utilizador confirmar a eliminação na página web,
                      // através do Deep Link 'humanmatch://auth' que configurámos.
                    }
                  },
                  icon: const Icon(Icons.delete_outline, size: 18, color: Colors.grey),
                  label: Text(
                    l10n.deleteAccountData,
                    style: const TextStyle(color: Colors.grey, fontSize: 13, decoration: TextDecoration.underline),
                  ),
                ),
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _CupertinoPickerSheet extends StatelessWidget {
  final String title;
  final VoidCallback onCancel;
  final VoidCallback onDone;
  final Widget child;
  const _CupertinoPickerSheet({required this.title, required this.onCancel, required this.onDone, required this.child});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return Material(
      color: cs.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
            child: Row(
              children: [
                TextButton(onPressed: onCancel, child: Text(l10n.cancel)),
                Expanded(child: Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w900))),
                TextButton(onPressed: onDone, child: Text(l10n.ok)),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: child),
        ],
      ),
    );
  }
}
