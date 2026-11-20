import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:tkd_app/dialog/animated_custom_dialog.dart';
import 'package:tkd_app/dialog/my_dialog.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/buy_sell_provider.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/custom_button.dart';
import 'package:tkd_app/widgets/button.dart';
import 'package:tkd_app/widgets/base_widgets.dart';
import 'package:tkd_app/widgets/toast.dart';

import '../../../util/images.dart';
import '../../../util/colors.dart';
import '../../../util/app_constants.dart';

class CreateNewBuySellPost extends StatefulWidget {
  CreateNewBuySellPost({Key? key}) : super(key: key);

  @override
  State<CreateNewBuySellPost> createState() => _CreateNewBuySellPostState();
}

class _CreateNewBuySellPostState extends State<CreateNewBuySellPost> {
  // Form key + controllers
  final _formKey = GlobalKey<FormState>();

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

  // sample lists
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
  final List<String> yearList =
  List.generate(25, (i) => (DateTime.now().year - i).toString());
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

  bool _isSubmitting = false;

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
      lastDate: DateTime(2035),
    );

    if (_datePicker != null && _datePicker != _date) {
      setState(() {
        _date = _datePicker;
        insuranceDate = DateFormat('dd/MM/yyyy').format(_datePicker);
      });
    }
    return _datePicker;
  }


  // Form fields widgets
  Widget _floatingText({
    required String label,
    required TextEditingController controller,
    TextInputType keyboard = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap,
    bool isDigits = false,
    int maxLines = 1,
    String? initialValue,
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

  Future<void> _submit(
      BuildContext context,
      BuySellProvider provider,
      AuthProvider authProvider,
      ) async {
    if (_isSubmitting) return;

    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill required fields')),
      );
      return;
    }

    if (provider.buySellImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload at least 1 image')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final user = authProvider.userDetailList[0];

      bool result = await provider.createBuySell(
        context: context,
        userId: user.id!,
        description: _description.text,
        agentName: '${user.firstName ?? ''} ${user.lastName ?? ''}',
        bodyType: selectedVehicleSize,
        buySellType: selectedPostType,
        city: selectedCity,
        conditionOfTyre: selectedCondition,
        conditionOfVehicle: selectedCondition,
        mobile: user.mobileNumber.toString(),
        price: _price.text,
        mainTag: selectedPostType,
        maker: selectedMakerName,
        mfgYear: selectedYear,
        model: _modelName.text,
        loggedUserName: user.loggedUserName!,
        owner: '${user.firstName ?? ''} ${user.lastName ?? ''}',
        registrationNumber: _vehicleRno.text,
        yearOfBuying: selectedYear,
        images: provider.buySellImages,
      );

      if (result) {


        /// 🔄 Force refresh Buy/Sell list after post creation
        provider.buyVehicleList.clear();
        provider.sellVehicleList.clear();
        provider.getBuyVehicles(currentPage: 0);
        provider.getSellVehicles(currentPage: 0);
        ToastMessage.show(context, "Post submitted successfully..");
        /// Close Create screen (only once)
        if (mounted) Navigator.pop(context, true);

      } else {
        ToastMessage.show(context, "Something went wrong");
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

  // Image preview grid
  Widget _imagePreviewGrid(BuySellProvider provider) {
    final images = provider.buySellImages;
    if (images.isEmpty) return const SizedBox.shrink();

    // responsive columns
    int crossAxis = ResponsiveWidget.isDesktop(context) ? 4 : (ResponsiveWidget.isMobile(context) ? 2 : 3);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: images.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxis,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final url = images[index];
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                // Show full screen preview on tap (web/mobile)
                showDialog(
                  context: context,
                  builder: (_) => Dialog(
                    child: InteractiveViewer(
                      child: Container(
                        color: Colors.black,
                        child: url.startsWith('http')
                            ? Image.network(url, fit: BoxFit.contain)
                            : Image.asset(url, fit: BoxFit.contain),
                      ),
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  image: url.startsWith('http')
                      ? DecorationImage(image: NetworkImage(url), fit: BoxFit.cover)
                      : null,
                ),
                child: url.startsWith('http') ? null : Center(child: Text('Image')),
              ),
            ),
            Positioned(
              top: 6,
              right: 6,
              child: GestureDetector(
                onTap: () {
                  provider.buySellImages.removeAt(index);
                  provider.notifyListeners();
                },
                child: Container(
                  decoration: BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                  padding: const EdgeInsets.all(6),
                  child: const Icon(Icons.close, size: 16, color: Colors.white),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _uploadButton(BuySellProvider provider) {
    return Column(
      children: [
        InkWell(
          onTap: () async {
            // pick and upload image (provider handles max 4)
            await provider.uploadBuySellImage(context);
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
            ),
            child: SvgPicture.asset(Images.add_image, width: 40, height: 40),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Upload Images (max 4)',
          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF001E49)),
        )
      ],
    );
  }

  Widget _cardForm(BuildContext context, AuthProvider authProvider) {
    final buySellProvider = Provider.of<BuySellProvider>(context);
    final double horizontalMargin = ResponsiveWidget.isDesktop(context) ? 50 : 16;

    return Form(
      key: _formKey,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: horizontalMargin, vertical: 12),
        child: Column(
          children: [
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

            // main fields card
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
                        onChanged: (v) => setState(() => selectedPostType = v ?? '')),
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
                    // city picker
                    _floatingText(label: 'City', controller: _cityController),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // vehicle details card
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

            // price & images card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  children: [
                    _floatingText(label: 'Approximate Price', controller: _price, isDigits: true, keyboard: TextInputType.number),
                    _floatingText(label: 'Additional Information', controller: _description, maxLines: 4),

                    const SizedBox(height: 12),

                    // Image previews
                    if (selectedPostType != "Buy") ...[
                      _imagePreviewGrid(buySellProvider),
                      const SizedBox(height: 12),

                      if (buySellProvider.buySellImages.length < 4)
                        _uploadButton(buySellProvider),

                      const SizedBox(height: 12),
                    ],



                    if (_isSubmitting) const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: CircularProgressIndicator(),
                    ),

                    const SizedBox(height: 8),

                    CustomButton(
                      onTap: _isSubmitting ? null : () => _submit(context, buySellProvider, Provider.of<AuthProvider>(context, listen: false)),
                      buttonText: 'Post',
                    ),
                  ],
                ),
              ),
            ),
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
          ),
          body: SafeArea(
            child: SingleChildScrollView(child: _cardForm(context, authProvider)),
          ),
        );
      },
    );
  }
}
