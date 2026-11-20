import 'package:flutter/material.dart';


import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/view/base_widget/custom_textfeild.dart';

import '../../../provider/news_provider.dart';
import '../../../util/images.dart';
import '../../../util/style.dart';
import '../../../widgets/base_widgets.dart';
import '../../../widgets/button.dart';

class AddNewsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<NewsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Add News', style: Style.appheading),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              labelText("News Title",isMandatory: true),
              SizedBox(
                height: 4,
              ),
              editViewError(
                  "enter title", provider.topicController, provider, true),
              SizedBox(
                height: 12,
              ),
              labelText("Description"),
              SizedBox(
                height: 4,
              ),
              editViewError("short description", provider.descriptionController,
                  provider, true),
              SizedBox(
                height: 12,
              ),
              labelText("News Link"),
              SizedBox(
                height: 4,
              ),
              editViewError(
                  "youtube link/google link", provider.linkController, provider, true),
              SizedBox(
                height: 12,
              ),
              _buildProofUploader(provider, context),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Button(
                  width: MediaQuery.of(context).size.width,
                  height: 49,
                  title: "Add News",
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w600,
                  ),
                  onClick: () {
                     provider.createPost(context);
                  },
                  isEnbale: true,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildProofUploader(
      NewsProvider provider, BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          labelText("Upload Photo",isMandatory: true),
          provider.images.isNotEmpty
              ? BaseWidget().carouseImageDelete(context,provider.images, (item) {
            provider.images.remove(item);
            provider.notifyListeners();
          })
              : const SizedBox(),
          SizedBox(
            height: 16,
          ),
          InkWell(
              onTap: () {
                provider.uploadImage(context);
              },
              child: SvgPicture.asset(Images.add_image)),
          Text(
            "Upload Images",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF001E49),
              fontSize: 12,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }


  labelText(String label, {bool isMandatory = false}) {
    return SizedBox(
      width: 332,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.w400,
              ),
              children: isMandatory
                  ? [
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: ColorResources.PRIMARY_COLOR,
                    fontSize: 12,
                  ),
                ),
              ]
                  : [],
            ),
          ),
        ],
      ),
    );
  }
  editViewError(String hint, TextEditingController controller,
      NewsProvider provider, bool valid) {
    return CustomTextField(
     textInputType: TextInputType.text,
      hintText: hint,
      controller: controller,
      onTap: () {
        provider.enble();
      },
    );
  }
}
