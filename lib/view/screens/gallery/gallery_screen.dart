import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/provider/gallery_provider.dart';
import 'package:tkd_app/provider/localization_provider.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/date_converter.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/custom_textview.dart';
import 'package:tkd_app/view/base_widget/getImage.dart';
import 'package:tkd_app/view/base_widget/getLoader.dart';
import 'package:tkd_app/view/localization/language_constrants.dart';
import 'package:tkd_app/view/screens/gallery/view_image-dialog.dart';

class GalleryScreen extends StatefulWidget {
  final galleryProvider = locator<GalleryProvider>();

  GalleryScreen({Key? key}) : super(key: key) {
    galleryProvider.getCard();
  }

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.HOME_BG,
      body: Container(
        color: ColorResources.HOME_BG,
        child: ResponsiveWidget(
          desktop: GallaryCard(),
          mobile: GallaryCard(),
          tablet: GallaryCard(),
        ),
      ),
    );
  }
}

class GallaryCard extends StatefulWidget {
  @override
  _GallaryCardState createState() => _GallaryCardState();
}

class _GallaryCardState extends State<GallaryCard> {
  final galleryProvider = locator<GalleryProvider>();
  ScrollController _scrollController = ScrollController();

  final langProvider = locator<LocalizationProvider>();
  String? langCode;


  @override
  void initState() {
    super.initState();
    langCode = langProvider.selectedlangCode;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        galleryProvider.getCard(currentPage: selectedPageNumber);
        selectedPageNumber++;
      }
    });
  }

  var selectedPageNumber = 1;

  @override
  Widget build(BuildContext context) {
    return Consumer<GalleryProvider>(
      builder: (context, model, child) => Container(
        margin: ResponsiveWidget.isDesktop(context)?EdgeInsets.symmetric(horizontal: 35,vertical: 10):EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [

            model.imageList.isEmpty && model.isLoading == false

                ? Expanded(
                child: Container(
                    height: MediaQuery.of(context).size.height - 200,
                    child: Center(child: Text(getTranslated('no_post', context)!,style: Style.heading,))))
                : model.imageList.isEmpty && model.isLoading ? SizedBox(height: MediaQuery.of(context).size.height/2.5,)
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
                      itemCount: model.imageList.length,
                      itemBuilder: (context, index) {
                        return Card(
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
                                      .imageList[index].profilePicture
                                      .toString()),
                                  title: langCode == 'en' ? Text(model.imageList[index].firstName
                                      .toString(),
                                      style: Style.title):CustomText(
                                      model.imageList[index].firstName
                                          .toString(),
                                      style: Style.title),
                                  subtitle: langCode == 'en' ? Text( model.imageList[index].topicName
                                      .toString(),
                                      style: Style.subtitle):CustomText(
                                      model.imageList[index].topicName
                                          .toString(),
                                      style: Style.subtitle),
                                  trailing: ConvertStringToDate(
                                      model.imageList[index].date.toString()),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 10),
                                  child: InkWell(
                                    onTap: () async {
                                      await showDialog(
                                          context: context,
                                          builder: (_) => ImageDialog(
                                              model.imageList[index].image!));
                                    },
                                    child: Container(
                                      height: 100,
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.symmetric(horizontal: ResponsiveWidget.isDesktop(context)? 50:20),
                                      decoration: BoxDecoration(
                                        color: Colors.white
                                        /*image: DecorationImage(
                                          //  fit: BoxFit.fill,
                                          image: NetworkImage(
                                              '${model.imageList[index].image}'),
                                        ),*/
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10.0),
                                        child: PhotoView(
                                          backgroundDecoration: BoxDecoration(color: Colors.grey[100]),
                                            imageProvider: NetworkImage(
                                                '${model.imageList[index].image}'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, bottom: 10, right: 10),
                                  child: langCode == 'en' ? Text( model.imageList[index].description
                                      .toString(),
                                    style: Style.content,):CustomText(
                                    model.imageList[index].description
                                        .toString(),
                                    style: Style.content,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      //  physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                    ),
                  ),
            getLoader(model.isLoading)
          ],
        ),
      ),
    );
  }
}
