import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../locator.dart';
import '../../../model/allNewsResponse.dart';
import '../../../model/auth_api.dart';
import '../../../provider/auth_provider.dart';
import '../../../provider/news_provider.dart';
import '../../../util/ResponsiveWidget.dart';
import '../../../util/colors.dart';
import '../../../util/images.dart';
import '../../../widgets/base_widgets.dart';
import '../../base_widget/app_constant.dart';

class AllNewsScreen extends StatefulWidget {
  const AllNewsScreen();

  @override
  State<StatefulWidget> createState() => _AllNewsScreenState();
}

class _AllNewsScreenState extends State<AllNewsScreen> {
  final ScrollController _scrollController = ScrollController();

  User? user;
  List<User> userDetailList = [];

  final authProvider = locator<AuthProvider>();
  final newsProvider = locator<NewsProvider>();

  @override
  void initState() {
    super.initState();
    getUser();

    // Pagination
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        newsProvider.loadMore();
      }
    });
  }


  getUser() async {
    int? empid = await authProvider.getEmpId();
    if (empid != null) {
      userDetailList = await authProvider.getUserDetails(empid);
      user = userDetailList[0];
    }
    newsProvider.toggleMyNews(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<NewsProvider>(
        builder: (context, provider, child) {
          return RefreshIndicator(
            onRefresh: () async {
              provider.toggleMyNews(provider.myNews);
            },
            child: Container(
              color: ThemeColor.baground,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  allNewsTag(provider),

                  /// Empty state UI
                  if (provider.allNews.isEmpty && !provider.isLoading)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "No news found",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  /// Shimmer when loading first time
                  if (provider.allNews.isEmpty && provider.isLoading)
                    Expanded(child: shimmerList()),

                  /// Actual data list
                  if (provider.allNews.isNotEmpty)
                    Expanded(child: allNewsData()),

                  /// Loading more...
                  if (provider.isLoadingMore)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2)),
                              SizedBox(width: 12),
                              Text("Loading more...",
                                  style: TextStyle(color: Colors.black54)),
                            ],
                          )),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// ------------------ SHIMMER LOADING ------------------
  Widget shimmerList() {
    return StaggeredGridView.countBuilder(
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      itemCount: 6,
      crossAxisSpacing: 10,
      mainAxisSpacing: 12,
      staggeredTileBuilder: (_) => StaggeredTile.fit(1),
      itemBuilder: (_, __) => shimmerCard(),
    );
  }

  Widget shimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 1,
              blurRadius: 6,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 14, width: 100, color: Colors.white),
            SizedBox(height: 10),
            Container(height: 10, width: 150, color: Colors.white),
            SizedBox(height: 10),
            Container(height: 140, color: Colors.white),
            SizedBox(height: 10),
            Container(height: 10, width: 80, color: Colors.white),
          ],
        ),
      ),
    );
  }

  /// ------------------ ACTUAL NEWS GRID ------------------
  Widget allNewsData() {
    return Consumer<NewsProvider>(
      builder: (context, provider, child) {
        return StaggeredGridView.countBuilder(
          controller: _scrollController,
          physics: BouncingScrollPhysics(),
          crossAxisCount: ResponsiveWidget.isDesktop(context)
              ? 3
              : ResponsiveWidget.isMobile(context)
              ? 1
              : 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 12,
          itemCount: provider.allNews.length,
          staggeredTileBuilder: (_) => StaggeredTile.fit(1),
          itemBuilder: (context, index) {
            return newsCard(provider.allNews[index]);
          },
        );
      },
    );
  }

  /// ------------------ NEWS CARD ------------------
  Widget newsCard(Content content) {
    return Consumer<NewsProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black12, // Light shadow
                spreadRadius: 1,
                blurRadius: 6,
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header: Title + Delete
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      content.topicName ?? "",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (user?.id == content.userId)
                    InkWell(
                      onTap: () => showDeletePopup(content, provider),
                      child: SvgPicture.asset(Images.delete),
                    ),
                ],
              ),

              SizedBox(height: 8),

              Text(
                content.description ?? "",
                style: TextStyle(
                  color: Color(0x99001E49),
                  fontSize: 12,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                ),
              ),

              SizedBox(height: 12),

              BaseWidget().image(context,image: content.image ?? ""),

              SizedBox(height: 10),

              if (content.youtubeLink != null &&
                  content.youtubeLink!.isNotEmpty)
                InkWell(
                  onTap: () => _launchURL(content.youtubeLink!),
                  child: Text(
                    content.youtubeLink!,
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 13,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
            ],
          ),
        );
      },
    );
  }

  /// ------------------ SEARCH BAR ------------------
  Widget serachBarFilter() {
    return Consumer<NewsProvider>(
      builder: (context, provider, child) {
        return Container(
          width: 260,
          height: 52,
          padding: EdgeInsets.symmetric(horizontal: 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Color(0x332C363F)),
          ),
          child: Row(
            children: [
              SizedBox(width: 10),
              SvgPicture.asset(Images.search_normal, width: 24),
              SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: provider.searchController,
                  onChanged: (_) => provider.getBySearchData(),
                  decoration: InputDecoration(
                    hintText: "Search News",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// ------------------ TAB BAR ------------------
  Widget allNewsTag(NewsProvider provider) {
    return Container(
      margin: EdgeInsets.only(left: 20, top: 0,bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ChoiceChip(
            backgroundColor: Colors.transparent,
            selectedColor: ThemeColor.red,
            label: Text(
              "All News",
              style: TextStyle(
                color: !provider.myNews ? Colors.white : Colors.black,
                fontSize: 12,
              ),
            ),
            selected: !provider.myNews,
            onSelected: (_) => provider.toggleMyNews(false),
          ),
          ChoiceChip(
            backgroundColor: Colors.transparent,
            selectedColor: ThemeColor.red,
            label: Text(
              "My News",
              style: TextStyle(
                color: provider.myNews ? Colors.white : Colors.black,
                fontSize: 12,
              ),
            ),
            selected: provider.myNews,
            onSelected: (_) => provider.toggleMyNews(true),
          ),
          serachBarFilter()
        ],
      ),
    );
  }

  /// ------------------ Delete popup ------------------
  Future<void> showDeletePopup(Content content, NewsProvider provider) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: Text("Delete",
              style: TextStyle(
                  fontFamily: AppConstant.FONTFAMILY,
                  color: ThemeColor.theme_blue)),
          content: Text(
            "Are you sure you want to delete this news?",
            style: TextStyle(
                fontFamily: AppConstant.FONTFAMILY,
                color: ThemeColor.theme_blue),
          ),
          actions: [
            TextButton(
              child: Text("Delete",
                  style: TextStyle(
                      fontFamily: AppConstant.FONTFAMILY,
                      color: ThemeColor.red)),
              onPressed: () {
                provider.deletePost(content, context);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("No",
                  style: TextStyle(
                      fontFamily: AppConstant.FONTFAMILY,
                      color: ThemeColor.green)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  /// URL launcher
  Future<void> _launchURL(String url) async {
    if (!url.startsWith('http')) url = 'https://$url';
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
