import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';

// Interface
abstract class AuthService {
  Stream<UserProfile?> get authStateChanges;
  Future<void> signIn(String email, String password);
  Future<void> signUp(String email, String password);
  Future<void> signInWithGoogle();
  Future<void> signOut();
  Future<void> updateProfile(UserProfile profile);
  UserProfile? get currentUser; // Add direct access
}

// Stub Implementation for Development without Firebase setup
// Stub Implementation for Development without Firebase setup

class FirebaseAuthService implements AuthService {
  final _auth = firebase_auth.FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  UserProfile? get currentUser {
    final user = _auth.currentUser;
    if (user == null) return null;
    return UserProfile(uid: user.uid, email: user.email ?? '');
  }

  @override
  Stream<UserProfile?> get authStateChanges {
    return _auth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;

      try {
        final doc =
            await _firestore.collection('users').doc(firebaseUser.uid).get();
        if (doc.exists) {
          return UserProfile.fromMap(doc.data()!);
        }
        return UserProfile(
            uid: firebaseUser.uid,
            email: firebaseUser.email ?? '',
            isOnboardingComplete: false);
      } catch (e) {
        print('Error fetching user profile: $e'); // Add logging
        return UserProfile(
            uid: firebaseUser.uid, email: firebaseUser.email ?? '');
      }
    });
  }

  @override
  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> signUp(String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    if (credential.user != null) {
      final newUser = UserProfile(
        uid: credential.user!.uid,
        email: email,
        isOnboardingComplete: false,
      );
      try {
        await _firestore
            .collection('users')
            .doc(newUser.uid)
            .set(newUser.toMap());
      } catch (e) {
        print('Error creating user profile in Firestore: $e');
        // Continue event if firestore fails, so user can at least login
      }
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
          clientId:
              "10847732026-hfvuqirr6p16sje7l77d35vfmdj2nju1.apps.googleusercontent.com");
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final firebase_auth.AuthCredential credential =
          firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        final doc = await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();
        if (!doc.exists) {
          final newUser = UserProfile(
            uid: userCredential.user!.uid,
            email: userCredential.user!.email ?? '',
            businessName: userCredential.user!.displayName ?? 'Bisnis UMKM',
            isOnboardingComplete: false,
          );
          await _firestore
              .collection('users')
              .doc(newUser.uid)
              .set(newUser.toMap());
        }
      }
    } catch (e) {
      print('Error in Google Sign In: $e');
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Future<void> updateProfile(UserProfile profile) async {
    if (_auth.currentUser != null) {
      try {
        await _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .set(profile.toMap(), SetOptions(merge: true));
      } catch (e) {
        print('Error updating user profile in Firestore: $e');
        // Swallow error to allow app navigation to proceed even if persistence fails
      }
    }
  }
}

// Provider
final authServiceProvider = Provider<AuthService>((ref) {
  return FirebaseAuthService();
});

final authStateProvider = StreamProvider<UserProfile?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});
