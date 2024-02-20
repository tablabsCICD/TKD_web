import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tkd_app/dialog/CustomCityListDialog.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/route_provider.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/custom_button.dart';
import 'package:tkd_app/view/base_widget/custom_textview.dart';
import 'package:tkd_app/view/base_widget/cutom_city_textfield.dart';
import 'package:tkd_app/view/base_widget/open_url.dart';
import 'package:tkd_app/view/localization/language_constrants.dart';
import 'package:tkd_app/view/screens/auth/login_screen.dart';
import 'package:tkd_app/view/screens/auth/registration_screen_2.dart';

class RegistrationScreen3 extends StatefulWidget {
  String firstName,
      lastName,
      email,
      selctedType,
      mobileNumber,
      adharCard,
      panCard;

  RegistrationScreen3(this.firstName, this.lastName, this.email,
      this.mobileNumber, this.adharCard, this.panCard, this.selctedType);

  @override
  _RegistrationScreen3State createState() => _RegistrationScreen3State();
}

class _RegistrationScreen3State extends State<RegistrationScreen3> {
  TextEditingController fromCityController = TextEditingController();
  TextEditingController toCityController = TextEditingController();
  final routeProvider = locator<RouteProvider>();
  final authProvider = locator<AuthProvider>();
  String? selectedFromCity = '', selectedToCity = "";
  final _formKey = GlobalKey<FormState>();
  var _current = 0;
  List<ImageCarousel> carouselImages = [
    ImageCarousel('assets/images/man_01.png','assets/images/truck_01.png',"Grow your business","Multiply you business by getting vehicles at\n the right price at the right time.Also, do'nt loose any\n business which is not in your regular route of operations."),
    ImageCarousel('assets/images/man_01.png','assets/images/truck_01.png',"Grow your own business","Multiply you business by getting vehicles at\n the right price at the right time.Also, do'nt loose any\n business which is not in your regular route of operations."),
    ImageCarousel('assets/images/man_01.png','assets/images/truck_01.png',"Grow your tkd business","Multiply you business by getting vehicles at\n the right price at the right time.Also, do'nt loose any\n business which is not in your regular route of operations."),
  ];
  @override
  void initState() {
    // routeProvider.getRouteListByUserId(authProvider.userDetailList[0].id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ResponsiveWidget.isMobile(context)
            ? Stack(children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage('assets/images/truck.png'),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      getCart(),
                    ],
                  ),
                ),
              ])
            : Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.5, 0.5],
                            colors: [Colors.white, ColorResources.HOME_BG])),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      'assets/images/tkd.png',
                      height: 150,
                      width: 250,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: getCart(),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: getDetails(),
                  ),
                ],
              ),
      ),
    );
  }

  getCart() {
    return Form(
      key: _formKey,
      child: Consumer<RouteProvider>(
        builder: (context, model, child) => Container(
          padding: ResponsiveWidget.isMobile(context)
              ? EdgeInsets.all(10)
              : EdgeInsets.only(left: 30, right: 30, bottom: 20),
          height: 650,
          width: ResponsiveWidget.isMobile(context)
              ? MediaQuery.of(context).size.width - 50
              : ResponsiveWidget.isDesktop(context)
                  ? MediaQuery.of(context).size.width / 4.0
                  : MediaQuery.of(context).size.width / 3,
          margin: ResponsiveWidget.isMobile(context)
              ? EdgeInsets.all(0)
              : ResponsiveWidget.isDesktop(context)
                  ? EdgeInsets.only(left: MediaQuery.of(context).size.width / 8)
                  : EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 10),
          decoration: BoxDecoration(
            color: ColorResources.WHITE,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5.0,
                spreadRadius: 2.0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(getTranslated('my_route_label', context)!,
                    style: Style.title),
              ),
              SizedBox(
                height: 20,
              ),
              CustomCityTextField(
                hintText: 'Select City',
                controller: selectedFromCity!,
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomCityListDialog(onTap: (String value) {
                          setState(() {
                            selectedFromCity = value;
                          });
                        });
                      });
                },
              ),
              CustomCityTextField(
                hintText: 'Select City',
                controller: selectedToCity!,
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomCityListDialog(onTap: (String value) {
                          setState(() {
                            if (value != selectedFromCity) {
                              selectedToCity = value;
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (_) => new CupertinoAlertDialog(
                                        title: Column(
                                          children: [
                                            CustomText(
                                                'Source and destination should not be same',
                                                style: TextStyle(
                                                    color: ColorResources
                                                        .BOTTOM_HEADING,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            CustomText(
                                                'Please select different destination',
                                                style: TextStyle(
                                                    color: ColorResources
                                                        .BOTTOM_HEADING,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.normal)),
                                          ],
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(
                                                  getTranslated('ok', context)!,
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 18)),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      ));
                            }
                          });
                        });
                      });
                },
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            if (model.dummyRouteList.length <= 4) {
                              model.addDummyRoute(
                                  selectedFromCity, selectedToCity);
                              selectedFromCity = '';
                              selectedToCity = '';
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (_) => new CupertinoAlertDialog(
                                        title: Column(
                                          children: [
                                            CustomText('Maximum Routes Reached',
                                                style: TextStyle(
                                                    color: ColorResources
                                                        .BOTTOM_HEADING,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            CustomText(
                                                'You can have maximum 05 routes. In order to add another route, please delete one of the existing routes',
                                                style: TextStyle(
                                                    color: ColorResources
                                                        .BOTTOM_HEADING,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.normal)),
                                          ],
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(
                                                  getTranslated('ok', context)!,
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 18)),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      ));
                            }
                          }
                        },
                        buttonText: getTranslated('add', context)),
                    CustomButton(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        buttonText: 'Back'),
                    CustomButton(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => RegistrationScreen2(
                                      widget.firstName,
                                      widget.lastName,
                                      widget.email,
                                      widget.mobileNumber,
                                      widget.adharCard,
                                      widget.panCard,
                                      widget.selctedType)));
                        },
                        buttonText:
                            model.dummyRouteList.length == 0 ? 'Skip' : 'Next'),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              model.dummyRouteList.isEmpty
                  ? Container(
                      alignment: Alignment.center,
                      child: CustomText(
                        'Add Your Business Route',
                        style: Style.contentHeading,
                      ))
                  : Container(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: model.dummyRouteList.length,
                        itemBuilder: (contex, index) {
                          return Container(
                            height: 50,
                            color: index.isEven
                                ? ColorResources.HOME_APPBAR
                                : ColorResources.HOME_BG,
                            child: ListTile(
                              title: Text(
                                '${model.dummyRouteList[index].source} To ${model.dummyRouteList[index].destination}',
                                style: Style.cityHeading,
                              ),
                              trailing: ElevatedButton(
                                onPressed: () {
                                  model.deleteDummyRoute(
                                      model.dummyRouteList[index]);
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white, backgroundColor: Colors.red[200],
                                  elevation: 3,
                                ),
                                child: Text(
                                  getTranslated('delete', context)!,
                                  style: Style.button,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already Member?", style: Style.newheading),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => Login_Screen()));
                    },
                    child: Text("Login Here", style: Style.aleaready),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // getDetails() {
  //   return Container(
  //     height: 500,
  //     width: MediaQuery.of(context).size.width / 2,
  //     margin: EdgeInsets.only(right: MediaQuery.of(context).size.width / 10),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text("Your transport\nsearch ends here",
  //             style: TextStyle(
  //               fontFamily: 'PlayfairDisplay',
  //               color: Color(0xff202020),
  //               fontSize: 58,
  //               fontWeight: FontWeight.w900,
  //               fontStyle: FontStyle.normal,
  //               letterSpacing: 0,
  //             )),
  //         SizedBox(
  //           height: 50,
  //         ),
  //         new Text("* Suspendisse dapibus dui et leo rutrum",
  //             style: TextStyle(
  //               fontFamily: 'Roboto',
  //               color: Color(0xff000000),
  //               fontSize: 16,
  //               fontWeight: FontWeight.w300,
  //               fontStyle: FontStyle.normal,
  //               letterSpacing: -0.3,
  //             )),
  //         SizedBox(
  //           height: 16,
  //         ),
  //         new Text("* Lorem ipsum dolor sit amet",
  //             style: TextStyle(
  //               fontFamily: 'Roboto',
  //               color: Color(0xff000000),
  //               fontSize: 16,
  //               fontWeight: FontWeight.w300,
  //               fontStyle: FontStyle.normal,
  //               letterSpacing: -0.3,
  //             )),
  //         SizedBox(
  //           height: 16,
  //         ),
  //         new Text("* Quisque nec dui eleifend, tincidunt lectsectetur",
  //             style: TextStyle(
  //               fontFamily: 'Roboto',
  //               color: Color(0xff000000),
  //               fontSize: 16,
  //               fontWeight: FontWeight.w300,
  //               fontStyle: FontStyle.normal,
  //               letterSpacing: -0.3,
  //             )),
  //         SizedBox(
  //           height: 16,
  //         ),
  //         new Text("* Nunc non posuere sapien",
  //             style: TextStyle(
  //               fontFamily: 'Roboto',
  //               color: Color(0xff000000),
  //               fontSize: 16,
  //               fontWeight: FontWeight.w300,
  //               fontStyle: FontStyle.normal,
  //               letterSpacing: -0.3,
  //             )),
  //         SizedBox(
  //           height: 16,
  //         ),
  //         new Text("* Donec tincidunt odio in augue ornare",
  //             style: TextStyle(
  //               fontFamily: 'Roboto',
  //               color: Color(0xff000000),
  //               fontSize: 16,
  //               fontWeight: FontWeight.w300,
  //               fontStyle: FontStyle.normal,
  //               letterSpacing: -0.3,
  //             )),
  //         SizedBox(
  //           height: 50,
  //         ),
  //         Column(
  //           children: [
  //             Text("Android App Available On",
  //                 style: TextStyle(
  //                   fontFamily: 'RobotoSlab',
  //                   color: Colors.black,
  //                   fontSize: 14,
  //                   fontWeight: FontWeight.w400,
  //                   fontStyle: FontStyle.normal,
  //                 )),
  //             SizedBox(
  //               width: 20,
  //             ),
  //             InkWell(
  //               onTap: () {
  //                 openUrl();
  //               },
  //               child: Image.asset(
  //                 'assets/images/bitmap.png',
  //                 height: 50,
  //                 width: 100,
  //               ),
  //             )
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  int index = -1;

  getDetails() {
    return Container(
      height: 400,
      width: MediaQuery.of(context).size.width / 3,
      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width / 10),
      child: Stack(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 500.0,
              aspectRatio: 16 / 9,
              enlargeCenterPage: false,
              viewportFraction: 1.0,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
            items: carouselImages.map((i) {
              index++;
              return Builder(builder: (BuildContext context) {
                return Container(
                    height: MediaQuery.of(context).size.height * 0.30,
                    width: MediaQuery.of(context).size.width,
                    child: index < 3
                        ? Stack(children: [
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                  height: 500,
                                  width: MediaQuery.of(context).size.width / 4,
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 20.0),
                                    child: Image.asset(
                                      carouselImages[index].image2,
                                      height: 72,
                                      width: 222,
                                    ),
                                  )),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    carouselImages[index].image1,
                                    height: 234,
                                    width: 120,
                                  ),
                                  Text(carouselImages[index].title,
                                      style: Style.splashheading),
                                  new Text(
                                    carouselImages[index].subTitle,
                                    style: Style.splashContent,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ])
                        : getWidget());
              });
            }).toList(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: carouselImages.map((i) {
                int index = carouselImages.indexOf(i);
                return Container(
                  width: 6.0,
                  height: 6.0,
                  margin: EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index
                        ? ColorResources.PRIMARY_COLOR
                        : ColorResources.DOT_COLOR,
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  getWidget() {
    index = 0;
    return SizedBox.shrink();
  }
}
