import 'package:flutter/material.dart';

class PlaceDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PlaceDetailPageState();
  }
}

class _PlaceDetailPageState extends State<PlaceDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Text("place_detail"),
      ),
    );
  }
}
