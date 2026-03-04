import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'firebase_options.dart';

import 'places/places.dart';
import 'hd/swiss_ephemeris_service.dart';
import 'calc/human_design.dart';
import 'calc/numerology.dart';
import 'calc/astrology.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  tzdata.initializeTimeZones();
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

        final complete =
            (data['name'] ?? '').toString().trim().isNotEmpty &&
                (data['birthDateStr'] ?? '').toString().trim().isNotEmpty &&
                (data['birthTimeStr'] ?? '').toString().trim().isNotEmpty &&
                (data['country'] ?? '').toString().trim().isNotEmpty &&
                (data['city'] ?? '').toString().trim().isNotEmpty &&
                (data['tzId'] ?? '').toString().trim().isNotEmpty &&
                data['lat'] is num &&
                data['lon'] is num;

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
                  child: Text('Human Match', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text('CONHECE-TE BEM, RELACIONA-TE MELHOR!', style: TextStyle(color: cs.onSurfaceVariant)),
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
              onPressed: loading ? null : () => setState(() => isLogin = !isLogin),
              child: Text(isLogin ? 'Não tens conta? Criar' : 'Já tens conta? Entrar'),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------- PROFILE INPUT (carrega JSON assets) ----------------

class ProfileInputScreen extends StatefulWidget {
  const ProfileInputScreen({super.key});

  @override
  State<ProfileInputScreen> createState() => _ProfileInputScreenState();
}

class _ProfileInputScreenState extends State<ProfileInputScreen> {
  final nameCtrl = TextEditingController();

  DateTime? birthDate;
  TimeOfDay? birthTime;

  String? country;
  Place? selectedPlace;

  bool saving = false;

  @override
  void dispose() {
    nameCtrl.dispose();
    super.dispose();
  }

  void _toast(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  String _p2(int n) => n.toString().padLeft(2, '0');

  String _fmtDate(DateTime? d) => d == null ? 'Selecionar data' : '${_p2(d.day)}/${_p2(d.month)}/${d.year}';
  String _fmtTime(TimeOfDay? t) => t == null ? 'Selecionar hora' : '${_p2(t.hour)}:${_p2(t.minute)}';

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
    final initial = birthTime ?? const TimeOfDay(hour: 12, minute: 0);
    final now = DateTime.now();
    DateTime temp = DateTime(now.year, now.month, now.day, initial.hour, initial.minute);

    final picked = await showModalBottomSheet<TimeOfDay>(
      context: context,
      useSafeArea: true,
      builder: (context) {
        return _CupertinoPickerSheet(
          title: 'Hora de nascimento',
          onCancel: () => Navigator.pop(context),
          onDone: () => Navigator.pop(context, TimeOfDay(hour: temp.hour, minute: temp.minute)),
          child: SizedBox(
            height: 220,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              use24hFormat: true,
              initialDateTime: temp,
              minuteInterval: 1,
              onDateTimeChanged: (d) => temp = d,
            ),
          ),
        );
      },
    );

    if (picked != null) setState(() => birthTime = picked);
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) _toast('Sessão terminada.');
    } catch (e) {
      if (mounted) _toast('Erro no logout: $e');
    }
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();

    final uid = FirebaseAuth.instance.currentUser!.uid;
    final name = nameCtrl.text.trim();

    if (name.isEmpty || birthDate == null || birthTime == null || country == null || selectedPlace == null) {
      _toast('Preenche nome, data, hora, país e cidade.');
      return;
    }

    setState(() => saving = true);
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': name,
        'birthDateStr': '${birthDate!.year}-${_p2(birthDate!.month)}-${_p2(birthDate!.day)}',
        'birthTimeStr': '${_p2(birthTime!.hour)}:${_p2(birthTime!.minute)}',
        'country': selectedPlace!.country,
        'city': selectedPlace!.city,
        'birthLocation': selectedPlace!.label,
        'lat': selectedPlace!.lat,
        'lon': selectedPlace!.lon,
        'tzId': selectedPlace!.tzId,
        'computed': FieldValue.delete(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProfileSummaryScreen()));
      }
    } catch (e) {
      _toast('Erro ao guardar: $e');
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar perfil'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _Shell(
        child: FutureBuilder<List<Place>>(
          future: PlacesRepository.loadEuropePlaces(),
          builder: (context, snap) {
            if (!snap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final places = snap.data!;
            final countries = places.map((p) => p.country).toSet().toList()..sort();

            final cityOptions = (country == null)
                ? <Place>[]
                : places.where((p) => p.country == country).toList()
              ..sort((a, b) => a.city.compareTo(b.city));

            return ListView(
              children: [
                _PrimaryCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Dados base', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 8),
                      Text(
                        'Seleciona país/cidade para obter latitude/longitude/timezone automaticamente.',
                        style: TextStyle(color: cs.onSurfaceVariant),
                      ),
                      const SizedBox(height: 14),
                      TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nome completo')),
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

                      DropdownButtonFormField<String>(
                        initialValue: country,
                        items: countries.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                        onChanged: (v) {
                          setState(() {
                            country = v;
                            selectedPlace = null;
                          });
                        },
                        decoration: const InputDecoration(labelText: 'País'),
                      ),

                      const SizedBox(height: 12),

                      DropdownButtonFormField<Place>(
                        initialValue: selectedPlace,
                        items: cityOptions
                            .map((p) => DropdownMenuItem(
                          value: p,
                          child: Text(p.city),
                        ))
                            .toList(),
                        onChanged: (v) => setState(() => selectedPlace = v),
                        decoration: const InputDecoration(labelText: 'Cidade'),
                      ),

                      const SizedBox(height: 12),
                      if (selectedPlace != null)
                        Text(
                          'TZ: ${selectedPlace!.tzId} • lat: ${selectedPlace!.lat} • lon: ${selectedPlace!.lon}',
                          style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
                        ),

                      const SizedBox(height: 14),
                      ElevatedButton(
                        onPressed: saving ? null : _save,
                        child: Text(saving ? 'A guardar...' : 'Guardar perfil'),
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

/// ---------------- SUMMARY ----------------

class ProfileSummaryScreen extends StatefulWidget {
  const ProfileSummaryScreen({super.key});

  @override
  State<ProfileSummaryScreen> createState() => _ProfileSummaryScreenState();
}

class _ProfileSummaryScreenState extends State<ProfileSummaryScreen> {
  bool _runningCompute = false;

  void _toast(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  String _p2(int n) => n.toString().padLeft(2, '0');

  DateTime _parseBirthLocal(String dateStr, String timeStr) {
    final d = dateStr.split('-').map((e) => int.parse(e)).toList();
    final t = timeStr.split(':').map((e) => int.parse(e)).toList();
    return DateTime(d[0], d[1], d[2], t[0], t[1]);
  }

  Future<void> _computeAndStore({
    required DocumentReference<Map<String, dynamic>> userRef,
    required Map<String, dynamic> u,
  }) async {
    if (_runningCompute) return;

    setState(() => _runningCompute = true);
    try {
      final name = (u['name'] ?? '').toString().trim();
      final dateStr = (u['birthDateStr'] ?? '').toString().trim();
      final timeStr = (u['birthTimeStr'] ?? '').toString().trim();
      final tzId = (u['tzId'] ?? '').toString().trim();
      final lat = double.parse(u['lat'].toString());
      final lon = double.parse(u['lon'].toString());


      final birthLocal = _parseBirthLocal(dateStr, timeStr);

      final loc = tz.getLocation(tzId);
      final birthTz = tz.TZDateTime.from(birthLocal, loc);
      final birthUtc = birthTz.toUtc();

      final swe = SwissEphemerisService();
      await swe.init();

      final hd = await computeHumanDesignBase(swe: swe, birthUtc: birthUtc);
      final num = computeNumerology(fullName: name, birthDate: birthLocal);
      final astro = await computeAstrology(swe: swe, birthUtc: birthUtc, lat: lat, lon: lon);

      await userRef.set({
        'computed': {
          'humanDesign': hd.toJson(),
          'numerology': num.toJson(),
          'astrology': astro.toJson(),
          'computedAt': FieldValue.serverTimestamp(),
        }
      }, SetOptions(merge: true));
    } catch (e) {
      _toast('Falha a calcular: $e');
    } finally {
      if (mounted) setState(() => _runningCompute = false);
    }
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) _toast('Sessão terminada.');
    } catch (e) {
      if (mounted) _toast('Erro no logout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

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
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _Shell(
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: userRef.snapshots(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final u = snap.data?.data() ?? {};

            final name = (u['name'] ?? '').toString().trim();
            final locLabel = (u['birthLocation'] ?? '').toString();
            final dateStr = (u['birthDateStr'] ?? '').toString();
            final timeStr = (u['birthTimeStr'] ?? '').toString();

            String prettyDate = '';
            if (dateStr.contains('-') && dateStr.length >= 10) {
              final parts = dateStr.split('-');
              prettyDate = "${parts[2]}/${parts[1]}/${parts[0]}";
            }

            final computed = (u['computed'] as Map<String, dynamic>?) ?? {};
            final hd = (computed['humanDesign'] as Map<String, dynamic>?) ?? {};
            final astro = (computed['astrology'] as Map<String, dynamic>?) ?? {};
            final num = (computed['numerology'] as Map<String, dynamic>?) ?? {};

            if (computed.isEmpty && !_runningCompute) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _computeAndStore(userRef: userRef, u: u);
              });
            }

            return ListView(
              children: [
                _PrimaryCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name.isEmpty ? 'Olá!' : 'Olá, $name!',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          if (prettyDate.isNotEmpty) _InfoChip(icon: Icons.cake_outlined, text: prettyDate),
                          if (timeStr.isNotEmpty) _InfoChip(icon: Icons.schedule, text: timeStr),
                          if (locLabel.isNotEmpty) _InfoChip(icon: Icons.place_outlined, text: locLabel),
                        ],
                      ),
                      if (_runningCompute) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: const [
                            SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
                            SizedBox(width: 10),
                            Text('A calcular o teu perfil...'),
                          ],
                        )
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                _PrimaryCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Human Design', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 10),
                      Text('Type: ${(hd['type'] ?? '—')}'),
                      Text('Profile: ${(hd['profile'] ?? '—')}'),
                      const SizedBox(height: 10),
                      Text('Personality Sun: ${(hd['personalitySun'] ?? '—')}'),
                      Text('Personality Earth: ${(hd['personalityEarth'] ?? '—')}'),
                      const SizedBox(height: 10),
                      Text('Design Sun: ${(hd['designSun'] ?? '—')}'),
                      Text('Design Earth: ${(hd['designEarth'] ?? '—')}'),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                _PrimaryCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Astrologia', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 10),
                      Text('Sol: ${(astro['sunSign'] ?? '—')}'),
                      Text('Ascendente: ${(astro['ascSign'] ?? '—')}'),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                _PrimaryCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Numerologia', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 10),
                      Text('Life Path: ${(num['lifePath'] ?? '—')}'),
                      Text('Expression: ${(num['expression'] ?? '—')}'),
                      Text('Soul: ${(num['soul'] ?? '—')}'),
                      Text('Personality: ${(num['personality'] ?? '—')}'),
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

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}