/*
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:number_pagination/number_pagination.dart';

import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:tkd_app/dialog/animated_custom_dialog.dart';
import 'package:tkd_app/dialog/my_dialog.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/job_model.dart';
import 'package:tkd_app/open_whatsapp.dart';
import 'package:tkd_app/provider/job_provider.dart';
import 'package:tkd_app/share_data.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:http/http.dart' as http;
import 'package:tkd_app/util/custom_text_style.dart';
import 'package:tkd_app/util/date_converter.dart';
import 'package:tkd_app/util/star_display.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/getImage.dart';
import 'package:tkd_app/view/base_widget/getLoader.dart';
import 'package:tkd_app/view/localization/language_constrants.dart';
import 'package:tkd_app/view/screens/job/create_job.dart';
import 'package:tkd_app/view/screens/job/job_details_screen.dart';
import 'package:universal_html/html.dart' as html;

class JobScreen extends StatefulWidget {
  final jobProvider = locator<JobProvider>();

  JobScreen({Key? key}) : super(key: key) {
    jobProvider.getCard();
    jobProvider.getCandidates();
  }

  @override
  _JobScreenState createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: ColorResources.HOME_BG,
        appBar: AppBar(
          toolbarHeight: 10,
          backgroundColor: ColorResources.APPBAR_COLOR,
          bottom: TabBar(
            labelColor: Colors.deepOrangeAccent,
            labelStyle: Style.tabHeading,
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.deepOrangeAccent,
            indicatorWeight: 4,
            tabs: [
              Tab(
                text: getTranslated('jobs', context)!,
                height: 30,
              ),
              Tab(
                text: getTranslated('candidates', context)!,
                height: 30,
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (builder) => CreateJob()));
          },
          icon: Icon(Icons.add),
          label: Text(
            getTranslated('post', context)!,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              color: ColorResources.HOME_BG,
              child: ResponsiveWidget(
                desktop: JobCard(),
                mobile: JobCard(),
                tablet: JobCard(),
              ),
            ),
            Container(
              color: ColorResources.HOME_BG,
              child: ResponsiveWidget(
                desktop: CandidateCard(),
                mobile: CandidateCard(),
                tablet: CandidateCard(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CandidateCard extends StatefulWidget {
  @override
  _CandidateCardState createState() => _CandidateCardState();
}

class _CandidateCardState extends State<CandidateCard> {
  final jobProvider = locator<JobProvider>();
  int selectedPageNumber = 1;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        jobProvider.getCandidates(currentPage: selectedPageNumber);
        selectedPageNumber++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<JobProvider>(
      builder: (context, model, child) => Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            model.candidateList.isEmpty && model.isLoadingCandidate == false

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
                      itemCount: model.candidateList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => JobDetailsScreen(
                                        model.candidateList[index])));
                          },
                          child: Card(
                            elevation: 5,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 5),
                                    horizontalTitleGap: 5,
                                    minVerticalPadding: 0,
                                    leading: getImage(model
                                        .candidateList[index].companyLogo
                                        .toString()),
                                    title: Text(
                                        model.candidateList[index].nameOfPerson
                                            .toString(),
                                        style: Style.title),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            model.candidateList[index]
                                                .companyName
                                                .toString(),
                                            style: Style.subtitle),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: StarDisplay(
                                              value: model
                                                  .candidateList[index].ratings!
                                                  .toInt()),
                                        ),
                                      ],
                                    ),
                                    trailing: Text(
                                        model.candidateList[index].postingTime
                                            .toString(),
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 12)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 9),
                                    child: Text(
                                        model.candidateList[index].topicName
                                            .toString(),
                                        style: Style.contentHeading),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, bottom: 10, right: 10),
                                    child: Text(
                                      model.candidateList[index].content
                                          .toString(),
                                      style: Style.content,
                                    ),
                                  ),
                                  Divider(
                                    height: 1.5,
                                    thickness: 1.5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            var shareData = {
                                              "title": model
                                                  .candidateList[index]
                                                  .nameOfPerson,
                                              "text": model.candidateList[index]
                                                  .mobileNumber,
                                              "url": model.candidateList[index]
                                                  .sharableLink,
                                            };
                                            try {
                                              await html.window.navigator
                                                  .share(shareData);
                                            } catch (e) {
                                              print(e);
                                            }
                                          },
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.share,
                                                color: Colors.grey,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                  getTranslated(
                                                      'share', context)!,
                                                  style: Style.bottomHeading)
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 1.5,
                                          height: 30,
                                          color: Colors.grey,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            openwhatsapp(
                                                context,
                                                model.candidateList[index]
                                                    .mobileNumber
                                                    .toString(),
                                                'please contact for more details');
                                          },
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.chat,
                                                color: Colors.grey,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                  getTranslated(
                                                      'chat', context)!,
                                                  style: Style.bottomHeading)
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 1.5,
                                          height: 30,
                                          color: Colors.grey,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (_) =>
                                                    new CupertinoAlertDialog(
                                                      title: Text(
                                                          'Contact Number : ${model.candidateList[index].mobileNumber}',
                                                          style: TextStyle(
                                                              color:
                                                                  ColorResources
                                                                      .BLACK,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10.0),
                                                            child: Text(
                                                                getTranslated(
                                                                    'yes',
                                                                    context)!,
                                                                style: TextStyle(
                                                                    color: ColorResources
                                                                        .GREEN,
                                                                    fontSize:
                                                                        18)),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    ));
                                          },
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.call,
                                                color: Colors.grey,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                  getTranslated(
                                                      'call', context)!,
                                                  style: Style.bottomHeading)
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      //physics: ScrollPhysics(),
                      shrinkWrap: true,
                      staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                    ),
                  ),
            getLoader(model.isLoadingCandidate)
          ],
        ),
      ),
    );
  }
}

class JobCard extends StatefulWidget {
  @override
  _JobCardState createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  final jobProvider = locator<JobProvider>();
  int selectedPageNumber = 1;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        jobProvider.getCard(currentPage: selectedPageNumber);
        selectedPageNumber++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<JobProvider>(
      builder: (context, model, child) => Container(
        margin: EdgeInsets.symmetric(
          horizontal: 35,
        ),
        child: Column(
          children: [
            model.jobList.isEmpty && model.isLoadingJob == false

                ? Expanded(
                child: Container(
                    height: MediaQuery.of(context).size.height - 200,
                    child: Center(child: Text(getTranslated('no_post', context)!,style: Style.heading,))))
                : Expanded(
                    child: StaggeredGridView.countBuilder(
                      controller: _scrollController,
                      crossAxisCount: ResponsiveWidget.isDesktop(context)
                          ? 3
                          : ResponsiveWidget.isMobile(context)
                              ? 1
                              : 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 12,
                      itemCount: model.jobList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => JobDetailsScreen(
                                        model.jobList[index])));
                          },
                          child: Card(
                            elevation: 5,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 5),
                                    horizontalTitleGap: 5,
                                    minVerticalPadding: 0,
                                    leading: getImage(model
                                        .jobList[index].companyLogo
                                        .toString()),
                                    title: Text(
                                        model.jobList[index].nameOfPerson
                                            .toString(),
                                        style: Style.title),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            model.jobList[index].companyName
                                                .toString(),
                                            style: Style.subtitle),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: StarDisplay(
                                              value: model
                                                  .jobList[index].ratings!
                                                  .toInt()),
                                        ),
                                      ],
                                    ),
                                    trailing: ConvertStringToDate(model
                                        .jobList[index].postingTime
                                        .toString()),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 9),
                                    child: Text(
                                        model.jobList[index].topicName
                                            .toString(),
                                        style: Style.contentHeading),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, bottom: 10, right: 10),
                                    child: Text(
                                      model.jobList[index].content.toString(),
                                      style: Style.content,
                                    ),
                                  ),
                                  Divider(
                                    height: 1.5,
                                    thickness: 1.5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            var shareData = {
                                              "title": model
                                                  .jobList[index].nameOfPerson,
                                              "text": model
                                                  .jobList[index].mobileNumber,
                                              "url": model
                                                  .jobList[index].sharableLink,
                                            };
                                            try {
                                              await html.window.navigator
                                                  .share(shareData);
                                            } catch (e) {
                                              print(e);
                                            }
                                          },
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.share,
                                                color: Colors.grey,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                  getTranslated(
                                                      'share', context)!,
                                                  style: Style.bottomHeading)
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 1.5,
                                          height: 30,
                                          color: Colors.grey,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            openwhatsapp(
                                                context,
                                                model
                                                    .jobList[index].mobileNumber
                                                    .toString(),
                                                'please contact for more details');
                                          },
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.chat,
                                                color: Colors.grey,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                  getTranslated(
                                                      'chat', context)!,
                                                  style: Style.bottomHeading)
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 1.5,
                                          height: 30,
                                          color: Colors.grey,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (_) =>
                                                    new CupertinoAlertDialog(
                                                      title: Text(
                                                          'Contact Number : ${model.jobList[index].mobileNumber}',
                                                          style: TextStyle(
                                                              color:
                                                                  ColorResources
                                                                      .BLACK,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10.0),
                                                            child: Text(
                                                                getTranslated(
                                                                    'ok',
                                                                    context)!,
                                                                style: TextStyle(
                                                                    color: ColorResources
                                                                        .GREEN,
                                                                    fontSize:
                                                                        18)),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    ));
                                          },
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.call,
                                                color: Colors.grey,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                  getTranslated(
                                                      'call', context)!,
                                                  style: Style.bottomHeading)
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                    ),
                  ),
            getLoader(model.isLoadingJob)
          ],
        ),
      ),
    );
  }
}
*/
