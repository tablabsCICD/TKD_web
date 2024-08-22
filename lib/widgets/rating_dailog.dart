import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tkd_app/model/truck_load_model.dart';
import 'package:tkd_app/provider/rating_provider.dart';
import 'package:tkd_app/util/images.dart';
import 'package:tkd_app/util/rating_star.dart';
import 'package:tkd_app/view/base_widget/app_constant.dart';
import 'package:tkd_app/widgets/button.dart';

class RatingDialog extends StatefulWidget {
  TruckLoad? load;

  RatingDialog(this.load);

  @override
  _RatingDialogState createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => RatingProvider(),
      builder: (context, child) => _buildPage(context),
    );
  }

  _buildPage(BuildContext context) {
    return Scaffold(
      body: Consumer<RatingProvider>(
          builder: (context, provider, child) => Padding(
                padding: const EdgeInsets.all(25.0),
                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rating and Review',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: AppConstant.FONTFAMILY,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: SvgPicture.asset(Images.close_circle))
                      ],
                    ),
                    SizedBox(height: 25),
                    Text(
                      widget.load!.companyName.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: AppConstant.FONTFAMILY,
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'How would you rate this Company?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontFamily: AppConstant.FONTFAMILY,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 20),
                    StarRating(
                        rating: provider.rating,
                        onRatingChanged: (rating) =>
                            provider.changeRating(rating)),
                    SizedBox(height: 20),
                    TextField(
                      controller: provider.commentController,
                      decoration: InputDecoration(
                        hintText: 'Write your review...',
                        hintStyle: TextStyle(
                          color: Colors.black38,
                          fontSize: 13,
                          fontFamily: AppConstant.FONTFAMILY,
                          fontWeight: FontWeight.w500,
                        ),
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      onChanged: (val) {
                        if (val == 0) {
                          provider.buttonEnable = false;
                        } else {
                          provider.buttonEnable = true;
                        }
                        provider.callSetState();
                      },
                    ),
                  ],
                ),
              )),
      bottomNavigationBar: Consumer<RatingProvider>(
        builder: (context, provider, child) => Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Button(
            width: 327,
            height: 49,
            title: "Submit",
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: AppConstant.FONTFAMILY,
              fontWeight: FontWeight.w600,
              height: 0,
            ),
            onClick: () {
              print('Rating: ${provider.rating}');
              provider.postRatingRaviews(context, widget.load);
              Navigator.of(context).pop();
            },
            isEnbale: provider.buttonEnable,
          ),
        ),
      ),
    );
  }
}
