import 'package:clothes_app/utils/dimensions.dart';
import 'package:flutter/material.dart';

class SmallText extends StatelessWidget {
  TextOverflow overflow;
  final Color? color;
  final String text;
  double size;
  double height;
  int maxLines;
  FontWeight weight;
  dynamic textAlign;

  SmallText({Key? key, this.color= const Color(0xFFF44336), required this.text, this.size=12, this.height=0, this.overflow= TextOverflow.ellipsis,
    this.maxLines=150,this.weight=FontWeight.normal,this.textAlign}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontWeight: weight,
        fontSize: size==0? Dimensions.font20: size,

      ),

    );
  }
}
