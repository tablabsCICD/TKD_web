import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';

import '../../../provider/bulk_upload_provider.dart';
import '../../../util/colors.dart';
import '../../../util/images.dart';
import '../../../widgets/bottomsheet.dart';
import '../../../widgets/button.dart';
import '../../../widgets/drop_down.dart';
import '../../base_widget/app_constant.dart';
import 'file_downloader.dart';

class BulkUploadLoad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BulkUploadProvider(),
      child: const _BulkUploadWebUI(),
    );
  }
}

class _BulkUploadWebUI extends StatelessWidget {
  const _BulkUploadWebUI();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.baground,
      appBar: ResponsiveWidget.isMobile(context)?AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Bulk Upload"),
      ):null,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Consumer<BulkUploadProvider>(
              builder: (context, provider, _) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      _tabs(provider),

                      const SizedBox(height: 24),

                      _label("Show Post to "),

                      const SizedBox(height: 6),

                    DropdownButtonFormField<String>(
                      value: provider.selectedGroup == "Select One"
                          ? null
                          : provider.selectedGroup,
                      hint: const Text("Select One"),
                      items: provider.listOptionShow
                          .map(
                            (item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        ),
                      )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;

                        final index = provider.listOptionShow.indexOf(value);
                        provider.selecteOptiontoShow(index, context);
                      },
                      decoration: InputDecoration(
                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                      _uploadArea(context, provider),

                      const SizedBox(height: 12),

                      Center(
                        child: InkWell(
                          onTap: () {
                            FileDownloader.downloadFile(context);
                          },
                          child: Text(
                            "Before Upload Excel,Click Here to Download Format",
                            style: TextStyle(
                              color: ThemeColor.red,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      Button(
                        width: double.infinity,
                        height: 48,
                        title: "Upload",
                        onClick: () {
                          provider.selectFile(context);
                        },
                        isEnbale: true, textStyle: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // -------------------- Upload Box --------------------

  Widget _uploadArea(BuildContext context, BulkUploadProvider provider) {
    return InkWell(
      onTap: () => provider.selectFile(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: ThemeColor.theme_blue.withOpacity(0.4),
            style: BorderStyle.solid,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          children: [
            SvgPicture.asset(
              Images.add_image,
              height: 60,
            ),
            const SizedBox(height: 12),
            Text(
              "Click to upload Excel file",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: ThemeColor.subColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "(.xlsx only)",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------- Tabs --------------------

  Widget _tabs(BulkUploadProvider provider) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0x332C363F),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _tabItem(
            title: "Loads",
            isSelected: provider.isLoad,
            onTap: () {
              provider.isLoad = true;
              provider.changeTab();
            },
          ),
         _tabItem(
              title: "Vehicle",
              isSelected: !provider.isLoad,
              onTap: () {
                provider.isLoad = false;
                provider.changeTab();
              },
            ),
        ],
      ),
    );
  }

  Widget _tabItem({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? ThemeColor.theme_blue : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected
                  ? ThemeColor.progress_color
                  : ThemeColor.subColor,
              fontSize: 13,
              fontWeight:
              isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  // -------------------- Label --------------------

  Widget _label(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
