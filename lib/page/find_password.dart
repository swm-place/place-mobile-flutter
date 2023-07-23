import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';

class FindPasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FindPasswordPageState();
  }
}

class FindPasswordPageState extends State<FindPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            children: [
              const SizedBox(
                width: double.infinity,
                child: Text(
                  "비밀번호 재설정",
                  style: titleLarge,
                ),
              ),
              const SizedBox(
                width: double.infinity,
                child: Text(
                  "비밀번호 재설정 이메일에서 링크를 클릭해주세요",
                  style: bodyLargeGray,
                ),
              ),
              SizedBox(
                height: 24,
              ),
            ],
          ),
        )
      ),
    );
  }
}