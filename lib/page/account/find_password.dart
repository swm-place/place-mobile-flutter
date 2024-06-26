import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:place_mobile_flutter/state/auth_controller.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';
import 'package:place_mobile_flutter/util/validator.dart';

class FindPasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FindPasswordPageState();
  }
}

class FindPasswordPageState extends State<FindPasswordPage> {
  String? emailError;

  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  "비밀번호 재설정",
                  style: PageTextStyle.titleLarge(),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Text(
                  "비밀번호 재설정 이메일에서 링크를 클릭해주세요",
                  style: PageTextStyle.bodyLarge(Colors.black54),
                ),
              ),
              Expanded(
                child: SizedBox(
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
                      hintStyle: PageTextStyle.headlineSmall(Colors.grey[700]!),
                      errorText: emailError,
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    style: PageTextStyle.headlineSmall(Colors.black),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  child: Text("재설정 메일 전송"),
                  onPressed: () {
                    setState(() {
                      String? email = emailController.text.tr;
                      emailError = emailTextFieldValidator(email);
                      if (emailError == null) {
                        AuthController.to.resetPassword(email);
                      }
                    });
                  },
                )
              )
            ],
          ),
        )
      ),
    );
  }
}