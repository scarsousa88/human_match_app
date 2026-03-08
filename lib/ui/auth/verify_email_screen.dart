import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/common_ui.dart';
import '../loading_widget.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool isResending = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    // Opcional: Recarregar o utilizador automaticamente a cada 5 segundos
    timer = Timer.periodic(const Duration(seconds: 5), (_) => _checkEmailVerified());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> _checkEmailVerified() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
      if (user.emailVerified && mounted) {
        timer?.cancel();
        // O RootGate irá detetar a mudança no authState ou podemos forçar refresh
      }
    }
  }

  Future<void> _resendEmail() async {
    setState(() => isResending = true);
    try {
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.verificationResent)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => isResending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;
    const goldColor = Color(0xFFE6B325);

    return Scaffold(
      body: Shell(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: PrimaryCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.email_outlined, size: 64, color: goldColor),
                  const SizedBox(height: 24),
                  Text(
                    l10n.verifyEmailTitle,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.verifyEmailSent(user?.email ?? ''),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, height: 1.5),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _checkEmailVerified,
                      child: Text(l10n.checkVerification),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: isResending ? null : _resendEmail,
                    child: isResending 
                      ? const LoadingWidget(size: 20) 
                      : Text(l10n.resendVerification, style: const TextStyle(color: goldColor)),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => FirebaseAuth.instance.signOut(),
                    child: Text(l10n.logout, style: const TextStyle(color: Colors.white54)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
