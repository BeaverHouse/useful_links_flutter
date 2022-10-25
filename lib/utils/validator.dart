import 'package:validators/validators.dart';

String? emailValidate(String? val) {
  return !isEmail(val ?? "") ? "잘못된 이메일" : null;
}

String? passwordValidate(String? val) {
  if (!isAlphanumeric(val ?? "")) {
    return "비밀번호는 영어, 숫자로만 이루어져야 합니다.";
  } else if (!isByteLength(val ?? "", 6)) {
    return "비밀번호는 6자 이상이어야 합니다.";
  }
  return null;
}

String? nameValidate(String? val) {
  return !matches(val ?? "", r"^[가-힣]+$") ? "잘못된 이름" : null;
}

String? linkValidate(String? val) {
  return !isURL(val ?? "", protocols: ["http", "https"]) ? "잘못된 링크" : null;
}