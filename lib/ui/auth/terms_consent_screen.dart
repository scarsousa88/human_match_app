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
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.termsTitle),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
        ),
        child: Shell(
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Header title only
              Center(
                child: Text(
                  l10n.appTitle,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: cs.primary,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: PrimaryCard(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      AppTerms.termsText, 
                      style: TextStyle(
                        color: cs.onSurface,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: loading ? null : _accept,
                child: loading ? const LoadingWidget(size: 24) : Text(l10n.acceptAndContinue),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => FirebaseAuth.instance.signOut(),
                child: Text(
                  l10n.cancelAndExit,
                  style: TextStyle(color: cs.onSurfaceVariant),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
