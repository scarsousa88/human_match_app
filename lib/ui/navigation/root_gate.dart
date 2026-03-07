import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../app_terms.dart';
import '../loading_widget.dart';
import '../auth/auth_screen.dart';
import '../auth/terms_consent_screen.dart';
import '../profile/profile_input_screen.dart';
import 'main_navigation.dart';

class RootGate extends StatelessWidget {
  const RootGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: LoadingWidget());
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
