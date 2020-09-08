import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SquareBoxWidget extends StatelessWidget {

  String name;
  String imageUrl;
  Function onPress;
  bool isLocalImage;

  SquareBoxWidget({Key key, @required this.name, @required this.imageUrl, this.onPress, this.isLocalImage = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(child: Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black)),
      child: Stack(
        children: [
          this.isLocalImage ?  Image.asset(imageUrl) : Image.network(imageUrl),
          Positioned(
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            bottom: 10,
            left: 0,
            right: 0,
          )
        ],
      ),
    ),
    onTap: onPress,
    );
  }

}