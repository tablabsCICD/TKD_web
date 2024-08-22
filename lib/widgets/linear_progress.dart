import 'package:flutter/cupertino.dart';
import 'package:tkd_app/util/colors.dart';

class LinearProgressBar extends StatelessWidget {
  final double fillValue;

  const LinearProgressBar({required this.fillValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 335,
      height: 6,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 335,
              height: 6,
              decoration: ShapeDecoration(
                color: Color(0x4CB7B7B7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: fillValue,
              height: 6,
              decoration: ShapeDecoration(
                color: ThemeColor.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
