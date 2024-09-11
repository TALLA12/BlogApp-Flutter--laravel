import 'package:flutter/material.dart';

class LikeAndComment extends StatelessWidget {
  final int? value;
  final IconData? icon;
  final Color? color;
  final Function()? onTap;

  LikeAndComment({
    Key? key,
    this.value,
    this.icon,
    this.color,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: color,
                ),
                SizedBox(
                  width: 4,
                ),
                Text('$value'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
