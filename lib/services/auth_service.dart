import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  AuthService._();
  static final instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static const _seededKey = 'app_seeded';

  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;

  Future<void> init() async {
    _auth.authStateChanges().listen((user) async {
      if (user != null) {
        final doc = await _db.collection('users').doc(user.uid).get();
        if (doc.exists) {
          _currentUser = AppUser.fromMap(doc.data()!);
        }
      } else {
        _currentUser = null;
      }
    });
  }

  Future<AppUser> login(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final doc = await _db.collection('users').doc(cred.user!.uid).get();
    if (!doc.exists) throw Exception('User data not found');
    final user = AppUser.fromMap(doc.data()!);
    _currentUser = user;
    return user;
  }

  Future<AppUser> register(String name, String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = AppUser(
      uid: cred.user!.uid,
      name: name,
      email: email,
      role: 'user',
    );
    await _db.collection('users').doc(user.uid).set(user.toMap());
    _currentUser = user;
    return user;
  }

  Future<void> logout() async {
    await _auth.signOut();
    _currentUser = null;
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    final user = _auth.currentUser;
    if (user == null || user.email == null) throw Exception('Not logged in');
    final cred = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );
    await user.reauthenticateWithCredential(cred);
    await user.updatePassword(newPassword);
  }

  Future<void> changeEmail(String newEmail, String password) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not logged in');
    final cred = EmailAuthProvider.credential(
      email: user.email!,
      password: password,
    );
    await user.reauthenticateWithCredential(cred);
    await user.verifyBeforeUpdateEmail(newEmail);
    await _db.collection('users').doc(user.uid).update({'email': newEmail});
  }

  Future<bool> isLoggedIn() async => _auth.currentUser != null;

  Future<AppUser?> tryRestoreSession() async {
    final fbUser = _auth.currentUser;
    if (fbUser == null) return null;
    try {
      final doc = await _db.collection('users').doc(fbUser.uid).get();
      if (!doc.exists) return null;
      _currentUser = AppUser.fromMap(doc.data()!);
      return _currentUser;
    } catch (_) {
      return null;
    }
  }

  Future<bool> hasSeeded() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_seededKey) ?? false;
  }

  Future<void> markSeeded() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_seededKey, true);
  }

  Future<AppUser> seedAdmin() async {
    const email = 'admin@reciperecive.com';
    const password = 'Admin123!';

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      final existing = _auth.currentUser;
      if (existing != null) {
        final doc = await _db.collection('users').doc(existing.uid).get();
        if (doc.exists) {
          _currentUser = AppUser.fromMap(doc.data()!);
          return _currentUser!;
        }
      }
    } on FirebaseAuthException catch (_) {}

    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final admin = AppUser(
        uid: cred.user!.uid,
        name: 'Admin',
        email: email,
        role: 'admin',
      );
      await _db.collection('users').doc(admin.uid).set(admin.toMap());
      _currentUser = admin;
      return admin;
    } catch (e) {
      throw Exception('Failed to create admin: $e');
    }
  }
}
