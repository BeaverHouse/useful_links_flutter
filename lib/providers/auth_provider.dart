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
    await _firebaseAuth.signOut().then((_) {
      getOkSnackbar(context, "로그아웃 되었습니다.");
    });
  }

  // 회원가입 함수
  void register(BuildContext context, String name, String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)
      .then((res) async {
        await res.user?.updateDisplayName(name)
        .then((_) async {
          await _firebaseAuth.signOut().then((_) {
            Navigator.pop(context);
            getOkSnackbar(context, "회원가입 되었습니다.");
          });
        });
      });
    } on FirebaseAuthException catch (e) {
      String message = "회원가입 오류입니다.";
      switch (e.code) {
        case 'email-already-in-use': 
          message = "이미 사용중인 이메일입니다.";
          break;
      }
      getOkSnackbar(context, message);
    }
  }

  void sendEmailVerify(BuildContext context) async {
    try {
      await _firebaseAuth.currentUser?.sendEmailVerification().then((_) {
        getOkSnackbar(context, "인증 메일이 발송되었습니다.");
      });
    } on FirebaseAuthException catch (e) {
      String message = "인증 메일 발송 오류입니다.";
      switch (e.code) {
        case 'too-many-requests': 
          message = "짧은 시간 내 메일을 보냈습니다.. 다시 시도해 주세요.";
          break;
      }
      getOkSnackbar(context, message);
    }
  }
}