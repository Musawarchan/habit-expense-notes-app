import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../auth/models/user_model.dart';

class ProfileRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  ProfileRepository({FirebaseAuth? firebaseAuth, FirebaseFirestore? firestore})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<String?> get userIdStream =>
      _firebaseAuth.authStateChanges().map((u) => u?.uid);

  Future<UserModel> fetchUserById(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (!doc.exists || doc.data() == null) {
      throw Exception('User not found');
    }
    return UserModel.fromJson(doc.data()!);
  }

  Future<void> updateUserName({
    required String userId,
    required String name,
  }) async {
    await _firestore.collection('users').doc(userId).update({
      'name': name,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updatePhotoUrl({
    required String userId,
    required String photoUrl,
  }) async {
    await _firestore.collection('users').doc(userId).update({
      'photoUrl': photoUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
