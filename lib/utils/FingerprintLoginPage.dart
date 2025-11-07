import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class FingerprintLoginPage extends StatefulWidget {
  const FingerprintLoginPage({super.key});

  @override
  _FingerprintLoginPageState createState() => _FingerprintLoginPageState();
}

class _FingerprintLoginPageState extends State<FingerprintLoginPage> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _authenticated = false;

  Future<void> _authenticate() async {
    try {
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      if (!canCheckBiometrics) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Biometric not available")),
        );
        return;
      }

      bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to log in',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (didAuthenticate) {
        setState(() {
          _authenticated = true;
        });
        // Navigate to home screen or secure area
      }
    } catch (e) {
      print("Error using biometric auth: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fingerprint Login")),
      body: Center(
        child: _authenticated
            ? const Text("Authenticated Successfully!",
                style: TextStyle(fontSize: 18))
            : ElevatedButton.icon(
                onPressed: _authenticate,
                icon: const Icon(Icons.fingerprint, size: 30),
                label: const Text("Login with Fingerprint"),
              ),
      ),
    );
  }
}
