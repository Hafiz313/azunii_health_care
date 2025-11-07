import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../main.dart';

class InactivityService {
  static final InactivityService _instance = InactivityService._internal();
  factory InactivityService() => _instance;
  InactivityService._internal();

  Timer? _inactivityTimer;
  VoidCallback? _onTimeout;
  final Duration timeoutDuration = const Duration(minutes: 3);
  bool _isDialogShowing = false;

  void initialize(VoidCallback onTimeout) {
    _onTimeout = onTimeout;
    resetTimer();
  }

  void resetTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(timeoutDuration, _handleTimeout);
  }

  void _handleTimeout() async {
    if (_onTimeout != null && !_isDialogShowing) {
      _isDialogShowing = true;
      
      // Get the current context
      final context = navigate.currentContext;
      if (context != null) {
        // Show session timeout dialog
        final shouldLogout = await _showSessionTimeoutDialog(context);
        _isDialogShowing = false;
        
        if (shouldLogout) {
          _onTimeout!();
        } else {
          // Reset timer if user chooses to continue
          resetTimer();
        }
      } else {
        // If no context available, directly logout
        _isDialogShowing = false;
        _onTimeout!();
      }
    }
  }

  Future<bool> _showSessionTimeoutDialog(BuildContext context) async {
    try {
      return await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: Column(
                children: [
                  Icon(
                    Icons.timer_off,
                    color: Colors.blue,
                    size: 50,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Session Timeout",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Your session has expired due to inactivity. You will be logged out automatically.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Do you want to continue your session?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Text(
                          "Logout",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text(
                          "Continue",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ) ?? true; // Default to logout if dialog is dismissed
    } catch (e) {
      // If there's an error showing the dialog, default to logout
      return true;
    }
  }

  void dispose() {
    _inactivityTimer?.cancel();
  }
}
