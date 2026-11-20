import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/app_constants.dart';

class CustomCityListDialog extends StatefulWidget {
  final Function(String) onTap;
  const CustomCityListDialog({required this.onTap, Key? key}) : super(key: key);

  @override
  State<CustomCityListDialog> createState() => _CustomCityListDialogState();
}

class _CustomCityListDialogState extends State<CustomCityListDialog> {
  List<String> cityList = [];
  List<String> foundCity = [];
  bool isLoading = false;

  int page = 0;
  final int size = 100;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCities('');
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        fetchCities(_searchCtrl.text.trim());
      }
    });
  }

  Future<void> fetchCities(String search) async {
    if (isLoading) return;

    setState(() => isLoading = true);

    String url =
        "${ApiConstant.BASE_URL}get/cities/db/page/search?city=$search&page=$page&size=$size";

    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (response.statusCode == 200 && data is List) {
        if (page == 0) cityList.clear();

        final List<String> newCities =
        data.map<String>((e) => e.toString()).toList();

        cityList.addAll(newCities);

        // Remove duplicates & update found list
        foundCity = cityList.toSet().toList();
        page++;
      }
    } catch (e) {
      debugPrint('City fetch error: $e');
    }

    setState(() => isLoading = false);
  }

  void searchCity(String query) {
    page = 0;
    fetchCities(query);
  }
  @override
  Widget build(BuildContext context) {

    // ⭐ Dialog width handling
    double dialogWidth = ResponsiveWidget.isDesktop(context)
        ? 450                       // Desktop fixed width
        : MediaQuery.of(context).size.width * 0.90;    // Mobile / Tablet responsive

    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: ResponsiveWidget.isDesktop(context) ? 0 : 16,
        vertical: 24,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: dialogWidth,
        constraints: BoxConstraints(
          maxHeight: ResponsiveWidget.isDesktop(context) ? 600 : 500,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🔴 HEADER
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFC3262C),
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: const Text(
                "Select City",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 🔍 SEARCH FIELD
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (value) {
                  page = 0;
                  searchCity(value);
                },
                decoration: InputDecoration(
                  labelText: "Search City",
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 📍 CITY LIST
            Expanded(
              child: foundCity.isEmpty && !isLoading
                  ? const Center(
                child: Text(
                  "No results found",
                  style: TextStyle(fontSize: 16),
                ),
              )
                  : ListView.builder(
                controller: _scrollController,
                itemCount: foundCity.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      widget.onTap(foundCity[index]);
                      Navigator.pop(context); // ⭐ Close dialog on select
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_city,
                              color: Colors.black54),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              foundCity[index],
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(12),
                child: CircularProgressIndicator(),
              ),

            // ❌ CANCEL BUTTON
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
