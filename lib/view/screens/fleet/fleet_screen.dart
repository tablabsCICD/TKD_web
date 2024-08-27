import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:tkd_app/dialog/animated_custom_dialog.dart';
import 'package:tkd_app/dialog/my_dialog.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/fleet_provider.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/custom_text_style.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/custom_textview.dart';
import 'package:tkd_app/view/base_widget/getLoader.dart';
import 'package:tkd_app/view/localization/language_constrants.dart';

class FleetScreen extends StatefulWidget {
  final fleetProvider = locator<FleetProvider>();

  FleetScreen({Key? key}) : super(key: key) {
    fleetProvider.getfleetList();
  }

  @override
  _FleetScreenState createState() => _FleetScreenState();
}

class _FleetScreenState extends State<FleetScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: ColorResources.HOME_BG,
        child: ResponsiveWidget(
          desktop: FleetWebScreen(),
          mobile: FleetWebScreen(),
          tablet: FleetWebScreen(),
        ),
      ),
    );
  }
}

class FleetWebScreen extends StatefulWidget {
  @override
  _FleetWebScreenState createState() => _FleetWebScreenState();
}

class _FleetWebScreenState extends State<FleetWebScreen> {
  final authProvider = locator<AuthProvider>();
  TextEditingController bidAmtController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController sourceController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController filterController = TextEditingController();
  var selectedPageNumber = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FleetProvider>(
      builder: (context, model, child) => Container(
        padding: ResponsiveWidget.isDesktop(context)?EdgeInsets.symmetric(horizontal: 35):EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [

            model.fleetList.isEmpty && model.isLoading == false

                ? Expanded(
                child: Container(
                    height: MediaQuery.of(context).size.height - 200,
                    child: Center(child: Text(getTranslated('no_post', context)!,style: Style.heading,))))
                : Expanded(
                    child: StaggeredGridView.countBuilder(
                    physics: ScrollPhysics(),
                    crossAxisCount: ResponsiveWidget.isDesktop(context)
                        ? 3
                        : ResponsiveWidget.isMobile(context)
                            ? 1
                            : 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 12,
                    itemCount: model.fleetList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                        /*  Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) =>
                                      FleetDetails(model.fleetList[index])));*/
                        },
                        child: Card(
                          elevation: 5,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 7),
                                  child: CustomText(
                                      model.fleetList[index].typeOfVehicle
                                          .toString(),
                                      style: titilliumSemiBold),
                                ),
                                /*  Padding(
                                padding: const EdgeInsets.only(left: 10.0,bottom: 10,right: 10),
                                child: Text(widget.fleetList[index].vehicleNumber.toString(),
                                  style: regularTextStyle,),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0,bottom: 10,right: 10),
                                child: Text(widget.fleetList[index].weightInTonnes.toString(),
                                  style: regularTextStyle,),
                              ),*/
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, bottom: 10, right: 10),
                                  child: Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                            getTranslated('v_type', context)!,
                                            style: Style.vehicleLable,
                                          ),
                                          CustomText(
                                              getTranslated(
                                                  'v_number', context)!,
                                              style: Style.vehicleLable),
                                          CustomText(
                                               getTranslated('weight', context)!,
                                              style: Style.vehicleLable),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                              ': ${model.fleetList[index].typeOfVehicle.toString()}',
                                              style: Style.vehicleData),
                                          CustomText(
                                              ': ${model.fleetList[index].vehicleNumber.toString()}',
                                              style: Style.vehicleData),
                                          CustomText(
                                              ': ${model.fleetList[index].weightInTonnes.toString()}',
                                              style: Style.vehicleData),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  height: 1.5,
                                  thickness: 1.5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      InkWell(
                                        onTap: () async {},
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.edit,
                                              color: ColorResources.PRIMARY_COLOR,
                                              size: 16,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            CustomText(
                                                "Edit",
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
                                                    title: CustomText(
                                                        'Are you sure want to deleted your post?'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child: Text(
                                                            getTranslated('yes',
                                                                context)!,
                                                            style: TextStyle(
                                                                color:
                                                                    ColorResources
                                                                        .RED)),
                                                        onPressed: () {
                                                          model
                                                              .deleteFleet(model
                                                                      .fleetList[
                                                                  index])
                                                              .then((value) => {
                                                                    showAnimatedDialog(
                                                                        context,
                                                                        MyDialog(
                                                                          icon:
                                                                              Icons.check,
                                                                          title:
                                                                              'Post Delete',
                                                                          description:
                                                                              'Your post deleted successfully',
                                                                          isFailed:
                                                                              false,
                                                                        ),
                                                                        dismissible:
                                                                            false,
                                                                        isFlip:
                                                                            true)
                                                                  });
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                      TextButton(
                                                        child: Text(
                                                          getTranslated(
                                                              'no', context)!,
                                                          style: TextStyle(
                                                              color:
                                                                  ColorResources
                                                                      .GREEN),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  ));
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.delete,
                                              color: ColorResources.PRIMARY_COLOR,
                                              size: 16,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            CustomText(
                                                "Delete",
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
                    //physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                  )),
            getLoader(model.isLoading)
          ],
        ),
      ),
    );
  }
}
