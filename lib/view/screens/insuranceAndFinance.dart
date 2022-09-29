import 'package:flutter/material.dart';
import 'package:tkd_app/open_whatsapp.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/localization/language_constrants.dart';

class InsuranceAndFinanceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveWidget.isDesktop(context)?EdgeInsets.symmetric(horizontal: 35,vertical: 20):EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      color: ColorResources.HOME_BG,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Card(
            elevation: 5,
            child: ListTile(
              onTap: (){
                openwhatsapp(context, '9870205040', 'please contact for more details');
              },
              tileColor: Colors.white,
              title: Text(getTranslated('vehicle_insurance', context)!,style: Style.insuranceHeading,),
              subtitle: Text(getTranslated('vi_info', context)!,style: Style.insuranceSubHeading,),
            ),
          ),
         // Divider(),
          Card(
            elevation: 5,
            child: ListTile(
              onTap: (){
                openwhatsapp(context, '9870205040', 'please contact for more details');
              },
              tileColor: Colors.white,
              title: Text(getTranslated('theft_insurance', context)!,style: Style.insuranceHeading,),
              subtitle: Text(getTranslated('ti_info', context)!,style: Style.insuranceSubHeading,),
            ),
          ),
          Divider(),
         /* ListTile(
            onTap: (){
              openwhatsapp(context, '9870205040', 'please contact for more details');
            },
            tileColor: Colors.white,
            title: Text('Mediclaim Insurance Policy'),
            subtitle: Text('Value your health & your wealth'),
          ),
          Divider(),
          ListTile(
            onTap: (){
              openwhatsapp(context, '9870205040', 'please contact for more details');
            },
            tileColor: Colors.white,
            title: Text('Fire Insurance Policy'),
            subtitle: Text('An insurance plan to indemnify against damage to property'),
          ),
          Divider(),
          ListTile(
            onTap: (){
              openwhatsapp(context, '9870205040', 'please contact for more details');
            },
            tileColor: Colors.white,
            title: Text('Marine Single Voyage Inland Policy'),
            subtitle: Text('Marine single voyage inland policy'),
          ),
          Divider(),*/

        ],
      ),
    );
  }
}
