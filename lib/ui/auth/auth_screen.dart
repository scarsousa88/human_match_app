import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../l10n/app_localizations.dart';
import '../../app_terms.dart';
import '../loading_widget.dart';
import '../widgets/common_ui.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  bool loading = false;
  bool acceptTerms = false;
  bool obscurePass = true;

  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    debugPrint('APP_VERSION: 1.1.0_WEB_UPDATE');
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: (msg.contains('Erro') || msg.contains('Error') || msg.contains('incorrect') || msg.contains('incorretos') || msg.contains('existe')) ? Colors.red : null,
      )
    );
  }

  String _authMsg(BuildContext context, FirebaseAuthException e) {
    debugPrint('WEB_DEBUG: CODE=${e.code} | MSG=${e.message}');
    
    switch (e.code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
      case 'INVALID_LOGIN_CREDENTIALS':
      case 'invalid-login-credentials':
        return 'E-mail ou palavra-passe incorretos.';
      case 'email-already-in-use':
        return 'Este e-mail já está registado. Tente fazer login ou use outro e-mail.';
      case 'weak-password':
        return 'A palavra-passe é muito fraca. Use pelo menos 6 caracteres.';
      case 'invalid-email':
        return 'O formato do e-mail é inválido.';
      case 'operation-not-allowed':
        return 'O método de login por e-mail/senha não está ativo no Firebase Console.';
      default: return 'Erro (${e.code}): ${e.message ?? 'Erro desconhecido'}';
    }
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    FocusScope.of(context).unfocus();
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text;

    if (email.isEmpty || pass.isEmpty) {
      _toast(l10n.errorFillEmailPassword);
      return;
    }

    if (!isLogin && !acceptTerms) {
      _toast(l10n.errorAcceptTerms);
      return;
    }

    setState(() => loading = true);
    try {
      if (isLogin) {
        debugPrint('WEB_DEBUG: Tentando login: [$email]');
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pass);
      } else {
        debugPrint('WEB_DEBUG: Tentando registar: [$email]');
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
      if (mounted) _toast(_authMsg(context, e));
    } catch (e) {
      if (mounted) _toast('Erro inesperado: $e');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => loading = true);
    try {
      if (kIsWeb) {
        await FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
      } else {
        // Implementação mobile
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) _toast(_authMsg(context, e));
    } catch (e) {
      if (mounted) _toast('Erro Google: $e');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _resetPassword() async {
    final l10n = AppLocalizations.of(context)!;
    final email = emailCtrl.text.trim();
    if (email.isEmpty) {
      _toast(l10n.resetEmailError);
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (mounted) _toast(l10n.resetEmailSent);
    } catch (e) {
      if (mounted) _toast('Erro ao resetar: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Shell(
        child: ListView(
          children: [
            const SizedBox(height: 18),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset('assets/icon/icon.png', width: 46, height: 46),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Human Match', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
                      Text('Discover your cosmic DNA', style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            PrimaryCard(
              child: Column(
                children: [
                  TextField(
                    controller: emailCtrl,
                    decoration: InputDecoration(
                      labelText: l10n.email,
                      prefixIcon: const Icon(Icons.email_outlined, size: 20),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: passCtrl,
                    obscureText: obscurePass,
                    decoration: InputDecoration(
                      labelText: l10n.password,
                      prefixIcon: const Icon(Icons.lock_outline, size: 20),
                      suffixIcon: IconButton(
                        icon: Icon(obscurePass ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => obscurePass = !obscurePass),
                      ),
                    ),
                    onSubmitted: (_) => _submit(),
                  ),
                  const SizedBox(height: 14),
                  if (!isLogin)
                    Row(
                      children: [
                        Checkbox(
                          value: acceptTerms,
                          onChanged: (v) => setState(() => acceptTerms = v ?? false),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text(l10n.termsTitle),
                                  content: SingleChildScrollView(child: Text(l10n.termsContent)),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Fechar'))
                                  ],
                                ),
                              );
                            },
                            child: Text(
                              l10n.acceptTerms,
                              style: const TextStyle(fontSize: 13, decoration: TextDecoration.underline),
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: loading ? null : _submit,
                      child: loading ? const LoadingWidget(size: 24) : Text(isLogin ? l10n.login : l10n.register),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text("OU", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                      ),
                      onPressed: loading ? null : _signInWithGoogle,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1200px-Google_%22G%22_logo.svg.png',
                            height: 24,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            "Continuar com Google",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (isLogin)
                    TextButton(
                      onPressed: loading ? null : _resetPassword,
                      child: Text(l10n.forgotPassword),
                    ),
                ],
              ),
            ),
            TextButton(
              onPressed: () => setState(() {
                isLogin = !isLogin;
                acceptTerms = false;
              }),
              child: Text(isLogin ? l10n.noAccount : l10n.hasAccount),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text('v1.1.0_WEB_UPDATE', style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.2))),
            ),
          ],
        ),
      ),
    );
  }
}
