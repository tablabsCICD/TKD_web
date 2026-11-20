// ReportIncidentList.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/locator.dart';

import '../../../model/auth_api.dart';
import '../../../model/getAllReportIncidentResponse.dart';
import '../../../provider/auth_provider.dart';
import '../../../provider/report_incident_provider.dart';
import '../../../util/ResponsiveWidget.dart';
import '../../../util/colors.dart';
import '../../../util/images.dart';
import '../../../widgets/base_widgets.dart';

class ReportIncidentList extends StatefulWidget {
  const ReportIncidentList();

  @override
  State<ReportIncidentList> createState() => _ReportIncidentListState();
}

class _ReportIncidentListState extends State<ReportIncidentList> {
  User? user;
  final authProvider = locator<AuthProvider>();

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  loadUser() async {
    int? empId = await authProvider.getEmpId();
    if (empId != null) {
      var list = await authProvider.getUserDetails(empId);
      user = list[0];
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.baground,
      body: Consumer<ReportIncidentProvider>(
        builder: (context, provider, child) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  /// TOP ROW: FILTERS + SEARCH
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTabs(provider),
                      _buildSearch(provider),
                    ],
                  ),

                  SizedBox(height: 16),

                  /// EMPTY STATE
                  if (provider.allIncidents.isEmpty && provider.isLoading)
                    Expanded(
                      child: Center(
                        child: Text(
                          "No incidents found",
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: Colors.black54),
                        ),
                      ),
                    )
                  else
                    Expanded(child: _buildIncidentGrid(provider)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // -----------------------------------------------------
  // FILTER TABS (ALL / MY INCIDENT)
  // -----------------------------------------------------
  Widget _buildTabs(ReportIncidentProvider provider) {
    return Row(
      children: [
        ChoiceChip(
          label: Text("All Incidents"),
          selected: !provider.isMyIncident,
          selectedColor: ColorResources.PRIMARY_COLOR,
          labelStyle: GoogleFonts.poppins(
              color: !provider.isMyIncident ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600),
          onSelected: (_) => provider.toggleMyIncidents(false,context),
        ),
        SizedBox(width: 10),
        ChoiceChip(
          label: Text("My Incidents"),
          selected: provider.isMyIncident,
          selectedColor: ColorResources.PRIMARY_COLOR,
          labelStyle: GoogleFonts.poppins(
              color: provider.isMyIncident ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600),
          onSelected: (_) => provider.toggleMyIncidents(true,context),
        ),
      ],
    );
  }

  // -----------------------------------------------------
  // SEARCH BAR
  // -----------------------------------------------------
  Widget _buildSearch(ReportIncidentProvider provider) {
    return Container(
      width: 260,
      height: 45,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          SvgPicture.asset(Images.search_normal, width: 20),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: provider.searchController,
              onChanged: (_) => provider.searchIncidents(),
              decoration: InputDecoration(
                hintText: "Search incidents...",
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -----------------------------------------------------
  // INCIDENT GRID
  // -----------------------------------------------------
  Widget _buildIncidentGrid(ReportIncidentProvider provider) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: ResponsiveWidget.isDesktop(context)
          ? 3
          : ResponsiveWidget.isMobile(context)
          ? 1
          : 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      itemCount: provider.allIncidents.length,
      staggeredTileBuilder: (_) => StaggeredTile.fit(1),
      itemBuilder: (_, index) {
        final incident = provider.allIncidents[index];
        return _incidentCard(incident, provider);
      },
    );
  }

  // -----------------------------------------------------
  // INCIDENT CARD
  // -----------------------------------------------------
  Widget _incidentCard(IncidentObject item, ReportIncidentProvider provider) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(item.date ?? 0);
    String formatted = DateFormat("yyyy-MM-dd").format(date);

    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (_) => _incidentDialog(item, provider),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // White card
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.08),
              blurRadius: 6,
              offset: Offset(0, 3),
            )
          ],
        ),
        padding: EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (user != null && user!.id == item.userId)
              Align(
                alignment: AlignmentGeometry.topRight,
                child: InkWell(
                    onTap: () => _confirmDelete(item, provider),
                    child: SvgPicture.asset(Images.delete, width: 22)),
              ),
            item.image != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: BaseWidget().image(context,image: item.image!),
            )
                : Container(
              height: 120,
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(Icons.image_not_supported,
                  size: 40, color: Colors.grey),
            ),

            SizedBox(height: 12),

            Text(
              item.incidentType ?? "Incident",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87),
            ),

            SizedBox(height: 4),

            _infoRow("Cheated By", item.cheatedBy),
            _infoRow("Amount Lost", item.amountLost),
            _infoRow("Date", formatted),
            _infoRow("FIR Launched",
                item.isFirLounched == true ? "Yes" : "No"),

            SizedBox(height: 8),

            Text(
              item.resolutionDetails?.isNotEmpty == true
                  ? item.resolutionDetails!
                  : "No resolution details",
              style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, dynamic value) {
    return Text(
      "$label: ${value ?? "N/A"}",
      style: GoogleFonts.poppins(
          fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black54),
    );
  }

  // -----------------------------------------------------
  // INCIDENT DETAILS DIALOG
  // -----------------------------------------------------
  Widget _incidentDialog(
      IncidentObject item, ReportIncidentProvider provider) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(item.date ?? 0);
    String formatted = DateFormat("yyyy-MM-dd HH:mm").format(date);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              item.incidentType ?? "Incident Details",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),

          if (user != null && user!.id == item.userId)
            InkWell(
                onTap: () => _confirmDelete(item, provider),
                child: SvgPicture.asset(Images.delete, width: 22)),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            item.image != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: BaseWidget().image(context,image: item.image!),
            )
                : Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8)),
              child: Icon(Icons.image_not_supported),
            ),

            SizedBox(height: 16),

            _detailTile("Cheated By", item.cheatedBy),
            _detailTile("Amount Lost", item.amountLost),
            _detailTile("Date", formatted),
            _detailTile("FIR Launched",
                item.isFirLounched == true ? "Yes" : "No"),
            _detailTile("Resolution", item.resolutionDetails),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close")),
      ],
    );
  }

  Widget _detailTile(String label, dynamic value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
              width: 120,
              child: Text("$label:",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600, color: Colors.black87))),
          Expanded(
              child: Text(value?.toString() ?? "N/A",
                  style: GoogleFonts.poppins(color: Colors.black54))),
        ],
      ),
    );
  }

  // -----------------------------------------------------
  // DELETE CONFIRMATION
  // -----------------------------------------------------
  void _confirmDelete(
      IncidentObject item, ReportIncidentProvider provider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Delete"),
        content: Text("Do you want to delete this incident?"),
        actions: [
          TextButton(
            onPressed: () {
              provider.deleteIncident(item, context);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }
}
