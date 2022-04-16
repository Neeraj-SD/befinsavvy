import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider with ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool isLoading = false;

  Future<void> signIn() async {
    isLoading = true;
    notifyListeners();

    try {
      final user = await _googleSignIn.signIn();

      final googleAuth = await user?.authentication;

      // print('idToken: ${googleAuth?.idToken}');

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);

      isLoading = false;
      notifyListeners();
    } catch (ex) {
      print(ex);
      isLoading = false;
      notifyListeners();
    }
    // final currentUser = FirebaseAuth.instance.currentUser;
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await _googleSignIn.signOut();
    print('logout successful');
  }
}
