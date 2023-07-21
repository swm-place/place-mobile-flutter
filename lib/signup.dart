import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:place_mobile_flutter/theme/color_schemes.g.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';
import 'package:place_mobile_flutter/util/validator.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return SignUpPageState();
  }
}

class SignUpPageState extends State<SignUpPage> {
  final PageController pageController = PageController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordCheckController = TextEditingController();

  var hidePassword = true;

  var emailError;
  var passwordError;
  var passwordCheckError;
  var pageIdx = 0;

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
                  _emailPage(),
                  _passwordPage()
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