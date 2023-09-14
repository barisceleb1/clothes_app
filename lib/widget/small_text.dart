import 'package:clothes_app/utils/dimensions.dart';
import 'package:flutter/material.dart';

class SmallText extends StatelessWidget {
  TextOverflow overflow;
  final Color? color;
  final String text;
  double size;
  double height;

  SmallText({Key? key, this.color= const Color(0x8A000000), required this.text, this.size=12, this.height=0, this.overflow= TextOverflow.ellipsis}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.w400,
        fontSize: size==0? Dimensions.font20: size,

      ),

    );
  }
}
