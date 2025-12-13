import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import '../models/user_model.dart';
import 'firebase_service.dart';
import 'local_storage_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class GoogleAuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      final String? clientId = dotenv.env['GOOGLE_CLIENT_ID'];
      final String? serverClientId = dotenv.env['GOOGLE_SERVER_CLIENT_ID'];

      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: clientId,
        serverClientId: serverClientId,
        scopes: ['https://www.googleapis.com/auth/contacts.readonly'],
      );

      final GoogleSignInAccount? account = await googleSignIn.signIn();
      if (account == null) return {};

      final String serverAuthCode = account.serverAuthCode ?? "";

      final email = account.email;
      final name = account.displayName ?? "";
      final googleId = account.id;
      final deviceToken = await FirebaseMessaging.instance.getToken() ?? "";

      return {
        "google_id": googleId,
        "email": email,
        "name": name,
        "device_token": deviceToken,
        "server_auth_code": serverAuthCode,
      };
    } catch (e) {
      return {
        "error": "Google sign-in failed",
      };
    }
  }
}
