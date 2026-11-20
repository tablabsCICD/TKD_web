import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:tkd_app/util/style.dart';

class CustomDropdownList extends StatelessWidget {
  final String hintText;                      // 🔥 floating label
  final String? selectedType;
  final List<String> items;
  final TextInputType? textInputType;
  final bool readOnly;
  final Function(String) onChange;
  final VoidCallback? onTap;

  const CustomDropdownList({
    Key? key,
    required this.hintText,
    required this.selectedType,
    required this.items,
    required this.onChange,
    this.textInputType,
    this.readOnly = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: readOnly, // Disable dropdown when readOnly
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

          child: DropdownButtonFormField<String>(
            value: selectedType!.isEmpty ? null : selectedType,

            decoration: InputDecoration(
              labelText: hintText,
              filled: true,                    // ⭐ Required
              fillColor: Colors.white,         // ⭐ Background becomes white
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
            ),

            items: items
                .map((value) => DropdownMenuItem(
              value: value,
              child: Text(
                value,
                style: Style.dropdownValue,
              ),
            ))
                .toList(),

            onChanged: (val) {
              if (!readOnly && val != null) {
                onChange(val);
              }
            },
          ),
        ),
      ),
    );
  }
}
