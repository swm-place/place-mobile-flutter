import 'package:flutter/material.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';
import 'package:place_mobile_flutter/widget/tag/tag_chip.dart';

class RoundedRectanglePlaceCard extends StatelessWidget {
  RoundedRectanglePlaceCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 177,
      height: 153,
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        surfaceTintColor: Colors.white,
        child: GestureDetector(
          onTap: () {
            print("card click");
          },
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        child: Image.network("https://images.unsplash.com/photo-1495567720989-cebdbdd97913?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2370&q=80", fit: BoxFit.fill,),
                      ),
                      // Container(
                      //   width: double.infinity,
                      //   color: const Color.fromARGB(102, 1, 1, 1),
                      // )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "소마카페",
                            style: placeCardTitle,
                          ),
                          Text(
                            "카페",
                            style: placeCardCategory,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          TagChip()
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  
}