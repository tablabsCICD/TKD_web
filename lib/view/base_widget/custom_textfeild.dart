import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'dart:async';


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
  final bool obsecure;
  final bool readOnly;
  final bool isMandatory;
  final String? validatorMsg;
  final FutureOr<void> Function()? onTap;

  final Function(String)? onValueChange;

  const CustomTextField({
    Key? key,
    required this.controller,
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
    this.obsecure = false,
    this.readOnly = false,
    this.isMandatory = false,
    this.onTap,
    this.onValueChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        obscureText: obsecure,
        maxLines: maxLine,
        textCapitalization: capitalization,

        onTap: () {
          if (onTap != null) {
            final result = onTap!();   // works for sync + async
            if (result is Future) {
              result.catchError((e) {
                // optional error handling
              });
            }
          }
        },

        onChanged: (val) {
          if (onValueChange != null) {
            onValueChange!(val);
          }
        },

        inputFormatters: [
          if (isPhoneNumber || isDigits)
            FilteringTextInputFormatter.digitsOnly
          else
            FilteringTextInputFormatter.singleLineFormatter,
        ],

        validator: _buildValidator(),

        decoration: InputDecoration(
          labelText: hintText,                                // 🌟 floating label
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          filled: true,
          fillColor: Colors.white,

          hintText: null,                                     // no hint needed now
          prefixIcon: iconData != null ? Icon(iconData) : null,

          labelStyle: TextStyle(
            color: Colors.grey.shade700,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),

          // Borders
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black54)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black54)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
              BorderSide(color: Theme.of(context).primaryColor, width: 1.5)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red)),
        ),

        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.w400,
        ),

        keyboardType: textInputType,
      ),
    );
  }

  /// VALIDATION LOGIC CLEANED + COMBINED
  String? Function(String?)? _buildValidator() {
    if (!isValidator) return null;

    if (isPhoneNumber) {
      return Validators.compose([
        Validators.required('Phone number is required'),
        Validators.minLength(10, 'Mobile must be 10 digits'),
        Validators.maxLength(10, 'Mobile must be 10 digits'),
      ]);
    }

    if (isEmail) {
      return Validators.compose([
        Validators.required('Email is required'),
        Validators.email('Invalid email'),
      ]);
    }

    if (isName) {
      return Validators.compose([
        Validators.patternString(r"^[A-Za-z ]+$", 'Only alphabets allowed'),
        Validators.required('$hintText is required'),
      ]);
    }

    if (isDigits) {
      return Validators.compose([
        Validators.patternRegExp(RegExp(r"^[0-9]*$"), 'Only digits allowed'),
        Validators.required('$hintText is required'),
      ]);
    }

    return Validators.required(validatorMsg ?? "This field is required");
  }
}
