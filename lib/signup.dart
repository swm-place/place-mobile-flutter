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
  var emailError;
  var pageIdx = 0;

  Widget _emailPage() {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            child: Text(
              "이메일을 입력해주세요",
              style: titleLarge,
            ),
          ),
          Container(
            width: double.infinity,
            child: Text(
              "로그인에 필요합니다",
              style: bodyLargeGray,
            ),
          ),
          Container(
            width: double.infinity,
            child: TextField(
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
      padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
      child: Column(
        children: [
          Text("password")
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