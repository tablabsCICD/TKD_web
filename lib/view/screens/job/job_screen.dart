
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:number_pagination/number_pagination.dart';

import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:tkd_app/dialog/animated_custom_dialog.dart';
import 'package:tkd_app/dialog/my_dialog.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/job_model.dart';
import 'package:tkd_app/model/post_job.dart';
import 'package:tkd_app/open_whatsapp.dart';
import 'package:tkd_app/provider/job_provider.dart';
import 'package:tkd_app/share_data.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:http/http.dart' as http;
import 'package:tkd_app/util/custom_text_style.dart';
import 'package:tkd_app/util/date_converter.dart';
import 'package:tkd_app/util/images.dart';
import 'package:tkd_app/util/star_display.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/getImage.dart';
import 'package:tkd_app/view/base_widget/getLoader.dart';
import 'package:tkd_app/view/base_widget/home_base_widgets.dart';
import 'package:tkd_app/view/base_widget/utils.dart';
import 'package:tkd_app/view/localization/language_constrants.dart';
import 'package:tkd_app/view/screens/job/create_job.dart';
import 'package:tkd_app/view/screens/job/job_details_screen.dart';
import 'package:universal_html/html.dart' as html;

class JobScreen extends StatefulWidget {
  final jobProvider = locator<JobProvider>();

  JobScreen({Key? key}) : super(key: key) {
    jobProvider.getAllJobs(currentPage: 0);
    /*jobProvider.getCard();
    jobProvider.getCandidates();*/
  }

  @override
  _JobScreenState createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {

  final jobProvider = locator<JobProvider>();
  int selectedPageNumber = 1;
  ScrollController _scrollController = ScrollController();
  TextEditingController _searchController = TextEditingController();
  String? selectedRole;
  String? selectedExperience;
  String? selectedSalary;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        jobProvider.getAllJobs(currentPage: selectedPageNumber);
        selectedPageNumber++;
      }
    });
  }

  List<String> expList = ["Fresher","6 Month","1 Year","1.5 Year","2 Year","2.5 Year","3 Year","3.5 Year","4 Year","4.5  Year","5 Year","5.5 Year","6 Year"];
  List<String> salaryList = ['1LPA','1PLA to 2LPA','2PLA to 3LPA','4PLA to 5LPA','6PLA to 7LPA','8PLA to 9LPA','10PLA to Above',];



  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: ColorResources.HOME_BG,
        body: Consumer<JobProvider>(
          builder: (context, model, child) => Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                // --------------------------- FILTER BAR --------------------------
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      // SEARCH BUTTON
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: "Search job title, role...",
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (v) {
                            if (v.isNotEmpty && v.length > 2) {
                              _callSearch();
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 10),

                      // FILTER BUTTON
                      InkWell(
                        onTap: () => _openFilters(context),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: ColorResources.THEME_COLOR,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.filter_alt_rounded, color: Colors.white),
                              SizedBox(width: 5),
                              Text("Filter",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                model.listJobs.isEmpty

                    ? Expanded(
                    child: Container(
                        height: MediaQuery.of(context).size.height - 200,
                        child: Center(child: Text(getTranslated('no_post', context)!,style: Style.heading,))))
                    : Expanded(
                  child: StaggeredGridView.countBuilder(
                    controller: _scrollController,
                    physics: ScrollPhysics(),
                    crossAxisCount: ResponsiveWidget.isDesktop(context)
                        ? 3
                        : ResponsiveWidget.isMobile(context)
                        ? 1
                        : 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 12,
                    itemCount: model.listJobs.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => JobDetailsScreen(
                                      model.listJobs[index])));*/
                        },
                        child: jobCard(model.listJobs[index]),
                      );
                    },
                    shrinkWrap: true,
                    staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                  ),
                ),
                getLoader(model.isLoadingCandidate)
              ],
            ),
          ),
        )
      ),
    );
  }

  jobCard(JobData jobData) {
    return Container(
      width: 335,
      // height: 417,
      padding: EdgeInsets.all(12),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x114A5568),
            blurRadius: 8,
            offset: Offset(0, 3),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 120,
              height: 18,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: ShapeDecoration(
                color: Color(0xFFD25D5D),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
              ),
              child: Center(
                child: Text(
                  jobData.postJob!.experience != null
                      ? "Exp: "+jobData.postJob!.experience! + ""
                      : "No Info",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          HomeBaseWidget().profile(
              "",
              jobData.name != null ? jobData.name! : "No Info",
              jobData.postJob!.companyName != null
                  ? jobData.postJob!.companyName!
                  : "No Info",jobData.postJob!.emailId??'-',0.0,isJob: 1),
          SizedBox(width: 8),
          HomeBaseWidget().jobHeading(jobData.postJob!.salary==null?"":jobData.postJob!.salary!),
          /*BaseWidget().headingWithDescription(
              jobData.postJob!.jobDepartment!,
              jobData.postingDate != null ? jobData.postingDate!.split(" ").first : "",
             jobData.postJob!.jobDescription!,
            '',
            '',
            true
          ),*/
          HomeBaseWidget().jobHeadingWithDescription("Job Title", jobData.postingDate != null ? jobData.postingDate!.split(" ").first : "", jobData.postJob!.jobDepartment!,jobData.postJob!.jobType!,jobData.postJob!.jobDescription!,jobData.postJob!.jobLocation??"",true),
          SizedBox(width: 8),
          jobApply(jobData),
        ],
      ),
    );
  }

  Widget jobApply(JobData jobData) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(right: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: (){
              Utils().callFunction(context,jobData.postJob!.contactNumber.toString());
            },
            child: Container(
              height: 38,
              //width: 203,//for save job
              width: 240,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.50, color: Color(0x33001E49)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Call now',
                    style: TextStyle(
                      color: Color(0xFF001E49),
                      fontSize: 12,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          //  SizedBox(width: 12),
          // SvgPicture.asset(Images.savejob),
          SizedBox(width: 12),
          InkWell(
              onTap: (){
                String Message="I am writing to express my strong interest in the "+jobData.postJob!.jobDepartment!+" From TKD Connect Application";
                Utils().openwhatsapp(context, jobData.postJob!.contactNumber!, Message);
              },
              child: SvgPicture.asset(Images.message_job)),
        ],
      ),
    );
  }
  final TextEditingController roleController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();

  String? selectedDepartment;


  void _openFilters(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return StatefulBuilder(builder: (context, setStateSB) {
          return Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Filter Jobs",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Divider(),

                  // ROLE
                  Text("Role", style: TextStyle(fontWeight: FontWeight.w600)),
                  SizedBox(height: 8),
                  TextField(
                    controller: roleController,
                    decoration: _inputStyle().copyWith(
                      hintText: "Enter role (e.g. Driver, Manager...)",
                    ),
                    onChanged: (v) => setStateSB(() => selectedRole = v),
                  ),

                  SizedBox(height: 18),

// DEPARTMENT
                  Text("Department", style: TextStyle(fontWeight: FontWeight.w600)),
                  SizedBox(height: 8),
                  TextField(
                    controller: departmentController,
                    decoration: _inputStyle().copyWith(
                      hintText: "Enter department (e.g. Logistics, HR...)",
                    ),
                    onChanged: (v) => setStateSB(() => selectedDepartment = v),
                  ),


                  SizedBox(height: 18),

                  // EXPERIENCE
                  Text("Experience",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedExperience,
                    decoration: _inputStyle(),
                    items: expList.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (v) => setStateSB(() => selectedExperience = v),
                  ),

                  SizedBox(height: 18),

                  // SALARY
                  Text("Salary",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedSalary,
                    decoration: _inputStyle(),
                    items: salaryList.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (v) => setStateSB(() => selectedSalary = v),
                  ),

                  SizedBox(height: 18),

                  // DATE
                  Text("Posting Date",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                        initialDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setStateSB(() => selectedDate = picked);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_month, color: Colors.black54),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              selectedDate == null
                                  ? "Select Date"
                                  : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // BUTTONS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        child: Text("Clear All",
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
                        onPressed: () {
                          setStateSB(() {
                            selectedRole = null;
                            selectedExperience = null;
                            selectedSalary = null;
                            selectedDate = null;
                            roleController.clear();
                            departmentController.clear();
                          });
                        },
                      ),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorResources.THEME_COLOR,
                          padding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text("Apply", style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          Navigator.pop(context);
                          _callSearch();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  InputDecoration _inputStyle() {
    return InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }

  void _callSearch() {
    widget.jobProvider.getAllJobs(
      currentPage: 0,
      search: _searchController.text.trim(),
      role: selectedRole,
      department:selectedDepartment,
      experience: selectedExperience,
      salary: selectedSalary,
      date: selectedDate != null
          ? "${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}"
          : null,
    );
  }

}

