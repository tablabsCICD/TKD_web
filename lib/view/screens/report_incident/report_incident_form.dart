import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../provider/report_incident_provider.dart';
import '../../../util/colors.dart';
import '../../../util/images.dart';
import '../../../util/style.dart';
import '../../../widgets/base_widgets.dart';
import '../../../widgets/button.dart';
import '../../../widgets/datepicker.dart';
import 'package:flutter/foundation.dart';

class ReportIncidentFormScreen extends StatefulWidget {
  @override
  State<ReportIncidentFormScreen> createState() => _ReportIncidentFormScreenState();
}

class _ReportIncidentFormScreenState extends State<ReportIncidentFormScreen> {
  final List<String> _incidentTypes = [
    "Theft",
    "Fake RTO Documents",
    "Non-existing Company",
    "Vehicle Missing",
    "Driver Missing",
    "Owner Missing",
    "Others (Specify Below)"
  ];

  final List<String> _cheatedByOptions = [
    "Vehicle Owner / Transport Company / Driver",
    "Agent",
    "Manufacturer",
    "Trader",
    "Others (Specify)"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.baground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Report Incident', style: Style.appheading),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWeb = constraints.maxWidth > 600;

          return Center(
            child: Container(
              width: isWeb ? 600 : double.infinity,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  if (isWeb)
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),

                  Expanded(child: _buildForm(context)),
                ],
              ),
            ),
          );
        },
      ),

    );
  }

  String? mobileError;

  String? dateError;

  Widget _buildForm(BuildContext context) {
    final provider = Provider.of<ReportIncidentProvider>(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("Incident Details"),

          _chipSection(
            title: "Incident Type",
            options: _incidentTypes,
            selected: provider.incidentTypes,
            onTap: provider.toggleIncidentType,
          ),

          _chipSection(
            title: "Cheated By",
            options: _cheatedByOptions,
            selected: provider.cheatedByList,
            onTap: provider.toggleCheatedBy,
          ),

          _radioSection(
            title: "Was FIR Launched?",
            groupValue: provider.isFirLaunched,
            onChanged: provider.setFirStatus,
          ),

          _sectionTitle("Basic Information"),

          _label("Contact Number", true),
          TextField(
            controller: provider.phoneController,
            keyboardType: TextInputType.phone,
            onChanged: (value) {
              setState(() {
                if (value.length != 10 || !RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                  mobileError = "Enter a valid 10-digit mobile number";
                } else {
                  mobileError = null;
                }
              });
            },
            decoration: InputDecoration(
              hintText: "Enter contact number",
              errorText: mobileError,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),


          _label("Vehicle Number", true),
          _input(provider.vehicleNo,
              hint: "Enter vehicle number", type: TextInputType.text),

          _label("Date of Incident", true),
          TextField(
            controller: provider.dateController,
            readOnly: true,
            decoration: InputDecoration(
              hintText: "dd/mm/yyyy",
              errorText: dateError,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onTap: () async {
              FocusScope.of(context).unfocus();

              final today = DateTime.now();

              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: today,
                firstDate: DateTime(1950),
                lastDate: today, // ⬅ future disabled
              );

              if (picked != null) {
                // Format for display (dd/MM/yyyy)
                String dd = picked.day.toString().padLeft(2, '0');
                String mm = picked.month.toString().padLeft(2, '0');
                String yyyy = picked.year.toString();

                // UI Format
                provider.dateController.text = "$dd/$mm/$yyyy";

                // API Format (save separately if needed)
                provider.selectedApiDate = "$yyyy-$mm-$dd";

                setState(() {
                  dateError = null;
                });
              }
            },
          ),

          _label("Incident Location"),
          _input(provider.incidentLocation, hint: "Location"),

          _label("Short Incident Description"),
          _input(provider.description, hint: "Write details"),

          _label("Amount Lost / Goods Cheated"),
          _input(provider.amountLost,
              hint: "Amount e.g. 1000", type: TextInputType.number),

          _sectionTitle("Supporting Documents"),

          _proofUploader(provider, context),

          _sectionTitle("Declaration"),

          CheckboxListTile(
            activeColor: ThemeColor.theme_blue,
            value: provider.isAccepted,
            onChanged: (v) => provider.setAccepted(v ?? false),
            title: Text(
              "I confirm that the above information is true and I take full responsibility.",
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: provider.isAccepted ? Colors.green : Colors.black,
              ),
            ),
          ),

          const SizedBox(height: 20),

          Button(
            width: double.infinity,
            height: 48,
            title: "Submit",
            isEnbale: true,
            onClick: () {
              setState(() {
                // Mobile validation
                if (provider.phoneController.text.length != 10) {
                  mobileError = "Enter a valid 10-digit mobile number";
                }

                // Date validation
                if (provider.dateController.text.isEmpty) {
                  dateError = "Please select a date";
                }
              });

              if (mobileError == null && dateError == null) {
                provider.addIncident(context); // will navigate pop inside
              }
            },

            textStyle: const TextStyle(color: Colors.white,fontSize: 16),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // --------------------- UI Helpers ------------------------
  Widget _sectionTitle(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Text(text,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w700,
        )),
  );

  Widget _label(String text, [bool req = false]) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 6),
      child: RichText(
        text: TextSpan(
          text: text,
          style: GoogleFonts.poppins(
              fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black),
          children: req
              ? [
            TextSpan(
                text: " *",
                style: TextStyle(color: ThemeColor.red))
          ]
              : [],
        ),
      ),
    );
  }

  Widget _input(
      TextEditingController controller, {
        String hint = "",
        bool read = false,
        TextInputType type = TextInputType.text,
        Function()? onTap,
      }) {
    return TextField(
      controller: controller,
      readOnly: read,
      onTap: onTap,
      keyboardType: type,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300)),
      ),
    );
  }

  Widget _chipSection({
    required String title,
    required List<String> options,
    required List<String> selected,
    required Function(String) onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(title, true),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((opt) {
            final chosen = selected.contains(opt);
            return ChoiceChip(
              label: Text(opt,
                  style: GoogleFonts.poppins(
                      color: chosen ? Colors.white : Colors.black)),
              selected: chosen,
              selectedColor: ThemeColor.theme_blue,
              backgroundColor: Colors.grey.shade200,
              onSelected: (_) => onTap(opt),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _radioSection({
    required String title,
    required bool? groupValue,
    required Function(bool?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(title),
        Row(
          children: [
            _radioItem("Yes", true, groupValue, onChanged),
            _radioItem("No", false, groupValue, onChanged),
          ],
        )
      ],
    );
  }

  Widget _radioItem(
      String text, bool value, bool? group, Function(bool?) onChanged) {
    return Expanded(
      child: Row(
        children: [
          Radio<bool?>(
            value: value,
            groupValue: group,
            onChanged: onChanged,
          ),
          Text(text)
        ],
      ),
    );
  }

  Widget _proofUploader(ReportIncidentProvider provider, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label("Upload Proof (documents, images)", provider.isFirLaunched == true),

        if (provider.images.isNotEmpty)
          Center(
            child: BaseWidget().carouseImageDelete(context,provider.images, (img) {
              provider.images.remove(img);
              provider.notifyListeners();
            }),
          ),

        const SizedBox(height: 12),

        Center(
          child: InkWell(
            onTap: () => provider.uploadImage(context),
            child: Column(
              children: [
                SvgPicture.asset(Images.add_image, width: 40),
                const SizedBox(height: 6),
                Text("Upload Images",
                    style: GoogleFonts.poppins(
                        fontSize: 12, fontWeight: FontWeight.w600))
              ],
            ),
          ),
        ),
      ],
    );
  }
}
