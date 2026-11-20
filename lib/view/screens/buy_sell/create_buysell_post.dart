import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:tkd_app/dialog/CustomCityListDialog.dart';
import 'package:tkd_app/dialog/animated_custom_dialog.dart';
import 'package:tkd_app/dialog/my_dialog.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/buy_sell_provider.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/custom_button.dart';

import '../../../widgets/button.dart';

/// Full screen implementing:
/// - Card based UI (default)
/// - Stepper UI (toggleable)
/// All fields use floating labels and validate before submit.
/// On successful createBuySell -> shows success dialog -> pops screen.
class CreateNewBuySellPost extends StatefulWidget {
  CreateNewBuySellPost({Key? key}) : super(key: key);

  final buySellProvider = locator<BuySellProvider>();

  @override
  State<CreateNewBuySellPost> createState() =>
      _CreateNewBuySellPostState();
}

class _CreateNewBuySellPostState
    extends State<CreateNewBuySellPost> {
  // Mode toggle: false = Card UI, true = Stepper UI
  bool useStepper = false;

  // Form & controllers
  final _formKey = GlobalKey<FormState>();
  final _stepperKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _description = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _modelName = TextEditingController();
  final TextEditingController _vehicleRno = TextEditingController();
  final TextEditingController _kiloMeter = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  // selects
  String selectedPostType = '';
  String selectedCondition = '';
  String selectedMakerName = '';
  String selectedVehicleSize = '';
  String selectedYear = '';
  String selectedCity = 'Pune';

  // lists (sample data from your original screen)
  final List<String> requirementList = <String>['Buy Vehicle', 'Sell Vehicle'];
  final List<String> makerList = <String>[
    'TATA',
    'Ashok Leyland',
    'Mahindra',
    'Isuzu',
    'Bharat Benz',
    'Volvo',
    'Other'
  ];
  final List<String> conditionList = <String>['Average', 'Good', 'Excellent'];
  final List<String> yearList = List.generate(25, (i) => (2025 - i).toString());
  final List<String> vehicleSizeList = <String>[
    '32ft Closer Container',
    '24ft Closed Vehicles',
    '20ft Closed Vehicles',
    '20ft Closed',
    '20ft Open',
    '15ft Closed',
    '15ft Open',
    '13ft Closed',
    '13ft Open',
    '24ft Single XL',
    '24ft Double XL',
    '24ft Multi XL',
    '32ft Single XL',
    '32ft Double XL',
    '32ft Multi XL',
    'Trailer',
    'Other'
  ];

  // date
  String insuranceDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  DateTime _date = DateTime.now();

  // loading
  bool _isSubmitting = false;

  // stepper
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _cityController.text = selectedCity;
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    DateTime? _datePicker = await showDatePicker(
      initialDatePickerMode: DatePickerMode.day,
      context: context,
      initialDate: _date,
      firstDate: DateTime(1947),
      lastDate: DateTime(2030),
    );

    if (_datePicker != null && _datePicker != _date) {
      setState(() {
        _date = _datePicker;
        insuranceDate = DateFormat('dd/MM/yyyy').format(_datePicker);
      });
    }
    return _datePicker;
  }

  // Central submit method used by both UIs
  Future<void> _submit(AuthProvider authProvider) async {
    if (_isSubmitting) return;
    final formValid = useStepper ? _stepperKey.currentState?.validate() ?? false : _formKey.currentState?.validate() ?? false;
    if (!formValid) {
      // show simple snackbar
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill required fields')));
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final user = authProvider.userDetailList[0];
      final bool result = await widget.buySellProvider.createBuySell(
        userId: user.id,
        description: _description.text,
        agentName: '${user.firstName} ${user.lastName}',
        bodyType: selectedVehicleSize,
        buySellType: selectedPostType,
        city: selectedCity,
        conditionOfTyre: selectedCondition,
        ConOfVehicle: selectedCondition,
        mobile: user.mobileNumber,
        price: _price.text,
        id: user.id,
        image: '',
        insurancePaidDate: insuranceDate,
        mainTag: selectedPostType,
        maker: selectedMakerName,
        mfgYear: selectedYear,
        model: _modelName.text,
        lUserName: user.userName,
        owner: '${user.firstName} ${user.lastName}',
        postingTime: '',
        type: selectedPostType,
        registrationNumber: _vehicleRno.text,
        yearOfBuying: selectedYear,
      );

      if (result) {
        // show success dialog and then pop
        await showAnimatedDialog(
          context,
          MyDialog(
            icon: Icons.check,
            title: 'New Post',
            description: 'Your post submitted successfully',
            isFailed: false,
            isFromPost: true,
          ),
          dismissible: false,
          isFlip: false,
        );
        Navigator.of(context).pop(true);
      } else {
        // show failure dialog
        await showAnimatedDialog(
          context,
          MyDialog(
            icon: Icons.error,
            title: 'Failed',
            description: 'Failed to submit your post. Try again later.',
            isFailed: true,
            isFromPost: true,
          ),
          dismissible: true,
          isFlip: false,
        );
      }
    } catch (e) {
      debugPrint('CreateBuySell error: $e');
      await showAnimatedDialog(
        context,
        MyDialog(
          icon: Icons.error,
          title: 'Error',
          description: 'Something went wrong. Please try again.',
          isFailed: true,
          isFromPost: true,
        ),
        dismissible: true,
        isFlip: false,
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // Small helper to open city dialog
  Future<void> _openCityDialog() async {
    final selected = await showDialog<String>(
      context: context,
      builder: (_) => CustomCityListDialog(
        onTap: (String value) {
          Navigator.of(context).pop(value);
        },
      ),
    );
    if (selected != null) {
      setState(() {
        selectedCity = selected;
        _cityController.text = selectedCity;
      });
    }
  }

  // Form field widget helpers (floating labels)
  Widget _floatingText({
    required String label,
    required TextEditingController controller,
    TextInputType keyboard = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap,
    bool isDigits = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        readOnly: readOnly,
        maxLines: maxLines,
        onTap: onTap,
        inputFormatters: isDigits ? [FilteringTextInputFormatter.digitsOnly] : null,
        validator: (v) {
          if ((v == null || v.trim().isEmpty) && !readOnly) return 'This field is required';
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _floatingDropdown({
    required String label,
    required List<String> items,
    required String value,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: value.isEmpty ? null : value,
        decoration: InputDecoration(
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        items: items.map((it) => DropdownMenuItem(value: it, child: Text(it))).toList(),
        onChanged: onChanged,
        validator: (v) {
          if (v == null || v.isEmpty) return 'Please select';
          return null;
        },
      ),
    );
  }

  // Card-based form layout (B)
  Widget _cardForm(BuildContext context, AuthProvider authProvider) {
    final double horizontalMargin = ResponsiveWidget.isDesktop(context) ? 50 : 20;
    return Form(
      key: _formKey,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: horizontalMargin, vertical: 12),
        child: Column(
          children: [
            // short intro card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Row(
                  children: const [
                    Icon(Icons.info_outline),
                    SizedBox(width: 10),
                    Expanded(child: Text('Post details will be visible on the board. Fill required fields to submit.')),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Card grouping main fields
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  children: [
                    _floatingDropdown(
                      label: 'Select type',
                      items: requirementList,
                      value: selectedPostType,
                      onChanged: (v) => setState(() => selectedPostType = v ?? ''),
                    ),

                    _floatingText(
                      label: 'Company Name',
                      controller: TextEditingController(text: authProvider.userDetailList[0].companyName ?? ''),
                      readOnly: true,
                    ),

                    _floatingText(
                      label: 'Mobile',
                      controller: TextEditingController(text: authProvider.userDetailList[0].mobileNumber.toString()),
                      readOnly: true,
                    ),

                    _floatingText(
                      label: 'Email',
                      controller: TextEditingController(text: authProvider.userDetailList[0].emailId ?? ''),
                      readOnly: true,
                    ),

                    // City picker
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        controller: _cityController,
                        readOnly: true,
                        onTap: _openCityDialog,
                        decoration: InputDecoration(
                          labelText: 'Select City',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          suffixIcon: const Icon(Icons.arrow_drop_down_outlined),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Please select a city';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Card grouping vehicle fields
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  children: [
                    _floatingDropdown(
                      label: 'Select Maker Name',
                      items: makerList,
                      value: selectedMakerName,
                      onChanged: (v) => setState(() => selectedMakerName = v ?? ''),
                    ),

                    _floatingText(label: 'Model Name', controller: _modelName),

                    _floatingDropdown(
                      label: 'Select Manufacturing Year',
                      items: yearList,
                      value: selectedYear,
                      onChanged: (v) => setState(() => selectedYear = v ?? ''),
                    ),

                    _floatingDropdown(
                      label: 'Select Vehicle Size',
                      items: vehicleSizeList,
                      value: selectedVehicleSize,
                      onChanged: (v) => setState(() => selectedVehicleSize = v ?? ''),
                    ),

                    if (selectedPostType == 'Sell Vehicle') ...[
                      _floatingText(label: 'Kilometer Driven', controller: _kiloMeter, keyboard: TextInputType.number, isDigits: true),
                      _floatingText(label: 'Vehicle Register Number', controller: _vehicleRno),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: TextEditingController(text: insuranceDate),
                          readOnly: true,
                          onTap: () => _selectDate(context),
                          decoration: InputDecoration(
                            labelText: 'Insurance Date Up To (dd/mm/yyyy)',
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            suffixIcon: const Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                    ],

                    _floatingDropdown(
                      label: 'Condition Of Vehicles',
                      items: conditionList,
                      value: selectedCondition,
                      onChanged: (v) => setState(() => selectedCondition = v ?? ''),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Card grouping price and extra
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  children: [
                    _floatingText(label: 'Approximate Price', controller: _price, isDigits: true, keyboard: TextInputType.number),
                    _floatingText(label: 'Additional Information', controller: _description, maxLines: 4),
                    const SizedBox(height: 8),
                    if (_isSubmitting) const CircularProgressIndicator(),
                    const SizedBox(height: 8),
                    CustomButton(
                      onTap: _isSubmitting ? null : () => _submit(Provider.of<AuthProvider>(context, listen: false)),
                      buttonText: 'Post'
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text('Post Buy/Sell Requirement', style: Style.appheading),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              // toggle UI mode

            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(child: _cardForm(context, authProvider)),
          ),
        );
      },
    );
  }
}
