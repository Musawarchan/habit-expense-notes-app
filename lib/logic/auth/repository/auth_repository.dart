import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepository({FirebaseAuth? firebaseAuth, FirebaseFirestore? firestore})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<User?> get userStream => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      // Guard: Ensure a non-null user with a non-empty uid
      if (user != null && (user.uid).isNotEmpty) {
        // Ensure user document exists
        final userRef = _firestore.collection('users').doc(user.uid);
        final snapshot = await userRef.get();
        if (!snapshot.exists) {
          await userRef.set({
            'id': user.uid,
            'email': user.email,
            'name': user.displayName,
            'photoUrl': user.photoURL,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
            'preferences': {},
          });
        }
        return user;
      }
      // If Firebase returned no user, provide a consistent null result
      return null;
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapAuthError(e));
    } catch (e) {
      throw Exception('Sign in failed. Please try again.');
    }
  }

  Future<User?> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      // Guard: Ensure a non-null user with a non-empty uid
      if (user != null && (user.uid).isNotEmpty) {
        // Create user document in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'id': user.uid,
          'email': email,
          'name': name,
          'photoUrl': null,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
          'preferences': {},
        });
        return user;
      }
      // If Firebase returned no user, provide a consistent null result
      return null;
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapAuthError(e));
    } catch (e) {
      throw Exception('Account creation failed. Please try again.');
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      // TODO: Implement Google Sign-In
      // This would require google_sign_in package
      throw UnimplementedError('Google Sign-In not implemented yet');
    } catch (e) {
      throw Exception('Failed to sign in with Google: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out. Please try again.');
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapAuthError(e));
    } catch (e) {
      throw Exception('Failed to send password reset email.');
    }
  }

  Future<UserModel> getUserData(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();

      if (doc.exists) {
        return UserModel.fromJson(doc.data()!);
      } else {
        throw Exception('User data not found');
      }
    } catch (e) {
      throw Exception('Failed to get user data.');
    }
  }

  Future<void> updateUserData(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).update({
        'name': user.name,
        'photoUrl': user.photoUrl,
        'updatedAt': FieldValue.serverTimestamp(),
        'preferences': user.preferences,
      });
    } catch (e) {
      throw Exception('Failed to update user data.');
    }
  }

  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user has been disabled.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      default:
        return e.message ?? 'Authentication error. Please try again.';
    }
  }
}
