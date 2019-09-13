import 'dart:async';

import 'package:local_auth/local_auth.dart';

class FingerPrint {
  static Future<bool> canCheckBiometrics() async {
    try {
      var localAuth = new LocalAuthentication();

      bool b = await localAuth.canCheckBiometrics;

      return b;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> verify() async {
    try {
      var localAuth = new LocalAuthentication();

      bool ok = await localAuth.authenticateWithBiometrics(
          localizedReason: 'Toque no sensor para autenticar com sua digital.');

      return ok;
    } catch (e) {
      return false;
    }
  }
}
