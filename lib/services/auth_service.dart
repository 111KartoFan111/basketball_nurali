import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<UserModel> login(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = cred.user!.uid;
      final doc = await _db.collection('users').doc(uid).get();
      if (!doc.exists) {
        // Создаём минимальную запись, если отсутствует
        final user = UserModel(
          userId: uid,
          email: cred.user!.email ?? email,
          firstName: '',
          lastName: '',
          role: 'player',
          dateOfBirth: null,
          profilePhotoUrl: null,
        );
        await _db.collection('users').doc(uid).set(user.toJson());
        return user;
      }
      return UserModel.fromJson(doc.data()!);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Auth error');
    }
  }

  Future<UserModel> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = cred.user!.uid;
      final user = UserModel(
        userId: uid,
        email: cred.user!.email ?? email,
        firstName: firstName,
        lastName: lastName,
        role: 'player',
        dateOfBirth: null,
        profilePhotoUrl: null,
      );
      await _db.collection('users').doc(uid).set(user.toJson());
      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Registration error');
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
