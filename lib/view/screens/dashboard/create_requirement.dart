import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tkd_app/dialog/CustomCityListDialog.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/postLoad.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/dashboard_provider.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/custom_button.dart';
import 'package:tkd_app/view/screens/dashboard/show_option_dropdown.dart';

import '../../base_widget/cutom_city_textfield.dart';

class CreateRequirement extends StatefulWidget {
  final String postType;
  CreateRequirement(this.postType, {Key? key}) : super(key: key);

  @override
  _CreateRequirementState createState() => _CreateRequirementState();
}

class _CreateRequirementState extends State<CreateRequirement> {
  final authProvider = locator<AuthProvider>();
  final DashboardProvider provider = locator<DashboardProvider>();

  final _formKey = GlobalKey<FormState>();

  // Selects & lists
  String selectedRequirementType = '';
  String selectedPostType = '';
  String selectedCargoType = '';
  String selectedTypeOfPayment = 'Immediate';
  String selectedFromCity = '';
  String selectedToCity = '';
  String selectedSI = "";

  final List<String> requirementList = <String>['I Want Vehicle', 'I Have Vehicle'];
  final List<String> itemList = <String>['Full Load', 'Part Load'];
  final List<String> cargoList = <String>['Wooden Case','Cartons','Drums','Gunny Bags','Machinery','Other'];
  final List<String> paymentList = <String>['Immediate','Fortnight','Weekly','Others'];
  List<String> specialInstructionList = [
    'Double Delivery',
    'Express Delivery',
    'Loading From Multiple Places',
    'Unloading At Multiple Place ',
    "Give Rate Inclusive Of Loading Hamali",
    'Give Rate Inclusive Of Unloading Hamali',
    'Others',
    'None'
  ];
  // Controllers
  final TextEditingController _vehicleSizeController = TextEditingController();
  final TextEditingController _loadWeightController = TextEditingController();
  final TextEditingController _expireDateController = TextEditingController();
  final TextEditingController _showToController = TextEditingController();

  // switches / misc
  bool identitySwitch = false;
  bool disturbSwitch = false;
  List<int> userIdList = [];

  // date
  DateTime _selectedDate = DateTime.now();

  // loading state
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    selectedPostType = widget.postType;
    _showToController.text = "All Users";
  }

  @override
  void dispose() {
    _vehicleSizeController.dispose();
    _loadWeightController.dispose();
    _expireDateController.dispose();
    _showToController.dispose();
    super.dispose();
  }

  Future<void> _pickExpiryDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _expireDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }






  Future<void> _openShowToDialog() async {
    final List<int>? res = await showDialog<List<int>>(
      context: context,
      builder: (ctx) => ShowOptionDropDown(selectedFromCity),
    );
    if (res != null) {    setState(() {







        userIdList = res;
        _showToController.text = userIdList.isEmpty ? "All Users" : "Groups";
      });
    }
  }

  Future<void> _submit(DashboardProvider model) async {
    if (_isSubmitting) return;

    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please fill required fields')));
      return;
    }

    // ensure list is always valid
    final safeSelectedUserList = (userIdList is List) ? userIdList : <int>[];

    // ensure city values are not null
    final safeFromCity = selectedFromCity.isEmpty ? "" : selectedFromCity;
    final safeToCity   = selectedToCity.isEmpty ? "" : selectedToCity;

    setState(() => _isSubmitting = true);
    bool success = false;
    PostLoad postLoad = PostLoad();
    postLoad.contactNumber = authProvider.userDetailList[0].mobileNumber ?? 0;
    postLoad.destination = safeToCity ?? "";
    postLoad.dnd = disturbSwitch ? 1 : 0;
    postLoad.emailId = authProvider.userDetailList[0].emailId ?? "";
    postLoad.fullLoadChoice = selectedRequirementType ?? "";
    postLoad.instructions = selectedSI ?? "";
    postLoad.loadWeight = _loadWeightController.text ?? "";
    postLoad.loggedUserName = authProvider.userDetailList[0].loggedUserName ?? "";
    postLoad.mainTag = selectedPostType ?? "";
    postLoad.os = "Web";
    postLoad.otherDetails = selectedSI ?? "";
    postLoad.source = safeFromCity ?? "";
    postLoad.partLoad = selectedPostType == 'Part Load' ? 1 : 0;
    postLoad.privatePost = identitySwitch ? 1 : 0;
    postLoad.rating = 0.0;
    postLoad.transporterOrCustomerName = '${authProvider.userDetailList[0].firstName} ${authProvider.userDetailList[0].lastName}';
    postLoad.type = selectedPostType;
    postLoad.typeOfCargo = selectedCargoType;
    postLoad.typeOfPayment = selectedTypeOfPayment;
    postLoad.vehicleSize = _vehicleSizeController.text;
    postLoad.expireDate = _expireDateController.text ?? "";
    postLoad.tableName = "Full Load";
    postLoad.topicName = "Full Load Truck";
    postLoad.image = "";
    postLoad.isRepeat = 0;
    postLoad.repeatStartDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    postLoad.repeatEndDate = "";
    postLoad.listOfUserIds = safeSelectedUserList;
    postLoad.id = 0;

    try {
      success = await model.savePost(
        context,postLoad);

      if (success == true) {
        // Refresh list
        await model.getFullLoadTruckList("From", "To");
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Icon(Icons.check_circle, color: Colors.green, size: 48),
            content: const Text('Your post submitted successfully.'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('OK')),
            ],
          ),
        );
        // Close screen
        Navigator.pop(context, true);
      } else {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Icon(Icons.error, color: Colors.red, size: 48),
            content: const Text('Failed to submit the post. Please try again later.'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('OK')),
            ],
          ),
        );
        // Close screen
        Navigator.pop(context, false);
      }
    } catch (e) {
      debugPrint('Save post error: $e');

      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Icon(Icons.error, color: Colors.red, size: 48),
          content: Text('Unexpected error: $e'),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('OK')),
          ],
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }


  // small helper widget for floating text field
  Widget _floatingTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    int maxLines = 1,
    VoidCallback? onTap,
    bool digitsOnly = false,
    bool isValidator = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        maxLines: maxLines,
        onTap: onTap,
        inputFormatters: digitsOnly ? [FilteringTextInputFormatter.digitsOnly] : null,
        validator: (val) {
          if (!isValidator) return null;
          if ((val == null || val.trim().isEmpty) && !readOnly) return '$label is required';
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  // small helper for floating dropdown
  Widget _floatingDropdown({
    required String label,
    required List<String> items,
    required String value,
    required ValueChanged<String?> onChanged,
    bool isRequired = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: DropdownButtonFormField<String>(
        value: value.isEmpty ? null : value,
        decoration: InputDecoration(
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        items: items.map((it) => DropdownMenuItem(value: it, child: Text(it))).toList(),
        onChanged: onChanged,
        validator: (v) {
          if (!isRequired) return null;
          if (v == null || v.isEmpty) return 'Please select $label';
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: ColorResources.HOME_BG ?? Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text('Post load/vehicle requirement', style: Style.appheading),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Info text
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Text(
                        'Requirement you post will be visible on the general board to vendors whose routes match to yours.',
                        style: Style.appsubtitle,
                      ),
                    ),

                    // Select Requirement
                    _floatingDropdown(
                      label: 'Select Requirement',
                      items: requirementList,
                      value: selectedRequirementType,
                      onChanged: (v) => setState(() => selectedRequirementType = v ?? ''),
                    ),

                    // Post Type
                    _floatingDropdown(
                      label: 'Select Post Type',
                      items: itemList,
                      value: selectedPostType,
                      onChanged: (v) => setState(() => selectedPostType = v ?? ''),
                    ),

                    // From / To cities (tap to open)
                    CustomCityTextField(
                      label: 'Select City From',
                      value: selectedFromCity,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => CustomCityListDialog(
                            onTap: (value) => setState(() => selectedFromCity = value),
                          ),
                        );
                      },
                    ),

                    CustomCityTextField(
                      label: 'Select City To',
                      value: selectedToCity,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => CustomCityListDialog(
                            onTap: (value) => setState(() => selectedToCity = value),
                          ),
                        );
                      },
                    ),
                                     // Cargo type
                    _floatingDropdown(
                      label: 'Select Cargo Type',
                      items: cargoList,
                      value: selectedCargoType,
                      onChanged: (v) => setState(() => selectedCargoType = v ?? ''),
                    ),

                    // Vehicle size, load weight, instruction
                    _floatingTextField(label: 'Vehicle Size', controller: _vehicleSizeController),
                    _floatingTextField(label: 'Load Weight (In Tons)', controller: _loadWeightController, keyboardType: TextInputType.number),
                  //  _floatingTextField(label: 'Special Instruction', controller: _instructionController, maxLines: 3, isValidator: false),
                    _floatingDropdown(
                      label: 'Select Special Instruction',
                      items: specialInstructionList,
                      value: selectedSI,
                      onChanged: (v) => setState(() => selectedSI = v ?? ''),
                    ),

                    // Mobile & Email (read only)
                    _floatingTextField(
                      label: 'Mobile',
                      controller: TextEditingController(text: authProvider.userDetailList[0].mobileNumber.toString()),
                      keyboardType: TextInputType.phone,
                      readOnly: true,
                    ),
                    _floatingTextField(
                      label: 'Email',
                      controller: TextEditingController(text: authProvider.userDetailList[0].emailId ?? ''),
                      keyboardType: TextInputType.emailAddress,
                      readOnly: true,
                    ),

                    // Payment Type
                    _floatingDropdown(
                      label: 'Select Type Of Payment',
                      items: paymentList,
                      value: selectedTypeOfPayment,
                      onChanged: (v) => setState(() => selectedTypeOfPayment = v ?? selectedTypeOfPayment),
                      isRequired: false,
                    ),

                    // Expiry date (date picker)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: TextFormField(
                        controller: _expireDateController,
                        readOnly: true,
                        onTap: _pickExpiryDate,
                        decoration: InputDecoration(
                          labelText: 'Post Expiry Date (YYYY-MM-DD)',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                      ),
                    ),

                    // Show Post To (open selection dialog)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: TextFormField(
                        controller: _showToController,
                        readOnly: true,
                        onTap: _openShowToDialog,
                        decoration: InputDecoration(
                          labelText: 'Show Post To',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          suffixIcon: const Icon(Icons.group),
                        ),
                      ),
                    ),

                    // switches: identity & disturb
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Hide my identity', style: Style.heading1),
                          FlutterSwitch(
                            showOnOff: true,
                            valueFontSize: 12,
                            activeColor: ColorResources.PRIMARY_COLOR,
                            activeTextColor: Colors.black,
                            inactiveTextColor: Colors.red,
                            value: identitySwitch,
                            onToggle: (val) => setState(() => identitySwitch = val),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Do Not Disturb', style: Style.heading1),
                          FlutterSwitch(
                            showOnOff: true,
                            valueFontSize: 12,
                            activeColor: ColorResources.PRIMARY_COLOR,
                            activeTextColor: Colors.black,
                            inactiveTextColor: Colors.red,
                            value: disturbSwitch,
                            onToggle: (val) => setState(() => disturbSwitch = val),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // submit button / loading
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: model.isLoading || _isSubmitting
                          ? const Center(child: CircularProgressIndicator())
                          : CustomButton(
                        onTap: () => _submit(model),
                        buttonText: 'Post Load',
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
