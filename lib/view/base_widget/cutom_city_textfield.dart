import 'package:flutter/material.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/style.dart';

class CustomCityTextField extends StatelessWidget {
  final String value;               // city text (string)
  final String label;               // floating label
  final bool isFromProfile;
  final VoidCallback? onTap;

  const CustomCityTextField({
    Key? key,
    required this.value,
    required this.label,
    this.onTap,
    this.isFromProfile = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: value);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

      child: InkWell(
        onTap: onTap,

        child: IgnorePointer( // prevents keyboard but allows tap
          child: TextFormField(
            controller: controller,
            readOnly: true,
            style: Style.dropdownValue,

            validator: (v) {
              if (v == null || v.isEmpty) return "This field is required";
              return null;
            },

            decoration: InputDecoration(
              labelText: label,                          // ⭐ FLOATING LABEL
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              filled: true,
              fillColor: ColorResources.WHITE,

              suffixIcon: const Icon(
                Icons.arrow_drop_down_outlined,
                size: 26,
                color: Colors.black54,
              ),

              labelStyle: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
              ),

              // Borders
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.black54),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.black54),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                BorderSide(color: Theme.of(context).primaryColor, width: 1.4),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
