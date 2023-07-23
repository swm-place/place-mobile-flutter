import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:place_mobile_flutter/theme/color_schemes.g.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';
import 'package:place_mobile_flutter/util/validator.dart';
import 'package:place_mobile_flutter/widget/tos.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return SignUpPageState();
  }
}

enum Sex {male, female}

class SignUpPageState extends State<SignUpPage> {
  final PageController pageController = PageController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordCheckController = TextEditingController();

  final nicknameController = TextEditingController();
  final phoneNumberController = TextEditingController();

  var hidePassword = true;

  var emailError;
  var passwordError;
  var passwordCheckError;

  var nicknameCheckError;
  var phoneNumberCheckError;
  var pageIdx = 0;

  var tosButtonText = "다음";
  var tosButtonNextColor = lightColorScheme.primary;

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

  Sex selected = Sex.male;

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
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: TextField(
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
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text("닉네임 *"),
                  ),
                  TextFormField(
                    onChanged: (text) {
                      setState(() {
                        nicknameCheckError = nicknameTextFieldValidator(text.tr);
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "닉네임",
                      hintStyle: headlineSmallGray,
                      contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      errorText: nicknameCheckError,
                    ),
                    textInputAction: TextInputAction.next,
                    controller: nicknameController,
                    style: headlineSmall,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 24,
            ),
            SizedBox(
              width: double.infinity,
              child: Form(
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text("전화번호 *"),
                    ),
                    TextFormField(
                      onChanged: (text) {
                        setState(() {
                          phoneNumberCheckError = phoneNumberTextFieldValidator(text.tr);
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "01012341234",
                        hintStyle: headlineSmallGray,
                        contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        errorText: phoneNumberCheckError,
                      ),
                      textInputAction: TextInputAction.done,
                      controller: phoneNumberController,
                      style: headlineSmall,
                    ),
                  ],
                ),
              )
            ),
            SizedBox(
              height: 24,
            ),
            SizedBox(
                width: double.infinity,
                child: Form(
                  child: Column(
                    children: [
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
                                label: Text("남성")
                            ),
                            ButtonSegment<Sex>(
                                value: Sex.female,
                                label: Text("여성")
                            ),
                          ],
                          selected: <Sex>{selected},
                          onSelectionChanged: (newValue) {
                            setState(() {
                              selected = newValue.first;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      SizedBox(
                          width: double.infinity,
                          child: Form(
                            child: Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Text("생년월일 *"),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    final DateTime? selected = await showDatePicker(
                                      locale: Locale('ko', 'KR'),
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime.now()
                                    );
                                    print(selected);
                                  },
                                  child: TextFormField(
                                    enabled: false,
                                    onChanged: (text) {

                                    },
                                    decoration: InputDecoration(
                                        hintText: "010-0000-0000",
                                        hintStyle: headlineSmallGray,
                                        contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 10)
                                      // errorText: passwordCheckError,
                                    ),
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.phone,
                                    // controller: passwordCheckController,
                                    style: headlineSmall,
                                  ),
                                ),
                              ],
                            ),
                          )
                      ),
                    ],
                  ),
                )
            )
          ],
        ),
      );
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
      Navigator.pop(context);
    } else {
      pageController.previousPage(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut
      );
    }
  }
}