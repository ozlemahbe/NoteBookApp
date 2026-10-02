import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

/// Service handling Firebase Authentication operations
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Gets the currently authenticated user mapped to [UserModel]
  UserModel? get currentUser {
    final user = _auth.currentUser;
    if (user == null) return null;
    return _mapFirebaseUser(user);
  }

  /// Stream of user auth state changes
  Stream<UserModel?> get authStateChanges {
    return _auth.authStateChanges().map((user) {
      if (user == null) return null;
      return _mapFirebaseUser(user);
    });
  }

  UserModel _mapFirebaseUser(User user) {
    return UserModel(
      email: user.email ?? 'isimsiz@gmail.com',
      displayName: user.displayName ?? user.email?.split('@').first ?? 'Pastel Kullanıcı',
      isLoggedIn: true,
      avatarUrl: user.photoURL,
    );
  }

  /// Sign up with email and password
  Future<UserModel> signUpWithEmail(String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      throw Exception('Kullanıcı oluşturulamadı.');
    }
    return _mapFirebaseUser(user);
  }

  /// Sign in with email and password
  Future<UserModel> signInWithEmail(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      throw Exception('Giriş yapılamadı.');
    }
    return _mapFirebaseUser(user);
  }

  /// Google Sign In
  Future<UserModel> signInWithGoogle() async {
    if (kIsWeb) {
      // On Web: use GoogleAuthProvider popup
      final googleProvider = GoogleAuthProvider();
      googleProvider.addScope('email');
      final credential = await _auth.signInWithPopup(googleProvider);
      final user = credential.user;
      if (user == null) {
        throw Exception('Google ile giriş yapılamadı.');
      }
      return _mapFirebaseUser(user);
    } else {
      // On desktop / other platforms: try signInWithProvider or throw readable message
      final googleProvider = GoogleAuthProvider();
      final credential = await _auth.signInWithProvider(googleProvider);
      final user = credential.user;
      if (user == null) {
        throw Exception('Google ile giriş yapılamadı.');
      }
      return _mapFirebaseUser(user);
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Convert Firebase error codes into friendly Turkish messages
  static String getReadableErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          return 'Geçersiz bir e-posta adresi girdiniz.';
        case 'user-disabled':
          return 'Bu kullanıcı hesabı devre dışı bırakılmış.';
        case 'user-not-found':
          return 'Bu e-posta adresiyle kayıtlı bir hesap bulunamadı.';
        case 'wrong-password':
          return 'Girdiğiniz şifre hatalı. Lütfen tekrar deneyin.';
        case 'email-already-in-use':
          return 'Bu e-posta adresi zaten kullanımda. "Giriş yap" sekmesini deneyin.';
        case 'operation-not-allowed':
          return 'E-posta ile giriş Firebase Console\'da henüz aktif edilmemiş.';
        case 'weak-password':
          return 'Şifreniz çok zayıf. En az 6 karakterli daha güçlü bir şifre belirleyin.';
        case 'invalid-credential':
          return 'E-posta adresi veya şifre hatalı.';
        case 'network-request-failed':
          return 'İnternet bağlantınızı kontrol edin.';
        case 'popup-closed-by-user':
          return 'Google giriş penceresi kapatıldı.';
        default:
          return error.message ?? 'Bir hata oluştu (${error.code}).';
      }
    }
    return error.toString().replaceAll('Exception: ', '');
  }
}
