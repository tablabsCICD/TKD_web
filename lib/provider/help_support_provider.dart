import 'package:flutter/cupertino.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/network/api_call.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/util/app_constants.dart';
import 'package:tkd_app/widgets/toast.dart';

class HelpSupportProvider extends ChangeNotifier {
  String dropValue = "Select the Topic";
  String remaningText = "300 Max";
  bool enableButton = false;
  final authProvider = locator<AuthProvider>();

  TextEditingController textEditingController = TextEditingController();

  HelpSupportProvider();

  changeDropDown(String val) {
    dropValue = val;
    notifyListeners();
  }

  sumbitTicket(BuildContext context) async {
    if (dropValue == "Select the Topic") {
      ToastMessage.show(context, "Please Select Topic");
    } else {
      if (textEditingController.text.length > 0) {
        Map<String, dynamic> parameter = {
          "concern": textEditingController.text,
          "id": 0,
          "loggedUserName": "${"from web"}",
          "topic": dropValue
        };

        var apiResponse = await ApiHelper()
            .ApiAddPostDataMapRequest(ApiConstant.HELPSUPPORTIKET, parameter);
        print('the code is ${apiResponse.statusCode}');
        if (apiResponse.statusCode == 200) {
          ToastMessage.show(context, "Ticket send successfully");
          dropValue = "select the Topic";
          textEditingController.clear();
          notifyListeners();
        } else {
          ToastMessage.show(context, "Please try again");
        }
      } else {
        ToastMessage.show(context, "Please Explain your concern");
      }
    }
    validation();
    notifyListeners();
  }

  countText() {
    int tot = 300 - textEditingController.text.length;
    remaningText = "$tot ${"Max"}";
    validation();
    notifyListeners();
  }

  validation() {
    if (dropValue != "Select the Topic" &&
        textEditingController.text.length > 0) {
      enableButton = true;
    } else {
      enableButton = false;
    }
  }
}
