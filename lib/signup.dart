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
  final emailController = TextEditingController();
  var emailError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
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
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  child: Text("다음"),
                  onPressed: () {
                    setState(() {
                      final email = emailController.text.tr;
                      emailError = emailTextFieldValidator(email);
                      print('$email $emailError');
                      if (emailError == null) {

                      }
                    });
                  },
                ),
              )
            ],
          )
        )
      ),
    );
  }
}