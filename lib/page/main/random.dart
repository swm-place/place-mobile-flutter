import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RandomPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RandomPageState();
  }
}

class RandomPageState extends State<RandomPage> with AutomaticKeepAliveClientMixin<RandomPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: Text('Random'),
      ),
    );
  }
}