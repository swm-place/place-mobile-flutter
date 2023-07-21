import 'package:flutter/material.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return SignUpPageState();
  }
}

class SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
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
            ],
          ),
        )
      ),
    );
  }
}