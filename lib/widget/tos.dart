import 'package:flutter/material.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';

class CheckTos extends StatefulWidget {
  CheckTos({
    Key? key,
    required this.tosText,
    required this.require
  }) : super(key: key);

  String tosText = "";
  bool require = false;

  @override
  State<StatefulWidget> createState() {
    return CheckTosState();
  }
}

class CheckTosState extends State<CheckTos> {
  bool _tosAgree = false;

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
                        color: _tosAgree ? Colors.blue : null,
                      ),
                    ),
                  ),
                  Text(
                    "${widget.require ? "(필수)" : "(선택)"}${widget.tosText}",
                    style: labelLarge,
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  _tosAgree = !_tosAgree;
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

        // Expanded(
          // child: CheckboxListTile(
          //   contentPadding: EdgeInsets.zero,
          //   value: _tosAgree,
          //   title: Text("${widget.require ? "(필수)" : "(선택)"}${widget.tosText}"),
          //   onChanged: (value) {
          //     setState(() {
          //       _tosAgree = value!;
          //     });
          //   },
          //   controlAffinity: ListTileControlAffinity.leading,
          // ),
        // ),
        // IconButton(
        //   onPressed: () {},
        //   icon: Icon(Icons.arrow_forward_ios_rounded)
        // )
    //   ],
    // );
  }
}