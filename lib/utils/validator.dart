import 'package:validators/validators.dart';

String? emailValidate(String? val) {
  return !isEmail(val ?? "") ? "잘못된 이메일" : null;
}

String? passwordValidate(String? val) {
  return !isAlphanumeric(val ?? "") ? "비밀번호는 영어, 숫자로만 이루어져야 합니다." : null;
}