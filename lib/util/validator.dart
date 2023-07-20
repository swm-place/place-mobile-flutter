import 'package:get/utils.dart';

String? emailTextFieldValidator(String? value) {
  if (value == null || value.isEmpty) {
    return '이메일을 입력해주세요.';
  }
  if (!value.isEmail) {
    return '형식에 맞는 이메일을 입력해주세요.';
  }
  return null;
}

String? passwordTextFieldValidator(value) {
  if (value == null || value.isEmpty) {
    return '비밀번호를 입력해주세요.';
  }
  if (value.length < 6) {
    return '6자 이상 입력해주세요.';
  }
  return null;
}
