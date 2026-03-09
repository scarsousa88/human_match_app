import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../main.dart';
import '../../app_terms.dart';
import '../../l10n/app_localizations.dart';
import '../loading_widget.dart';
import '../auth/auth_screen.dart';
import '../auth/terms_consent_screen.dart';
import '../auth/verify_email_screen.dart';
import '../profile/profile_input_screen.dart';
import 'main_navigation.dart';

class RootGate extends StatefulWidget {
  const RootGate({super.key});

  @override
  State<RootGate> createState() => _RootGateState();
}

class _RootGateState extends State<RootGate> with WidgetsBindingObserver {
  late Stream<User?> _authStream;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _authStream = FirebaseAuth.instance.userChanges();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        user.reload().catchError((e) {
          if (mounted) HumanMatchApp.restartApp(context);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return StreamBuilder<User?>(
      stream: _authStream,
      builder: (context, snap) {
        if (snap.hasError) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text(l10n.authError(snap.error.toString()), textAlign: TextAlign.center),
                    TextButton(onPressed: () => HumanMatchApp.restartApp(context), child: Text(l10n.tryAgain)),
                  ],
                ),
              ),
            ),
          );
        }

        if (snap.connectionState == ConnectionState.waiting && !snap.hasData) {
          return const Scaffold(body: LoadingWidget());
        }
        
        final user = snap.data;
        if (user == null) return const AuthScreen();
        
        if (!user.emailVerified) {
          return const VerifyEmailScreen();
        }
        
        return const ProfileGate();
      },
    );
  }
}

class ProfileGate extends StatefulWidget {
  const ProfileGate({super.key});

  @override
  State<ProfileGate> createState() => _ProfileGateState();
}

class _ProfileGateState extends State<ProfileGate> {
  Stream<DocumentSnapshot<Map<String, dynamic>>>? _profileStream;
  String? _lastUid;

  void _initStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.uid != _lastUid) {
      _lastUid = user.uid;
      _profileStream = FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    _initStream();

    if (_profileStream == null) return const AuthScreen();

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _profileStream,
      builder: (context, snap) {
        if (snap.hasError) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud_off, color: Colors.orange, size: 48),
                    const SizedBox(height: 16),
                    Text(l10n.loadProfileError(snap.error.toString()), textAlign: TextAlign.center),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => FirebaseAuth.instance.signOut(),
                      child: Text(l10n.logoutAndTryAgain),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (snap.connectionState == ConnectionState.waiting && !snap.hasData) {
          return const Scaffold(body: LoadingWidget());
        }

        final data = snap.data?.data() ?? {};

        final acceptedVersion = data['acceptedTermsVersion']?.toString();
        if (acceptedVersion != AppTerms.currentVersion) {
          return const TermsConsentScreen();
        }

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
