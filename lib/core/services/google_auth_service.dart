import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import '../models/user_model.dart';
import 'firebase_service.dart';
import 'local_storage_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class GoogleAuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Show account picker and sign in with Google
  /// import 'package:google_sign_in/google_sign_in.dart';

  Future<Map<String, dynamic>> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? account = await googleSignIn.signIn();

    if (account == null) return {}; // user canceled

    final email = account.email;
    final name = account.displayName ?? "";
    final googleId = account.id;
    final deviceToken = await FirebaseMessaging.instance.getToken() ?? "";

    return {
      "google_id": googleId,
      "email": email,
      "name": name,
      "device_token": deviceToken,
    };
  }

  // static Future<UserModel?> signInWithGoogle() async {
  //   try {
  //     await _googleSignIn.signOut(); // Forces account selection

  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //     if (googleUser == null) return null; // User canceled

  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;

  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     final UserCredential userCredential =
  //         await _auth.signInWithCredential(credential);

  //     final user = userCredential.user;
  //     if (user == null) return null;

  //     return UserModel(
  //       name: googleUser.displayName ?? '',
  //       email: googleUser.email,
  //       profilePicture: googleUser.photoUrl ?? '',
  //     );
  //   } catch (e) {
  //     print("Google Sign-In Error: $e");
  //     rethrow;
  //   }
  // }

  /// Sign out from Google and clear data
  static Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      await LocalStorageService.logout();
    } catch (e) {
      // Handle Firebase errors gracefully during logout
      try {
        await LocalStorageService.logout();
      } catch (localError) {
        throw Exception('Sign out failed: $e');
      }
    }
  }

  /// Get current user from local storage
  // static Future<UserModel?> getCurrentUser() async {
  //   try {
  //     final userId = await LocalStorageService.getCurrentUserId();
  //     if (userId != null) {
  //       return LocalStorageService.getUserLocally(userId);
  //     }
  //     return null;
  //   } catch (e) {
  //     return null;
  //   }
  // }

  /// Check if user is signed in
  static Future<bool> isSignedIn() async {
    return await LocalStorageService.getLoginStatus();
  }

  /// Get available Google accounts
  static Future<List<GoogleSignInAccount>> getAvailableAccounts() async {
    try {
      await _googleSignIn.signOut();
      return [];
    } catch (e) {
      return [];
    }
  }
}
