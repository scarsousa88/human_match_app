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
import 'ai_actions.dart';
import 'app_terms.dart';

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

/// Helpers globais para Astrologia
String getZodiacSign(double lon) {
  const signs = [
    'Carneiro', 'Touro', 'Gémeos', 'Caranguejo', 'Leão', 'Virgem',
    'Balança', 'Escorpião', 'Sagitário', 'Capricórnio', 'Aquário', 'Peixes'
  ];
  return signs[(lon ~/ 30).clamp(0, 11)];
}

double? findBodyLongitude(Map<String, dynamic>? hdBase, bool conscious, String body) {
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
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const AuthScreen();

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final data = snap.data?.data() ?? {};
        
        // 1. Verificar termos
        final acceptedVersion = data['acceptedTermsVersion']?.toString();
        if (acceptedVersion != AppTerms.currentVersion) {
          return const TermsConsentScreen();
        }

        // 2. Verificar perfil
        final hasName = (data['name'] ?? '').toString().trim().isNotEmpty;
        final hasPlace = (data['place'] is Map) && (data['place']['tzId'] != null);
        final hasBirthDate = (data['birthDateStr'] ?? '').toString().trim().isNotEmpty;
        final hasBirthTime = (data['birthTimeStr'] ?? '').toString().trim().isNotEmpty;

        final complete = hasName && hasBirthDate && hasBirthTime && hasPlace;

        if (!complete) return const ProfileInputScreen();

        return const MainNavigationScreen();
      },
    );
  }
}

/// ---------------- TERMS CONSENT (FOR EXISTING USERS) ----------------

class TermsConsentScreen extends StatefulWidget {
  const TermsConsentScreen({super.key});

  @override
  State<TermsConsentScreen> createState() => _TermsConsentScreenState();
}

class _TermsConsentScreenState extends State<TermsConsentScreen> {
  bool loading = false;

  Future<void> _accept() async {
    setState(() => loading = true);
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'acceptTerms': true,
        'acceptedTermsVersion': AppTerms.currentVersion,
        'termsAcceptedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao aceitar: $e')));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Termos e Condições')),
      body: _Shell(
        child: Column(
          children: [
            Expanded(
              child: _PrimaryCard(
                child: SingleChildScrollView(
                  child: Text(AppTerms.termsText, style: TextStyle(color: cs.onSurface)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: loading ? null : _accept,
              child: Text(loading ? 'A processar...' : 'Aceito e desejo continuar'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => FirebaseAuth.instance.signOut(),
              child: const Text('Cancelar e sair'),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------- NAVIGATION (TABS) ----------------

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ProfileSummaryScreen(),
    const _PlaceholderTab(text: 'Explora perfis próximos e compatíveis\n(Brevemente)'),
    const _PlaceholderTab(text: 'Compara perfis manualmente\n(Brevemente)'),
  ];

  final List<String> _titles = ['O meu Perfil', 'Comunidade', 'Comparar'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: () async => FirebaseAuth.instance.signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.colorScheme.onSurfaceVariant,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w900),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Comunidade',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.compare_arrows),
            activeIcon: Icon(Icons.compare_arrows),
            label: 'Comparar',
          ),
        ],
      ),
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  final String text;
  const _PlaceholderTab({required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/icon/icon.png', width: 300), // Logótipo da App em tamanho grande
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
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
  bool acceptTerms = false;

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
      case 'user-not-found': return 'Utilizador não encontrado.';
      case 'wrong-password': return 'Password incorreta.';
      case 'invalid-email': return 'Email inválido.';
      case 'email-already-in-use': return 'Este email já está a ser usado.';
      case 'weak-password': return 'Password fraca (mín. 6 caracteres).';
      default: return e.message ?? e.code;
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

    if (!isLogin && !acceptTerms) {
      _toast('Precisas de aceitar os Termos e Condições.');
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
          'acceptTerms': true,
          'acceptedTermsVersion': AppTerms.currentVersion,
          'termsAcceptedAt': FieldValue.serverTimestamp(),
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

  void _showTerms() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Termos e Condições'),
        content: const SingleChildScrollView(
          child: Text(AppTerms.termsText),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fechar')),
        ],
      ),
    );
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
              'Conhece-te bem, relaciona-te melhor!',
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
                  if (!isLogin) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Checkbox(
                          value: acceptTerms,
                          onChanged: (v) => setState(() => acceptTerms = v ?? false),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: _showTerms,
                            child: Text(
                              'Aceito os Termos e Condições',
                              style: TextStyle(
                                fontSize: 13,
                                color: cs.primary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
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
              onPressed: loading ? null : () => setState(() => isLogin = !isLogin),
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

  String? _existingCountry;
  String? _existingCity;

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
      if (_existingCountry != null && countries.contains(_existingCountry)) {
        _country = _existingCountry;
      } else {
        _country = countries.isNotEmpty ? countries.first : null;
      }
      final cities = _citiesForCountry(_country);
      if (_existingCity != null && cities.isNotEmpty) {
        _city = cities.firstWhere(
          (c) => c.label == _existingCity || c.city == _existingCity,
          orElse: () => cities.first,
        );
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

  void _toast(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  String _p2(int n) => n.toString().padLeft(2, '0');

  String _fmtDate(DateTime? d) {
    if (d == null) return 'Selecionar data';
    return '${_p2(d.day)}/${_p2(d.month)}/${d.year}';
  }

  String _fmtTime(TimeOfDay? t) {
    if (t == null) return 'Selecionar hora';
    return '${_p2(t.hour)}:${_p2(t.minute)}';
  }

  Future<void> _pickDateWheel() async {
    final now = DateTime.now();
    final initial = birthDate ?? DateTime(2000, 1, 1);
    DateTime temp = initial;
    final picked = await showModalBottomSheet<DateTime>(
      context: context,
      useSafeArea: true,
      builder: (context) {
        return _CupertinoPickerSheet(
          title: 'Data de nascimento',
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
    FocusScope.of(context).unfocus();
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final name = nameCtrl.text.trim();

    if (name.isEmpty || birthDate == null || birthTime == null || _city == null) {
      _toast('Preenche nome, data, hora e cidade.');
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

      // Cálculo de signos para salvar
      final hdData = hdRes.toJson();
      final sunLon = findBodyLongitude(hdData, true, 'Sun') ?? 0.0;

      final userRef = FirebaseFirestore.instance.collection('users').doc(uid);

      await userRef.set({
        'name': name,
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

        // Estrutura Astro Única
        'astro': {
          'ascendantDeg': asc,
          'ascendantSign': getZodiacSign(asc),
          'sunSign': getZodiacSign(sunLon),
          'sunDeg': sunLon,
        },

        'humanDesignBase': hdData,
        'numerology': numRes.toJson(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // 1) Limpar insights de perfil
      await userRef.collection('aiInsights').doc('latest').delete();
      
      // 2) Limpar dica diária de HOJE (usando data atual, não de nascimento)
      final now = DateTime.now();
      final todayKey = '${now.year}-${_p2(now.month)}-${_p2(now.day)}';
      await userRef.collection('dailyTips').doc(todayKey).delete();

      // 3) Limpar permissões de anúncios (gates) para forçar novo contexto
      await userRef.update({
        'aiGates.dailyTip': FieldValue.delete(),
        'aiGates.profile': FieldValue.delete(),
      });

      if (mounted) {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      _toast('Erro ao guardar/calcular: $e');
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final countries = _countries();
    final cities = _citiesForCountry(_country);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar perfil'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: () async => FirebaseAuth.instance.signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _Shell(
        child: ListView(
          children: [
            _PrimaryCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Dados base', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  Text('Isto permite calcular Human Design + ascendente.', style: TextStyle(color: cs.onSurfaceVariant)),
                  const SizedBox(height: 14),
                  TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nome')),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _pickDateWheel,
                          icon: const Icon(Icons.cake_outlined),
                          label: Text(_fmtDate(birthDate)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _pickTimeWheel,
                          icon: const Icon(Icons.schedule),
                          label: Text(_fmtTime(birthTime)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_places.isEmpty)
                    const Center(child: Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator()))
                  else ...[
                    DropdownButtonFormField<String>(
                      key: ValueKey('country_$_country'), // Resolve warnings e mantém sincronização
                      initialValue: _country, 
                      decoration: const InputDecoration(labelText: 'País'),
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
                      key: ValueKey('city_$_city'), // Resolve warnings e mantém sincronização
                      initialValue: _city, 
                      decoration: const InputDecoration(labelText: 'Cidade'),
                      items: cities.map((p) => DropdownMenuItem(value: p, child: Text(p.city))).toList(),
                      onChanged: (v) => setState(() => _city = v),
                    ),
                  ],
                  const SizedBox(height: 14),
                  ElevatedButton(
                    onPressed: saving ? null : _save,
                    child: Text(saving ? 'A guardar...' : 'Guardar perfil'),
                  ),
                ],
              ),
            ),
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
                Expanded(child: Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w900))),
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

/// ---------------- SUMMARY ----------------

class ProfileSummaryScreen extends StatefulWidget {
  const ProfileSummaryScreen({super.key});
  @override
  State<ProfileSummaryScreen> createState() => _ProfileSummaryScreenState();
}

class _ProfileSummaryScreenState extends State<ProfileSummaryScreen> {
  bool _didAutoDaily = false;
  late AiActions _ai;

  @override
  void initState() {
    super.initState();
    _ai = AiActions(context: context);
  }

  Future<void> _autoGenerateDailyTip() async {
    if (_didAutoDaily) return;
    _didAutoDaily = true;
    try {
      final callable = FirebaseFunctions.instance.httpsCallable('generateDailyTipIfNeeded');
      await callable.call({'dateKey': _ai.todayKeyLocal()});
    } catch (_) {}
  }

  String _firstName(String fullName) {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    return parts.isEmpty ? '' : parts.first;
  }

  DateTime? _birthDateFromStr(String s) {
    final parts = s.trim().split('-');
    if (parts.length != 3) return null;
    final y = int.tryParse(parts[0]), m = int.tryParse(parts[1]), d = int.tryParse(parts[2]);
    if (y == null || m == null || d == null) return null;
    return DateTime(y, m, d);
  }

  String _formatDateStr(String? key) {
    if (key == null || !key.contains('-')) return 'Dica Diária';
    final parts = key.split('-');
    if (parts.length != 3) return key;
    return '${parts[2]}-${parts[1]}-${parts[0]}';
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final insightsRef = userRef.collection('aiInsights').doc('latest');
    final lastTipQuery = userRef.collection('dailyTips').orderBy('dateKey', descending: true).limit(1);

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: userRef.snapshots(),
      builder: (context, userSnap) {
        if (userSnap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

        final u = userSnap.data?.data() ?? {};
        final fullName = (u['name'] ?? '').toString().trim();
        final first = _firstName(fullName);
        final birthDateStr = (u['birthDateStr'] ?? '').toString();
        final birthTimeStr = (u['birthTimeStr'] ?? '').toString();
        final birthDateText = [birthDateStr, birthTimeStr].where((s) => s.trim().isNotEmpty).join(' • ');
        final placeLabel = (u['birthPlaceLabel'] ?? (u['place'] as Map?)?['label'] ?? '').toString();

        final hdBase = (u['humanDesignBase'] as Map?)?.cast<String, dynamic>();
        final astro = (u['astro'] as Map?)?.cast<String, dynamic>() ?? {};

        final sunSign = astro['sunSign'] ?? (findBodyLongitude(hdBase, true, 'Sun') != null ? getZodiacSign(findBodyLongitude(hdBase, true, 'Sun')!) : '—');
        final ascSign = astro['ascendantSign'] ?? (astro['ascendantDeg'] != null ? getZodiacSign((astro['ascendantDeg'] as num).toDouble()) : '—');

        final storedNum = u['numerology'] as Map?;
        final numerology = storedNum != null ? NumerologyResult(lifePath: storedNum['lifePath'], expression: storedNum['expression'], soul: storedNum['soul'], personality: storedNum['personality']) : (fullName.isNotEmpty && _birthDateFromStr(birthDateStr) != null) ? computeNumerology(fullName: fullName, birthDate: _birthDateFromStr(birthDateStr)!) : null;

        _autoGenerateDailyTip();

        return ListView(
          children: [
            _PrimaryCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.transparent,
                        child: Image(image: AssetImage('assets/icon/card.png')),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          first.isEmpty ? 'Olá!' : 'Olá $first',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Editar Perfil',
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileInputScreen())),
                        icon: const Icon(Icons.edit_outlined),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (birthDateText.isNotEmpty) _InfoRow(icon: Icons.cake_outlined, label: 'Data de nascimento', value: birthDateText),
                  if (birthDateText.isNotEmpty) const SizedBox(height: 8),
                  if (placeLabel.isNotEmpty) _InfoRow(icon: Icons.place_outlined, label: 'Local de nascimento', value: placeLabel),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _PrimaryCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Human Design', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 12),
                  if (hdBase == null) const Text('Ainda a calcular Human Design...') else HumanDesignSection(hd: hdBase),
                ],
              ),
            ),
            const SizedBox(height: 12),
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
            _PrimaryCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Numerologia', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 12),
                  if (numerology == null) const Text('—') else ...[
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
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: insightsRef.snapshots(),
              builder: (context, insSnap) {
                if (insSnap.connectionState == ConnectionState.waiting) return const _PrimaryCard(child: Center(child: CircularProgressIndicator()));
                if (!insSnap.hasData || !insSnap.data!.exists) {
                  return _PrimaryCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Insights de Perfil', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 10),
                        const Text('Ainda não tens insights gerados.'),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => _ai.runInsightsBehindRewardedAd(),
                          child: const Text('Gerar Insights (Anúncio)'),
                        ),
                      ],
                    ),
                  );
                }
                final ins = insSnap.data!.data() ?? {};
                return _PrimaryCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(child: Text('Insights de Perfil', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900))),
                          TextButton.icon(
                            onPressed: () => _ai.runInsightsBehindRewardedAd(),
                            icon: const Icon(Icons.auto_awesome_outlined),
                            label: const Text('Atualizar'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(ins['summary']?.toString() ?? '—'),
                      const SizedBox(height: 12),
                      const Text('Pilares do teu Perfil', style: TextStyle(fontWeight: FontWeight.w900)),
                      _bullets(ins['insights'] ?? []),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: lastTipQuery.snapshots(),
              builder: (context, tipsSnap) {
                if (tipsSnap.connectionState == ConnectionState.waiting) return const _PrimaryCard(child: Center(child: CircularProgressIndicator()));
                
                final tips = tipsSnap.data?.docs ?? [];
                final hasTodayTip = tips.isNotEmpty && tips.first.id == _ai.todayKeyLocal();
                final lastTipDoc = tips.isNotEmpty ? tips.first : null;
                final lastTipData = lastTipDoc?.data() ?? {};
                
                final formattedDate = lastTipDoc != null 
                    ? _formatDateStr(lastTipDoc.id) 
                    : _formatDateStr(_ai.todayKeyLocal());

                return _PrimaryCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Dica Diária', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 10),
                      Text(formattedDate, style: const TextStyle(fontWeight: FontWeight.w900)),
                      const SizedBox(height: 8),
                      
                      if (!hasTodayTip) ...[
                        ElevatedButton.icon(
                          onPressed: () => _ai.runTipsBehindRewardedAd(),
                          icon: const Icon(Icons.auto_awesome_outlined),
                          label: const Text('Obter dica diária (Anúncio)'),
                        ),
                        const SizedBox(height: 14),
                      ],

                      if (lastTipDoc != null)
                        Text(lastTipData['text']?.toString() ?? '—')
                      else
                        const Text('Vê o anúncio para obteres a tua dica diária'),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _bullets(List items) {
    if (items.isEmpty) return const Text('—');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((t) => Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('• '), Expanded(child: Text(t.toString()))]))).toList(),
    );
  }
}

class _Shell extends StatelessWidget {
  final Widget child;
  const _Shell({required this.child});
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 560), child: Padding(padding: const EdgeInsets.all(16), child: child))));
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
  const _InfoRow({required this.icon, required this.label, required this.value});
  final IconData icon; final String label; final String value;
  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, size: 18), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: Theme.of(context).textTheme.bodySmall), const SizedBox(height: 2), Text(value, style: Theme.of(context).textTheme.bodyMedium)]))]);
  }
}

class _KeyValueRow extends StatelessWidget {
  const _KeyValueRow({required this.icon, required this.label, required this.value});
  final IconData icon; final String label; final String value;
  @override
  Widget build(BuildContext context) {
    return Row(children: [Icon(icon, size: 18), const SizedBox(width: 10), Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium)), const SizedBox(width: 12), Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900), textAlign: TextAlign.right)]);
  }
}
