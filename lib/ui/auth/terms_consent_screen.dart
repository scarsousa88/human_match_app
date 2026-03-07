import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../l10n/app_localizations.dart';
import '../../app_terms.dart';
import '../loading_widget.dart';
import '../widgets/common_ui.dart';

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
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.termsTitle)),
      body: Shell(
        child: Column(
          children: [
            Expanded(
              child: PrimaryCard(
                child: SingleChildScrollView(
                  child: Text(l10n.termsContent, style: TextStyle(color: cs.onSurface)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: loading ? null : _accept,
              child: loading ? const LoadingWidget(size: 24) : Text(l10n.acceptAndContinue),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => FirebaseAuth.instance.signOut(),
              child: Text(l10n.cancelAndExit),
            ),
          ],
        ),
      ),
    );
  }
}
