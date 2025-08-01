import 'package:local_auth/local_auth.dart';

final auth = LocalAuthentication();

Future<bool> authenticateWithBiometrics() async {
  final isAvailable = await auth.canCheckBiometrics;
  if (!isAvailable) {
    print("❌ Biometrics not available");
    return false;
  }

  final didAuthenticate = await auth.authenticate(
    localizedReason: 'Please authenticate to continue',
    options: const AuthenticationOptions(
      biometricOnly: true,
    ),
  );

  return didAuthenticate;
}
