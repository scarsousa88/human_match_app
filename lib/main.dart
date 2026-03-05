// lib/main.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'firebase_options.dart';

import 'places/places.dart'; // PlacesRepository + Place
import 'hd/swiss_ephemeris_service.dart';
import 'calc/human_design.dart';
import 'calc/numerology.dart';
import 'hd/human_design_section.dart';

const String kRewardedTestAdUnitId = 'ca-app-pub-3940256099942544/5224354917';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  tz.initializeTimeZones();

  if (!kIsWeb) {
    // Ads only on mobile
    await MobileAds.instance.initialize();
  }

  runApp(const HumanMatchApp());
}

class HumanMatchApp extends StatelessWidget {
  const HumanMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(seedColor: const Color(0xFF6D28D9));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Human Match',
      locale: const Locale('pt', 'PT'),
      supportedLocales: const [
        Locale('pt', 'PT'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: colorScheme.surface,
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.surface,
          foregroundColor: colorScheme.onSurface,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          elevation: 0.8,
          color: colorScheme.surfaceContainerLowest,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: colorScheme.surfaceContainerLowest,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ),
      home: const RootGate(),
    );
  }
}

class RootGate extends StatelessWidget {
  const RootGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snap.data == null) return const AuthScreen();
        return const ProfileGate();
      },
    );
  }
}

class ProfileGate extends StatelessWidget {
  const ProfileGate({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final ref = FirebaseFirestore.instance.collection('users').doc(uid);

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: ref.snapshots(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final data = snap.data?.data() ?? {};
        final hasName = (data['name'] ?? '').toString().trim().isNotEmpty;

        final hasPlace = (data['place'] is Map) && ((data['place']['tzId'] ?? '').toString().isNotEmpty);
        final hasBirthDate = (data['birthDate'] is Map) || (data['birthDateStr'] ?? '').toString().trim().isNotEmpty;
        final hasBirthTime = (data['birthTime'] is Map) || (data['birthTimeStr'] ?? '').toString().trim().isNotEmpty;

        final complete = hasName && hasBirthDate && hasBirthTime && hasPlace;

        if (!complete) return const ProfileInputScreen();
        return const ProfileSummaryScreen();
      },
    );
  }
}

/// ---------------- AUTH ----------------

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  bool loading = false;

  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  void _toast(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  String _authMsg(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Utilizador não encontrado.';
      case 'wrong-password':
        return 'Password incorreta.';
      case 'invalid-email':
        return 'Email inválido.';
      case 'email-already-in-use':
        return 'Este email já está a ser usado.';
      case 'weak-password':
        return 'Password fraca (mín. 6 caracteres).';
      default:
        return e.message ?? e.code;
    }
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text;

    if (email.isEmpty || pass.isEmpty) {
      _toast('Preenche email e password.');
      return;
    }

    setState(() => loading = true);
    try {
      if (isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pass);
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: pass);
        final uid = FirebaseAuth.instance.currentUser!.uid;

        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    } on FirebaseAuthException catch (e) {
      _toast(_authMsg(e));
    } catch (e) {
      _toast('Erro: $e');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _resetPassword() async {
    FocusScope.of(context).unfocus();
    final email = emailCtrl.text.trim();
    if (email.isEmpty) {
      _toast('Escreve o email acima e tenta novamente.');
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _toast('Email enviado. (Vê spam também)');
    } on FirebaseAuthException catch (e) {
      _toast(_authMsg(e));
    } catch (e) {
      _toast('Erro: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: _Shell(
        child: ListView(
          children: [
            const SizedBox(height: 18),
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: cs.primaryContainer,
                  ),
                  child: Icon(Icons.auto_awesome, color: cs.onPrimaryContainer),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Human Match',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Autoconhecimento moderno (Human Design base + numerologia/astrologia via AI).',
              style: TextStyle(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 18),
            _PrimaryCard(
              child: Column(
                children: [
                  TextField(
                    controller: emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: passCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton(
                    onPressed: loading ? null : _submit,
                    child: Text(loading ? 'Aguarda...' : (isLogin ? 'Entrar' : 'Criar conta')),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: loading ? null : _resetPassword,
                    child: const Text('Esqueci-me da password'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: loading
                  ? null
                  : () => setState(() {
                isLogin = !isLogin;
              }),
              child: Text(isLogin ? 'Não tens conta? Criar' : 'Já tens conta? Entrar'),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------- PROFILE INPUT ----------------

class ProfileInputScreen extends StatefulWidget {
  const ProfileInputScreen({super.key});

  @override
  State<ProfileInputScreen> createState() => _ProfileInputScreenState();
}

// ... (mantenha os seus imports iguais)

class _ProfileInputScreenState extends State<ProfileInputScreen> {
  final nameCtrl = TextEditingController();

  final _birthDateController = TextEditingController();
  final _birthTimeController = TextEditingController();
  final _placeController = TextEditingController();

  DateTime? birthDate;
  TimeOfDay? birthTime;
  bool saving = false;

  List<Place> _places = [];
  String? _country;
  Place? _city;

  String? _existingCountry;
  String? _existingCity;

  // Variável para o anúncio
  RewardedAd? _rewardedAd;

  @override
  void initState() {
    super.initState();
    _initData();
    _loadRewardedAd(); // Carrega o anúncio assim que o ecrã abre
  }

  Future<void> _initData() async {
    await _loadExistingProfile();
    await _loadPlaces();
  }

  void _loadRewardedAd() {
    if (kIsWeb) return;
    RewardedAd.load(
      adUnitId: kRewardedTestAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() => _rewardedAd = ad);
        },
        onAdFailedToLoad: (error) {
          _rewardedAd = null;
        },
      ),
    );
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    _birthDateController.dispose();
    _birthTimeController.dispose();
    _placeController.dispose();
    _rewardedAd?.dispose();
    super.dispose();
  }

  Future<void> _loadExistingProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snap = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if (!snap.exists) return;

    final data = snap.data() ?? {};

    setState(() {
      nameCtrl.text = (data['name'] ?? '').toString().trim();

      final birthDateStr = (data['birthDateStr'] ?? '').toString().trim();
      if (birthDateStr.isNotEmpty) {
        try {
          birthDate = DateTime.parse(birthDateStr);
          _birthDateController.text = _fmtDate(birthDate);
        } catch (_) {}
      }

      final birthTimeStr = (data['birthTimeStr'] ?? '').toString().trim();
      if (birthTimeStr.isNotEmpty) {
        try {
          final parts = birthTimeStr.split(':');
          birthTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
          _birthTimeController.text = birthTimeStr;
        } catch (_) {}
      }

      final place = data['place'];
      if (place is Map) {
        _existingCountry = (place['country'] ?? '').toString().trim();
        _existingCity = (place['label'] ?? place['city'] ?? '').toString().trim();
      }
    });
  }

  Future<void> _loadPlaces() async {
    final list = await PlacesRepository.loadEuropePlaces();
    if (!mounted) return;

    setState(() {
      _places = list;
      final countries = _countries();

      // Sincroniza o País
      if (_existingCountry != null && countries.contains(_existingCountry)) {
        _country = _existingCountry;
      } else {
        _country = countries.isNotEmpty ? countries.first : null;
      }

      // Sincroniza a Cidade fazendo o match do Objeto com a String do Firebase
      final cities = _citiesForCountry(_country);
      if (_existingCity != null && cities.isNotEmpty) {
        try {
          _city = cities.firstWhere(
                  (c) => c.label == _existingCity || c.city == _existingCity
          );
        } catch (_) {
          _city = cities.first;
        }
      } else {
        _city = cities.isNotEmpty ? cities.first : null;
      }
    });
  }

  List<String> _countries() {
    final s = <String>{};
    for (final p in _places) s.add(p.country);
    return s.toList()..sort();
  }

  List<Place> _citiesForCountry(String? country) {
    if (country == null) return [];
    return _places.where((p) => p.country == country).toList()
      ..sort((a, b) => a.city.compareTo(b.city));
  }

  void _pickDate() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 300,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 50,
              color: Colors.grey[200],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(child: const Text('Cancelar'), onPressed: () => Navigator.pop(context)),
                  CupertinoButton(
                    child: const Text('OK'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: birthDate ?? DateTime(2000, 1, 1),
                onDateTimeChanged: (val) {
                  setState(() {
                    birthDate = val;
                    _birthDateController.text = _fmtDate(val);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: birthTime ?? const TimeOfDay(hour: 12, minute: 0),
    );
    if (picked != null) {
      setState(() {
        birthTime = picked;
        _birthTimeController.text = '${_p2(picked.hour)}:${_p2(picked.minute)}';
      });
    }
  }

  // Função intermédia para mostrar anúncio antes de salvar
  void _showAdAndSave() {
    if (_rewardedAd == null) {
      _saveProfile();
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _saveProfile();
      },
    );

    _rewardedAd!.show(onUserEarnedReward: (ad, reward) => _saveProfile());
    _rewardedAd = null;
  }

  Future<void> _saveProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _city == null || birthDate == null || birthTime == null) {
      _toast('Preenche todos os campos.');
      return;
    }

    setState(() => saving = true);
    try {
      final birthDateStr = birthDate!.toIso8601String().split('T')[0];
      final birthTimeStr = '${_p2(birthTime!.hour)}:${_p2(birthTime!.minute)}';

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': nameCtrl.text.trim(),
        'birthDateStr': birthDateStr,
        'birthTimeStr': birthTimeStr,
        'place': {
          'country': _city!.country,
          'city': _city!.city,
          'label': _city!.label,
          'lat': _city!.lat,
          'lon': _city!.lon,
        },
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (mounted) Navigator.pop(context);
    } catch (e) {
      _toast('Erro ao guardar: $e');
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  void _toast(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  String _p2(int n) => n.toString().padLeft(2, '0');
  String _fmtDate(DateTime? d) => d == null ? '' : '${_p2(d.day)}/${_p2(d.month)}/${d.year}';

  @override
  Widget build(BuildContext context) {
    final countries = _countries();
    final cities = _citiesForCountry(_country);

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nome')),
          const SizedBox(height: 16),
          TextField(
            controller: _birthDateController,
            readOnly: true,
            onTap: _pickDate,
            decoration: const InputDecoration(labelText: 'Data de Nascimento', suffixIcon: Icon(Icons.calendar_today)),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _birthTimeController,
            readOnly: true,
            onTap: _pickTime,
            decoration: const InputDecoration(labelText: 'Hora de Nascimento', suffixIcon: Icon(Icons.access_time)),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: countries.contains(_country) ? _country : null,
            items: countries.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: (val) {
              setState(() {
                _country = val;
                final newCities = _citiesForCountry(_country);
                _city = newCities.isNotEmpty ? newCities.first : null;
              });
            },
            decoration: const InputDecoration(labelText: 'País'),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<Place>(
            value: cities.contains(_city) ? _city : null,
            items: cities.map((c) => DropdownMenuItem(value: c, child: Text(c.label))).toList(),
            onChanged: (val) => setState(() => _city = val),
            decoration: const InputDecoration(labelText: 'Cidade'),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: saving ? null : _showAdAndSave,
            child: Text(saving ? 'A guardar...' : 'Guardar Alterações'),
          ),
        ],
      ),
    );
  }
}

class _CupertinoPickerSheet extends StatelessWidget {
  final String title;
  final VoidCallback onCancel;
  final VoidCallback onDone;
  final Widget child;

  const _CupertinoPickerSheet({
    required this.title,
    required this.onCancel,
    required this.onDone,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
            child: Row(
              children: [
                TextButton(onPressed: onCancel, child: const Text('Cancelar')),
                Expanded(
                  child: Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w900)),
                ),
                TextButton(onPressed: onDone, child: const Text('OK')),
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

/// ---------------- SUMMARY (daily tip auto + AI behind ad) ----------------


class ProfileSummaryScreen extends StatefulWidget {
  const ProfileSummaryScreen({super.key});

  @override
  State<ProfileSummaryScreen> createState() => _ProfileSummaryScreenState();
}

class _ProfileSummaryScreenState extends State<ProfileSummaryScreen> {
  bool _didAutoDaily = false;

  void _toast(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  String _p2(int n) => n.toString().padLeft(2, '0');

  String _todayKeyLocal() {
    final now = DateTime.now();
    return '${now.year}-${_p2(now.month)}-${_p2(now.day)}';
  }

  String _weekKeyLocal() {
    // ISO-ish week key: YYYY-Www
    final now = DateTime.now();
    final week = _weekNumber(now);
    return '${now.year}-W${week.toString().padLeft(2, '0')}';
  }

  int _weekNumber(DateTime d) {
    return _weekNumberManual(DateTime(d.year, d.month, d.day));
  }

  int _weekNumberManual(DateTime d) {
    final start = DateTime(d.year, 1, 1);
    final dayOfYear = d.difference(start).inDays + 1;
    // Monday=1..Sunday=7
    final weekday = d.weekday;
    // week number where week starts Monday
    return ((dayOfYear - weekday + 10) / 7).floor();
  }

  Future<void> _autoGenerateDailyTip() async {
    if (_didAutoDaily) return;
    _didAutoDaily = true;

    try {
      final callable = FirebaseFunctions.instance.httpsCallable('generateDailyTipIfNeeded');
      await callable.call({'dateKey': _todayKeyLocal()});
    } catch (_) {
      // silent for MVP
    }
  }

  Future<void> _showRewardedAdAndRun(Future<void> Function() onReward) async {
    if (kIsWeb) {
      _toast('Anúncios não suportados no Web.');
      await onReward();
      return;
    }

    // Mostra um loading ou aviso enquanto carrega
    _toast('A carregar anúncio...');

    await RewardedAd.load(
      adUnitId: kRewardedTestAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) => ad.dispose(),
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              onReward(); // Se falhar a mostrar, executa a lógica para não prender o user
            },
          );

          ad.show(onUserEarnedReward: (ad, reward) {
            onReward(); // Executa a lógica (AI ou Dicas) após o anúncio
          });
        },
        onAdFailedToLoad: (error) {
          debugPrint('Falha ao carregar anúncio: $error');
          onReward(); // Se o anúncio falhar o carregamento, deixa o utilizador avançar
        },
      ),
    );
  }

  Future<void> _runAiInsightsBehindRewardedAd() async {
    await _showRewardedAdAndRun(() async {
      final callable = FirebaseFunctions.instance.httpsCallable('generateAiInsights');await callable.call({
        'version': 2,
        'includeWeekPlan': false,
      });
      _toast('Insights atualizados ✅');
    });
  }

  Future<void> _generateTipsBehindRewardedAd() async {
    await _showRewardedAdAndRun(() async {
      try {
        final daily = FirebaseFunctions.instance.httpsCallable('generateDailyTipIfNeeded');
        await daily.call({'dateKey': _todayKeyLocal()});
      } catch (_) {}

      try {
        final weekly = FirebaseFunctions.instance.httpsCallable('generateWeeklyTipIfNeeded');
        await weekly.call({'weekKey': _weekKeyLocal()});
      } catch (_) {}

      _toast('Dicas atualizadas ✅');
    });
  }

  String _firstName(String fullName) {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    return parts.isEmpty ? '' : parts.first;
  }

  DateTime? _birthDateFromStr(String s) {
    // expects YYYY-MM-DD
    final parts = s.trim().split('-');
    if (parts.length != 3) return null;
    final y = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final d = int.tryParse(parts[2]);
    if (y == null || m == null || d == null) return null;
    return DateTime(y, m, d);
  }

  String _zodiacFromLon(double lon) {
    const signs = [
      'Áries',
      'Touro',
      'Gémeos',
      'Caranguejo',
      'Leão',
      'Virgem',
      'Balança',
      'Escorpião',
      'Sagitário',
      'Capricórnio',
      'Aquário',
      'Peixes',
    ];
    final idx = (lon ~/ 30).clamp(0, 11);
    return signs[idx];
  }

  double? _findActivationLon(Map<String, dynamic>? hdBase, bool conscious, String body) {
    if (hdBase == null) return null;
    final acts = (hdBase['activations'] ?? []) as List;
    for (final a in acts) {
      final m = (a as Map).cast<String, dynamic>();
      if ((m['conscious'] == conscious) && (m['body'] == body)) {
        final lon = m['lon'];
        if (lon is num) return lon.toDouble();
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

    final dailyRef = userRef.collection('dailyTips').doc(_todayKeyLocal());
    final weeklyRef = userRef.collection('weeklyTips').doc(_weekKeyLocal());
    final insightsRef = userRef.collection('aiInsights').doc('latest');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumo'),
        actions: [
          IconButton(
            tooltip: 'Editar',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileInputScreen())),
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            tooltip: 'Logout',
            onPressed: () async => FirebaseAuth.instance.signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _Shell(
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: userRef.snapshots(),
          builder: (context, userSnap) {
            if (userSnap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final u = userSnap.data?.data() ?? {};
            final fullName = (u['name'] ?? '').toString().trim();
            final first = _firstName(fullName);

            final birthDateStr = (u['birthDateStr'] ?? '').toString();
            final birthTimeStr = (u['birthTimeStr'] ?? '').toString();
            final birthDateText = [birthDateStr, birthTimeStr].where((s) => s.trim().isNotEmpty).join(' • ');

            final place = (u['place'] as Map?)?.cast<String, dynamic>() ?? {};
            final placeLabel = (place['label'] ?? '').toString();

            final hdBase = (u['humanDesignBase'] as Map?)?.cast<String, dynamic>();
            final astroBase = (u['astroBase'] as Map?)?.cast<String, dynamic>() ?? {};
            final ascDeg = (astroBase['ascendantDeg'] as num?)?.toDouble();

            // Astrology (from stored data, no extra ephemeris calls):
            final sunLonP = _findActivationLon(hdBase, true, 'Sun');
            final sunSign = sunLonP == null ? '—' : _zodiacFromLon(sunLonP);
            final ascSign = ascDeg == null ? '—' : _zodiacFromLon(ascDeg);

            // Numerology (computed locally):
            final birthDate = _birthDateFromStr(birthDateStr);
            final numerology = (fullName.isNotEmpty && birthDate != null)
                ? computeNumerology(fullName: fullName, birthDate: birthDate)
                : null;

            _autoGenerateDailyTip();

            return ListView(
              children: [
                // -------------------
                // Resumo
                // -------------------
                _PrimaryCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            child: Text(
                              first.isEmpty ? '?' : first[0].toUpperCase(),
                              style: const TextStyle(fontWeight: FontWeight.w900),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              first.isEmpty ? 'Olá!' : 'Olá $first',
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (birthDateText.isNotEmpty)
                        _InfoRow(icon: Icons.cake_outlined, label: 'Data de nascimento', value: birthDateText),
                      if (birthDateText.isNotEmpty) const SizedBox(height: 8),
                      if (placeLabel.isNotEmpty)
                        _InfoRow(icon: Icons.place_outlined, label: 'Local de nascimento', value: placeLabel),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // -------------------
// Human Design
// -------------------
                _PrimaryCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Human Design', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 12),
                      if (hdBase == null)
                        const Text('Ainda a calcular Human Design...')
                      else
                        HumanDesignSection(hd: hdBase),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // -------------------
                // Astrologia
                // -------------------
                _PrimaryCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Astrologia', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 12),
                      _KeyValueRow(icon: Icons.wb_sunny_outlined, label: 'Signo', value: sunSign),
                      const SizedBox(height: 8),
                      _KeyValueRow(icon: Icons.north_outlined, label: 'Ascendente', value: ascSign),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // -------------------
                // Numerologia
                // -------------------
                _PrimaryCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Numerologia', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 12),
                      if (numerology == null)
                        const Text('—')
                      else ...[
                        _KeyValueRow(icon: Icons.tag_outlined, label: 'Caminho de Vida', value: numerology.lifePath.toString()),
                        const SizedBox(height: 8),
                        _KeyValueRow(icon: Icons.tag_outlined, label: 'Expressão', value: numerology.expression.toString()),
                        const SizedBox(height: 8),
                        _KeyValueRow(icon: Icons.tag_outlined, label: 'Alma', value: numerology.soul.toString()),
                        const SizedBox(height: 8),
                        _KeyValueRow(icon: Icons.tag_outlined, label: 'Personalidade', value: numerology.personality.toString()),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // -------------------
                // Insights (AI) — sem plano semanal
                // -------------------
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: insightsRef.snapshots(),
                  builder: (context, insSnap) {
                    if (insSnap.connectionState == ConnectionState.waiting) {
                      return const _PrimaryCard(child: Center(child: CircularProgressIndicator()));
                    }

                    if (!insSnap.hasData || !insSnap.data!.exists) {
                      return _PrimaryCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Insights', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                            const SizedBox(height: 10),
                            const Text('Ainda não tens insights.'),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: _runAiInsightsBehindRewardedAd,
                              child: const Text('Gerar Insights (Anúncio)'),
                            ),
                          ],
                        ),
                      );
                    }

                    final ins = insSnap.data!.data() ?? {};
                    final summary = (ins['summary'] ?? '').toString();
                    final strengths = (ins['strengths'] ?? []) as List;
                    final challenges = (ins['challenges'] ?? []) as List;

                    return _PrimaryCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Expanded(
                                child: Text('Insights', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                              ),
                              TextButton.icon(
                                onPressed: _runAiInsightsBehindRewardedAd,
                                icon: const Icon(Icons.auto_awesome_outlined),
                                label: const Text('Atualizar'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          if (summary.isNotEmpty) Text(summary) else const Text('—'),
                          const SizedBox(height: 12),
                          const Text('Forças', style: TextStyle(fontWeight: FontWeight.w900)),
                          _bullets(strengths),
                          const SizedBox(height: 10),
                          const Text('Atenções', style: TextStyle(fontWeight: FontWeight.w900)),
                          _bullets(challenges),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),

                // -------------------
                // Dica diária + semanal (com botão e anúncio antes)
                // -------------------
                _PrimaryCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Dica diária e semanal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: _generateTipsBehindRewardedAd,
                        icon: const Icon(Icons.auto_awesome_outlined),
                        label: const Text('Obter dica (Anúncio)'),
                      ),
                      const SizedBox(height: 14),

                      const Text('Dica de hoje', style: TextStyle(fontWeight: FontWeight.w900)),
                      const SizedBox(height: 8),
                      StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        stream: dailyRef.snapshots(),
                        builder: (context, tipSnap) {
                          if (tipSnap.connectionState == ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          if (!tipSnap.hasData || !tipSnap.data!.exists) {
                            return const Text('A preparar a dica de hoje...');
                          }
                          final tip = tipSnap.data!.data() ?? {};
                          final text = (tip['text'] ?? '').toString();
                          return Text(text.isEmpty ? '—' : text);
                        },
                      ),

                      const SizedBox(height: 14),

                      const Text('Dica da semana', style: TextStyle(fontWeight: FontWeight.w900)),
                      const SizedBox(height: 8),
                      StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        stream: weeklyRef.snapshots(),
                        builder: (context, wSnap) {
                          if (wSnap.connectionState == ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          if (!wSnap.hasData || !wSnap.data!.exists) {
                            return const Text('Ainda não tens dica da semana.');
                          }
                          final tip = wSnap.data!.data() ?? {};
                          final text = (tip['text'] ?? '').toString();
                          return Text(text.isEmpty ? '—' : text);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _bullets(List items) {
    if (items.isEmpty) return const Text('—');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((t) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('• '),
              Expanded(child: Text(t.toString())),
            ],
          ),
        );
      }).toList(),
    );
  }
}


/// ---------- UI helpers ----------

class _Shell extends StatelessWidget {
  final Widget child;
  const _Shell({required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _PrimaryCard extends StatelessWidget {
  final Widget child;
  const _PrimaryCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(child: Padding(padding: const EdgeInsets.all(16), child: child));
  }
}


class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 2),
              Text(value, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}

class _KeyValueRow extends StatelessWidget {
  const _KeyValueRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
          textAlign: TextAlign.right,
        ),
      ],
    );
  }
}
