import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationServices {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> loginUser(String emailadress, String passwords) async {
    try {
      final result = await auth.signInWithEmailAndPassword(
          email: emailadress, password: passwords);
      return result.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }

    return null;
  }
}
