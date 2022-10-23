import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/snackbar.dart';

class AuthProvider {
  final FirebaseAuth _firebaseAuth;
  
  AuthProvider(this._firebaseAuth);

  Stream<User?> get authState => _firebaseAuth.authStateChanges();
  
  // 로그인 함수
  void signIn(BuildContext context, String email, String password) async {
    
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password)
      .then((_) => getOkSnackbar(context, "로그인 되었습니다."));
    } on FirebaseAuthException catch (e) {
      String message = "로그인 오류입니다.";
      switch (e.code) {
        case 'user-not-found': 
          message = "해당하는 유저가 존재하지 않습니다.";
          break;
        case 'wrong-password': 
          message = "비밀번호가 다릅니다.";
          break;
      }
      getOkSnackbar(context, message);
    }
  }

  // 로그아웃 함수
  void signOut(BuildContext context) async {
    await _firebaseAuth.signOut().then((_) => getOkSnackbar(context, "로그아웃 되었습니다."));
  }
}