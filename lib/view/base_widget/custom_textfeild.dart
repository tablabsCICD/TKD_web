import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/style.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType textInputType;
  final int maxLine;
  final bool isPhoneNumber;
  final bool isValidator;
  final bool isEmail;
  final bool isName;
  final bool isDigits;
  final TextCapitalization capitalization;
  final IconData? iconData;
  final bool? obsecure;
  final bool? readOnly;
  final String? validatorMsg;
  Function? onTap;
  Function? onValueChange;

  CustomTextField(
      {required this.controller,
      required this.hintText,
      required this.textInputType,
      this.maxLine = 1,
      this.validatorMsg,
      this.isPhoneNumber = false,
      this.isValidator = true,
      this.isEmail = false,
      this.isName = false,
      this.isDigits = false,
      this.capitalization = TextCapitalization.none,
      this.iconData,
      this.obsecure,
      this.readOnly,
      this.onTap,
      this.onValueChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 1),
      alignment: Alignment.center,
      // height: 45,
      child: TextFormField(
        onTap: () {
          onTap!();
        },
        onChanged: (vale){
          onValueChange;
        },
        controller: controller,
        inputFormatters: [
          isPhoneNumber
              ? FilteringTextInputFormatter.digitsOnly
              : FilteringTextInputFormatter.singleLineFormatter
        ],
        validator: isPhoneNumber
            ? Validators.compose([
                Validators.required('Phone number is required'),
                Validators.minLength(
                    10, 'Mobile number cannot be less than 10 digit'),
                Validators.maxLength(
                    10, 'Mobile number cannot be greater than 10 digits'),
              ])
            : isEmail
                ? Validators.compose([
                    Validators.required('Email is required'),
                    Validators.email('Invalid email address'),
                  ])
                : isName
                    ? Validators.compose([
                        Validators.patternString(
                            r"^[A-Za-z]+$", 'Only alphabets are allowed'),
                        Validators.required('${hintText} is required'),
                      ])
                    : isDigits
                        ? Validators.compose([
                            Validators.patternRegExp(
                                RegExp(r"^[0-9]*$"), 'Only digits are allowed'),
                            Validators.required('${hintText} is required'),
                          ])
                        : isValidator
                            ? Validators.required('This field is required')
                            : null,
        readOnly: readOnly == null ? false : true,
        decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade100),),
            hintStyle:TextStyle(
              color: Color(0x662C363F),
              fontSize: 14,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w400,
            )
        ),
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.w400,
        ),
        keyboardType:
            textInputType != null ? textInputType : TextInputType.text,
      ),
    );
  }
}
