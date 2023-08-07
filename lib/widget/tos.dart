import 'package:flutter/material.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';

class CheckTos extends StatefulWidget {
  CheckTos({
    Key? key,
    required this.tosText,
    required this.tosContent,
    required this.require,
    required this.callback,
    required this.agreeValue,
  }) : super(key: key);

  String tosText = "";
  String tosContent = "";
  bool require = false;
  bool agreeValue = false;
  final Function(bool val) callback;

  @override
  State<StatefulWidget> createState() {
    return CheckTosState();
  }
}

class CheckTosState extends State<CheckTos> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 4),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: Icon(
                        Icons.check,
                        color: widget.agreeValue ? Colors.blue : null,
                      ),
                    ),
                  ),
                  Text(
                    "${widget.require ? "(필수)" : "(선택)"}${widget.tosText}",
                    style: SectionTextStyle.labelMedium(Colors.black),
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  widget.agreeValue = !widget.agreeValue;
                  widget.callback(widget.agreeValue);
                });
              },
            ),
          ),
          SizedBox(
            width: 24,
            height: 24,
            child: IconButton(
              padding: EdgeInsets.zero,
                onPressed: () {
                  Get.to(() => TosContentPage(content: widget.tosContent, title: widget.tosText,));
                },
                icon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                )
            ),
          )
        ],
      )
    );
  }
}

class TosContentPage extends StatelessWidget {
  TosContentPage({
    Key? key,
    required this.content,
    required this.title,
  }) : super(key: key);

  String content = "";
  String title = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title),),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
            child: Text(content),
          ),
        ),
      ),
    );
  }
}