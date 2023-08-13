import 'package:get/utils.dart';

String? emailTextFieldValidator(String? value) {
  if (value == null || value.isEmpty) {
    return '이메일을 입력해주세요';
  }
  if (!value.isEmail) {
    return '형식에 맞는 이메일을 입력해주세요';
  }
  return null;
}

String? passwordTextFieldValidator(value) {
  if (value == null || value.isEmpty) {
    return '비밀번호를 입력해주세요';
  }
  if (value.length < 6) {
    return '6자 이상 입력해주세요';
  }
  return null;
}

String? nicknameTextFieldValidator(value) {
  RegExp regExp = new RegExp(r'[^a-zA-Z가-힣0-9ㄱ-ㅎㅏ-ㅣ]',);

  if (value == null || value.isEmpty) {
    return '닉네임을 입력해주세요';
  }
  if (value.length < 2) {
    return '2자 이상 입력해주세요';
  }
  if (value.length > 10) {
    return '10자 이하 입력해주세요';
  }
  if (regExp.hasMatch(value)) {
    return '특수문자 제외';
  }
  return null;
}

String? phoneNumberTextFieldValidator(value) {
  RegExp regExp = new RegExp(r'^010(\d{8})$',);
  RegExp regExpHype = new RegExp(r'-',);

  if (value == null || value.isEmpty) {
    return '전화번호를 입력해주세요';
  }
  if (regExpHype.hasMatch(value)) {
    return '하이픈(-) 기호는 제외해주세요';
  }
  if (!regExp.hasMatch(value)) {
    return '전화번호 형식에 맞게 입력해주세요';
  }
  return null;
}

String? bookmarkTextFieldValidator(value) {
  RegExp regExp = new RegExp(r'[^a-zA-Z가-힣0-9ㄱ-ㅎㅏ-ㅣ ]',);

  if (value == null || value.isEmpty) {
    return '북마크 이름을 입력해주세요.';
  }
  if (regExp.hasMatch(value)) {
    return '특수문자 제외';
  }
  return null;
}
