import 'package:flutter/material.dart';

class PreferenceListSection extends StatelessWidget {
  PreferenceListSection({
    required this.children,
    Key? key,
  }) : super(key: key);

  List<Widget> children;

  List<Widget> _createItems() {
    List<Widget> pref = [];
    for (int i = 0;i < children.length;i++) {
      pref.add(children[i]);
      if (i != children.length - 1) {
        pref.add(Divider(height: 1, color: Colors.grey[350]));
      }
    }
    return pref;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // SizedBox(height: 10,),
        Padding(
          padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              color: Colors.grey[200],
              child: Column(
                children: _createItems()
              ),
            ),
          ),
        )
      ],
    );
  }
}