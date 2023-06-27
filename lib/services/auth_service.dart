// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/models/user_model.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  //La funcion recoje los datos del usuario y los guarda en la base de datos
  Future<String> singUpUser({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
        UserCredential credential = await _firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);

        UserModel userModel = UserModel(
          uid: credential.user!.uid,
          name: name,
          email: email,
          password: password,
        );

        await _firebaseFirestore
            .collection('users')
            .doc(credential.user!.uid)
            .set(userModel.toJson());

        return "Signed up";
      } else {
        return "Please fill all the fields";
      }
    } on FirebaseAuthException catch (e) {
      print(e.message.toString());
      return e.message!;
    }
  }

  //La funcion recoje los datos del usuario y los guarda en la base de datos
  Future<String> login({
    required String email,
    required String password,
  }) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        return "Logged in";
      } else {
        return "Please fill all the fields";
      }
    } on FirebaseAuthException catch (e) {
      return e.message!;
    }
  }

  //La funcion cierra la sesion del usuario
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  Future<bool> isUserLoggedIn() async {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null;
  }

  Future<void> sendVerificationEmail() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Stream<User?> get authUserStream {
    return _firebaseAuth.authStateChanges();
  }

  Future<UserModel> getCurrentUser() async {
    User? user = _firebaseAuth.currentUser!;

    DocumentSnapshot doc =
        await _firebaseFirestore.collection('users').doc(user.uid).get();

    return UserModel.fromJson(doc);
  }
}
