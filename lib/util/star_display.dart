import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
class StarDisplay extends StatelessWidget {
  final double value;
  const StarDisplay({Key? key, this.value = 0})
      : assert(value != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      itemSize: 10,
      initialRating: value,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      ignoreGestures: true,
      itemPadding: EdgeInsets.symmetric(
          horizontal: 1.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber,
        size: 5,
      ),
      onRatingUpdate: (rating) {
        print(rating);
      },
    );
  }
}