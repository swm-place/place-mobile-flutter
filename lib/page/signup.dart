import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:place_mobile_flutter/state/auth_controller.dart';
import 'package:place_mobile_flutter/theme/color_schemes.g.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';
import 'package:place_mobile_flutter/util/validator.dart';
import 'package:place_mobile_flutter/widget/tos.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({
    Key? key,
    required canBack,
  }) : super(key: key);

  bool canBack = false;

  @override
  State<StatefulWidget> createState() {
    return SignUpPageState();
  }
}

enum Sex {male, female}

class SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final FocusNode passwordCheckFocusNode = FocusNode();
  final FocusNode phoneNumberFocusNode = FocusNode();

  final PageController pageController = PageController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordCheckController = TextEditingController();

  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController birthController = TextEditingController();

  bool hidePassword = true;

  String? emailError;
  String? passwordError;
  String? passwordCheckError;

  String? nicknameError;
  String? phoneNumberError;
  String? birthError;
  int pageIdx = 0;

  String tosButtonText = "다음";
  Color tosButtonNextColor = lightColorScheme.primary;

  DateTime? selectedBirth;

  final tosList = {
    {
      "text": "개인정보처리 약관",
      "required": true,
      "agree": false
    },
    {
      "text": "위치정보기반 서비스 제공",
      "required": true,
      "agree": false
    },
    {
      "text": "마케팅 알림 동의",
      "required": false,
      "agree": false
    },
  };

  Sex selectedSex = Sex.male;

  Widget _emailPage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
      child: Column(
        children: [
          const SizedBox(
            width: double.infinity,
            child: Text(
              "이메일을 입력해주세요",
              style: titleLarge,
            ),
          ),
          const SizedBox(
            width: double.infinity,
            child: Text(
              "로그인에 필요합니다",
              style: bodyLargeGray,
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: TextField(
              onChanged: (text) {
                setState(() {
                  final email = text.tr;
                  emailError = emailTextFieldValidator(email);
                });
              },
              decoration: InputDecoration(
                  hintText: "example@example.com",
                  hintStyle: headlineSmallGray,
                  errorText: emailError
              ),
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              style: headlineSmall,
            ),
          )
        ],
      ),
    );
  }

  Widget _passwordPage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
      child: Column(
        children: [
          const SizedBox(
            width: double.infinity,
            child: Text(
              "비밀번호를 입력해주세요",
              style: titleLarge,
            ),
          ),
          const SizedBox(
            width: double.infinity,
            child: Text(
              "6자 이상 필요합니다",
              style: bodyLargeGray,
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: TextField(
              onChanged: (text) {
                setState(() {
                  final password = text.tr;
                  passwordError = passwordTextFieldValidator(password);
                });
              },
              decoration: InputDecoration(
                hintText: "비밀번호",
                hintStyle: headlineSmallGray,
                // helperText: "hdusiah",
                errorText: passwordError,
                suffixIcon: IconButton(
                  icon: Icon(hidePassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                ),
              ),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              controller: passwordController,
              style: headlineSmall,
              obscureText: hidePassword,
              enableSuggestions: false,
              autocorrect: false,
              onSubmitted: (String value) {
                FocusScope.of(context).requestFocus(passwordCheckFocusNode);
              },
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: TextField(
              focusNode: passwordCheckFocusNode,
              onChanged: (text) {
                setState(() {
                  final passwordCheck = text.tr;
                  if (passwordController.text.tr != passwordCheck) {
                    passwordCheckError = "비밀번호가 일치하지 않습니다!";
                  } else {
                    passwordCheckError = null;
                  }
                });
              },
              decoration: InputDecoration(
                hintText: "비밀번호 재입력",
                hintStyle: headlineSmallGray,
                errorText: passwordCheckError,
                suffixIcon: IconButton(
                  focusNode: null,
                  icon: Icon(hidePassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                ),
              ),
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.emailAddress,
              controller: passwordCheckController,
              style: headlineSmall,
              obscureText: hidePassword,
              enableSuggestions: false,
              autocorrect: false,
            ),
          )
        ],
      ),
    );
  }

  Widget __tosWidgetList() {
    List<Widget> tosWidget = [];
    tosList.forEach((element) {
      // print(element);
      tosWidget.add(SizedBox(
          width: double.infinity,
          child: CheckTos(
            agreeValue: element['agree'] as bool,
            tosText: element['text'].toString(),
            require: element['required'] as bool,
            callback: (val) {
              element['agree'] = val;
            },
          ),
        )
      );
    });
    return Column(
      children: tosWidget,
    );
  }

  Widget _tosAgreePage() {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter bottomState) {
          return Padding(
              padding: EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 190,
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "약관 동의",
                        style: titleLarge,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    __tosWidgetList(),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: tosButtonNextColor
                            ),
                            child: Text(tosButtonText),
                            onPressed: () {
                              bool checkTos = true;
                              for (var element in tosList) {
                                if (element['required'] as bool) {
                                  if (!(element['agree'] as bool)) {
                                    checkTos = false;
                                    break;
                                  }
                                }
                              }

                              if (checkTos) {
                                bottomState(() {
                                  setState(() {
                                    tosButtonText = "다음";
                                    tosButtonNextColor = lightColorScheme.primary;
                                  });
                                });

                                FocusScope.of(context).unfocus();
                                Navigator.pop(context);
                                pageController.nextPage(
                                    duration: const Duration(milliseconds: 250),
                                    curve: Curves.easeInOut
                                );
                              } else{
                                bottomState(() {
                                  setState(() {
                                    tosButtonText = "필수 약관을 동의해주세요";
                                    tosButtonNextColor = Colors.red;
                                  });
                                });
                              }
                            },
                          ),
                        )
                    )
                  ],
                ),
              )
          );
        },
      );
  }

  Widget _userInformPage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
      child: Column(
        children: [
          const SizedBox(
            width: double.infinity,
            child: Text(
              "사용자 정보를 입력해주세요",
              style: titleLarge,
            ),
          ),
          const SizedBox(
            width: double.infinity,
            child: Text(
              "서비스를 이용할 때 필요합니다",
              style: bodyLargeGray,
            ),
          ),
          SizedBox(
            height: 24,
          ),
          SizedBox(
            width: double.infinity,
            child: Form(
              autovalidateMode: AutovalidateMode.always,
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Text("닉네임 *"),
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "닉네임",
                            hintStyle: headlineSmallGray,
                            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                            errorText: nicknameError,
                          ),
                          textInputAction: TextInputAction.next,
                          controller: nicknameController,
                          style: headlineSmall,
                          validator: nicknameTextFieldValidator,
                          onFieldSubmitted: (String value) {
                            FocusScope.of(context).requestFocus(phoneNumberFocusNode);
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Text("전화번호 *"),
                  ),
                  TextFormField(
                    focusNode: phoneNumberFocusNode,
                    decoration: InputDecoration(
                      hintText: "01012341234",
                      hintStyle: headlineSmallGray,
                      contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      errorText: phoneNumberError,
                    ),
                    textInputAction: TextInputAction.done,
                    controller: phoneNumberController,
                    style: headlineSmall,
                    validator: phoneNumberTextFieldValidator,
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Text("성별 *"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<Sex>(
                      segments: [
                        ButtonSegment<Sex>(
                          value: Sex.male,
                          label: Text("남성"),
                          icon: Icon(Icons.male)
                        ),
                        ButtonSegment<Sex>(
                          value: Sex.female,
                          label: Text("여성"),
                            icon: Icon(Icons.female)
                        ),
                      ],
                      selected: <Sex>{selectedSex},
                      onSelectionChanged: (newValue) {
                        setState(() {
                          selectedSex = newValue.first;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Text("생년월일 *"),
                  ),
                  GestureDetector(
                    onTap: () async {
                      selectedBirth = await showDatePicker(
                          locale: Locale('ko', 'KR'),
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now()
                      );
                      if (selectedBirth != null) {
                        birthController.text = DateFormat('yyyy/MM/dd').format(selectedBirth!);
                      }
                    },
                    child: TextFormField(
                      enabled: false,
                      decoration: InputDecoration(
                          hintText: "yyyy/mm/dd",
                          hintStyle: headlineSmallGray,
                          contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          errorText: birthError
                      ),
                      controller: birthController,
                      style: headlineSmall,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "생년월일을 선택해주세요";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            )
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    passwordController.dispose();
    passwordCheckController.dispose();
    emailController.dispose();
    nicknameController.dispose();
    phoneNumberController.dispose();
    birthController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Platform.isAndroid ? IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: _pressedBack,
        ) : IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: _pressedBack,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  SingleChildScrollView(
                    child: _emailPage(),
                  ),
                  SingleChildScrollView(
                    child: _passwordPage(),
                  ),
                  SingleChildScrollView(
                    child: _userInformPage(),
                  )
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: FilledButton(
                  child: Text("다음"),
                  onPressed: () {
                    setState(() {
                      switch (pageController.page!.toInt()) {
                        case 0: {
                          final email = emailController.text.tr;
                          emailError = emailTextFieldValidator(email);
                          if (emailError == null) {
                            FocusScope.of(context).unfocus();
                            pageController.nextPage(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeInOut
                            );
                          }
                          break;
                        }
                        case 1: {
                          final password = passwordController.text.tr;
                          passwordError = passwordTextFieldValidator(password);
                          if (passwordError == null) {
                            final passwordCheck = passwordCheckController.text.tr;
                            if (password != passwordCheck) {
                              passwordCheckError = "비밀번호가 일치하지 않습니다!";
                            } else {
                              passwordCheckError = null;

                              FocusScope.of(context).unfocus();
                              showModalBottomSheet(
                                constraints: BoxConstraints(
                                  maxWidth: 600
                                ),
                                context: context,
                                builder: (BuildContext context) {
                                  return _tosAgreePage();
                                },
                                enableDrag: false
                              );
                            }
                          }
                          break;
                        }
                        case 2: {
                          if (_formKey.currentState!.validate()) {
                            final email = emailController.text.tr;
                            final password = passwordController.text.tr;
                            final nickname = nicknameController.text.tr;
                            final phoneNumber = phoneNumberController.text.tr;
                            final sex = selectedSex;
                            final birth = birthController.text.tr;

                            FocusScope.of(context).unfocus();
                            AuthController.to.registerEmail(
                                context,
                                emailController.text.tr,
                                passwordController.text.tr
                            );
                          }
                          break;
                        }
                      }
                    });
                  },
                ),
              )
            )
          ],
        )
      ),
    );
  }

  void _pressedBack() {
    if (pageController.page!.toInt() == 0) {
      if (widget.canBack) {
        Navigator.pop(context);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("회원가입 필요"),
              content: Text("${AuthController.to.user.value!.email!} 계정은 회원가입이 완료되지 않았습니다. 현재 계정을 로그아웃 하고 다른 계정으로 로그인 하시겠습니다?"),
              actions: [
                TextButton(
                  onPressed: () {
                    AuthController.to.signOut();
                  },
                  child: Text("로그아웃")
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: Text("회원가입 하기")
                ),
              ],
            );
          },
        );
      }
    } else {
      FocusScope.of(context).unfocus();
      pageController.previousPage(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut
      );
    }
  }
}