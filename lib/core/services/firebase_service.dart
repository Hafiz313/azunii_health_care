// import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirebaseService {
  // static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // static const String _usersCollection = 'users';

  /// Save user to Firestore - COMMENTED OUT
  // static Future<void> saveUserToFirestore(UserModel user) async {
  //   try {
  //     await _firestore.collection(_usersCollection).doc(user.id).set(user.toJson());
  //   } catch (e) {
  //     throw Exception('Failed to save user to Firestore: $e');
  //   }
  // }

  /// Get user from Firestore - COMMENTED OUT
  // static Future<UserModel?> getUserFromFirestore(String userId) async {
  //   try {
  //     final doc = await _firestore.collection(_usersCollection).doc(userId).get();
  //     if (doc.exists) {
  //       return UserModel.fromJson(doc.data()!);
  //     }
  //     return null;
  //   } catch (e) {
  //     throw Exception('Failed to get user from Firestore: $e');
  //   }
  // }

  /// Update user in Firestore - COMMENTED OUT
  // static Future<void> updateUserInFirestore(UserModel user) async {
  //   try {
  //     await _firestore.collection(_usersCollection).doc(user.id).update(user.toJson());
  //   } catch (e) {
  //     throw Exception('Failed to update user in Firestore: $e');
  //   }
  // }

  /// Delete user from Firestore - COMMENTED OUT
  // static Future<void> deleteUserFromFirestore(String userId) async {
  //   try {
  //     await _firestore.collection(_usersCollection).doc(userId).delete();
  //   } catch (e) {
  //     throw Exception('Failed to delete user from Firestore: $e');
  //   }
  // }
}