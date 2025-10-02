import 'package:firebase_auth/firebase_auth.dart';

/// AuthService - singleton wrapper around FirebaseAuth
/// Notes:
/// - Ensure Firebase is configured (flutterfire configure) and firebase_options.dart present.
/// - Enable Email/Password and Phone providers in Firebase Console for full functionality.
class AuthService {
  AuthService._private();
  static final AuthService instance = AuthService._private();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Current user
  User? get currentUser => _auth.currentUser;

  // Email / Password sign in
  Future<UserCredential> signInWithEmail(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // Email / Password registration
  Future<UserCredential> registerWithEmail(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Phone auth: request verification. Provide callbacks to handle codeSent, completed and errors.
  Future<void> requestPhoneVerification({
    required String phoneNumber,
    required void Function(String verificationId, int? resendToken) onCodeSent,
    required void Function(UserCredential credential) onVerificationCompleted,
    required void Function(FirebaseAuthException e) onVerificationFailed,
    int? forceResendingToken,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: timeout,
      forceResendingToken: forceResendingToken,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-retrieval or instant verification
        final credentialResult = await _auth.signInWithCredential(credential);
        onVerificationCompleted(credentialResult);
      },
      verificationFailed: (FirebaseAuthException e) {
        onVerificationFailed(e);
      },
      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId, resendToken);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto retrieval timed out - app can prompt user to enter SMS code
      },
    );
  }

  // Verify SMS code and sign in
  Future<UserCredential> verifySmsCode({required String verificationId, required String smsCode}) async {
    final credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
    return await _auth.signInWithCredential(credential);
  }

  // Utility: sign in with a generic credential (useful for testing)
  Future<UserCredential> signInWithCredential(AuthCredential credential) async {
    return await _auth.signInWithCredential(credential);
  }
}
