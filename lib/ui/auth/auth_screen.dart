import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  void _toast(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  String _authMsg(BuildContext context, FirebaseAuthException e) {
    final l10n = AppLocalizations.of(context)!;
    switch (e.code) {
      case 'user-not-found': return l10n.errorUserNotFound;
      case 'wrong-password': return l10n.errorWrongPassword;
      case 'invalid-email': return l10n.errorInvalidEmail;
      case 'email-already-in-use': return l10n.errorEmailAlreadyInUse;
      case 'weak-password': return l10n.errorWeakPassword;
      default: return l10n.errorGeneral(e.message ?? e.code);
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
      if (mounted) _toast(_authMsg(context, e));
    } catch (e) {
      if (mounted) _toast(l10n.errorGeneral(e.toString()));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => loading = true);
    try {
      await GoogleSignIn.instance.initialize();
      final googleUser = await GoogleSignIn.instance.authenticate();
      final googleAuth = await googleUser.authentication;
      
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (!userDoc.exists) {
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'email': user.email,
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
      if (mounted) _toast(l10n.errorGeneral(e.toString()));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _resetPassword() async {
    final l10n = AppLocalizations.of(context)!;
    FocusScope.of(context).unfocus();
    final email = emailCtrl.text.trim();
    if (email.isEmpty) {
      _toast(l10n.resetEmailError);
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (mounted) _toast(l10n.resetEmailSent);
    } on FirebaseAuthException catch (e) {
      if (mounted) _toast(_authMsg(context, e));
    } catch (e) {
      if (mounted) _toast(l10n.errorGeneral(e.toString()));
    }
  }

  void _showTerms() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.termsTitle),
        content: SingleChildScrollView(child: Text(l10n.termsContent)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.ok)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
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
                  child: Image.asset(
                    'assets/icon/icon.png',
                    width: 46,
                    height: 46,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Human Match',
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
                      ),
                      Text(l10n.welcomeMessage, style: TextStyle(color: cs.onSurfaceVariant)),
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
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: l10n.email),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: passCtrl,
                    obscureText: true,
                    decoration: InputDecoration(labelText: l10n.password),
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
                              l10n.acceptTerms,
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
                    child: loading ? const LoadingWidget(size: 24) : Text(isLogin ? l10n.login : l10n.register),
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text("OU", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: loading ? null : _signInWithGoogle,
                    icon: Image.network(
                      'https://www.gstatic.com/images/branding/product/1x/gsa_512dp.png',
                      width: 20,
                      height: 20,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.login),
                    ),
                    label: const Text("Continuar com Google"),
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
            const SizedBox(height: 10),
            TextButton(
              onPressed: loading ? null : () => setState(() => isLogin = !isLogin),
              child: Text(isLogin ? l10n.noAccount : l10n.hasAccount),
            ),
          ],
        ),
      ),
    );
  }
}
