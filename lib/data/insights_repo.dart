import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InsightsRepo {
  InsightsRepo(this._db, this._auth);

  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  DocumentReference<Map<String, dynamic>> _doc() {
    final uid = _auth.currentUser!.uid;
    return _db.collection('users').doc(uid).collection('insights').doc('current');
  }

  Future<String?> getCachedInsights({Duration maxAge = const Duration(hours: 24), int promptVersion = 2}) async {
    final snap = await _doc().get();
    if (!snap.exists) return null;

    final data = snap.data();
    if (data == null) return null;

    final text = (data['text'] ?? '').toString();
    final ts = data['updatedAt'];
    final pv = (data['promptVersion'] ?? 0) as int;

    if (text.trim().isEmpty) return null;
    if (pv < promptVersion) return null;

    if (ts is Timestamp) {
      final age = DateTime.now().difference(ts.toDate());
      if (age > maxAge) return null;
    } else {
      return null;
    }

    return text;
  }

  Future<void> saveInsights(String text, {int promptVersion = 2}) async {
    await _doc().set({
      'text': text,
      'updatedAt': FieldValue.serverTimestamp(),
      'promptVersion': promptVersion,
    }, SetOptions(merge: true));
  }
}
