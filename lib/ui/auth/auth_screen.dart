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
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  void _toast(String msg, {bool isError = true}) {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 4),
        action: msg.contains(l10n.errorEmailAlreadyInUse) || msg.contains(l10n.login)
          ? SnackBarAction(
              label: l10n.login.toUpperCase(), 
              textColor: Colors.white,
              onPressed: () => setState(() => isLogin = true)
            ) 
          : null,
      )
    );
  }

  String _authMsg(BuildContext context, FirebaseAuthException e) {
    final l10n = AppLocalizations.of(context)!;
    debugPrint('AUTH_ERROR: ${e.code} | ${e.message}');
    
    switch (e.code) {
      case 'user-not-found': return l10n.errorUserNotFound;
      case 'wrong-password': return l10n.errorWrongPassword;
      case 'email-already-in-use': return l10n.errorEmailAlreadyRegistered;
      case 'invalid-credential':
      case 'INVALID_LOGIN_CREDENTIALS': return l10n.errorInvalidCredentials;
      case 'weak-password': return l10n.errorWeakPassword;
      case 'invalid-email': return l10n.errorInvalidEmail;
      case 'user-disabled': return l10n.errorUserDisabled;
      case 'too-many-requests': return l10n.errorTooManyRequests;
      case 'account-exists-with-different-credential': 
        return l10n.errorAccountExistsGoogle;
      default: return l10n.errorGeneral(e.code);
    }
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    FocusScope.of(context).unfocus();
    final email = emailCtrl.text.trim().toLowerCase();
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
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pass);
      } else {
        final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: pass);
        final user = cred.user;
        if (user != null) {
          final uid = user.uid;
          
          await user.sendEmailVerification();
          
          await FirebaseFirestore.instance.collection('users').doc(uid).set({
            'email': email,
            'acceptTerms': true,
            'acceptedTermsVersion': AppTerms.currentVersion,
            'termsAcceptedAt': FieldValue.serverTimestamp(),
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        }
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) _toast(_authMsg(context, e));
    } catch (e) {
      if (mounted) _toast(l10n.errorUnexpected(e.toString()));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => loading = true);
    try {
      if (kIsWeb) {
        await FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
      } else {
        await FirebaseAuth.instance.signInWithProvider(GoogleAuthProvider());
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) _toast(_authMsg(context, e));
    } catch (e) {
      if (mounted) _toast(l10n.errorGoogle(e.toString()));
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
      if (mounted) _toast(l10n.resetEmailSent, isError: false);
    } catch (e) {
      if (mounted) _toast(l10n.errorResetPassword(e.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const goldColor = Color(0xFFE6B325);

    return Scaffold(
      body: Shell(
        child: ListView(
          children: [
            const SizedBox(height: 30),
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: goldColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: goldColor.withOpacity(0.2)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset('assets/icon/icon.png', width: 80, height: 80),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Human Match',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -1),
                  ),
                  const Text(
                    'DISCOVER YOUR COSMIC DNA',
                    style: TextStyle(color: goldColor, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            PrimaryCard(
              child: Column(
                children: [
                  TextField(
                    controller: emailCtrl,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: l10n.email,
                      labelStyle: const TextStyle(color: Colors.white60),
                      prefixIcon: const Icon(Icons.email_outlined, size: 20, color: Colors.white60),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passCtrl,
                    obscureText: obscurePass,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: l10n.password,
                      labelStyle: const TextStyle(color: Colors.white60),
                      prefixIcon: const Icon(Icons.lock_outline, size: 20, color: Colors.white60),
                      suffixIcon: IconButton(
                        icon: Icon(obscurePass ? Icons.visibility_off : Icons.visibility, color: Colors.white60),
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
                          activeColor: goldColor,
                          checkColor: Colors.black,
                          side: const BorderSide(color: Colors.white38),
                          onChanged: (v) => setState(() => acceptTerms = v ?? false),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  backgroundColor: const Color(0xFF1A162B),
                                  title: Text(l10n.termsTitle, style: const TextStyle(color: Colors.white)),
                                  content: SingleChildScrollView(child: Text(AppTerms.termsText, style: const TextStyle(color: Colors.white70))),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.close, style: const TextStyle(color: goldColor)))
                                  ],
                                ),
                              );
                            },
                            child: Text(
                              l10n.acceptTerms,
                              style: const TextStyle(fontSize: 13, color: Colors.white70, decoration: TextDecoration.underline),
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: loading ? null : _submit,
                      child: loading ? const LoadingWidget(size: 24) : Text(isLogin ? l10n.login : l10n.register),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.white.withOpacity(0.1))),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(l10n.orDivider, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white.withOpacity(0.3), fontSize: 12)),
                      ),
                      Expanded(child: Divider(color: Colors.white.withOpacity(0.1))),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 55,
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.05),
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.white.withOpacity(0.1)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: loading ? null : _signInWithGoogle,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/icon/google_logo.png', height: 22),
                          const SizedBox(width: 12),
                          Text(l10n.continueWithGoogle, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (isLogin)
                    TextButton(
                      onPressed: loading ? null : _resetPassword,
                      child: Text(l10n.forgotPassword, style: const TextStyle(color: Colors.white54)),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => setState(() {
                isLogin = !isLogin;
                acceptTerms = false;
              }),
              child: Text(
                isLogin ? l10n.noAccount : l10n.hasAccount,
                style: const TextStyle(color: goldColor, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
