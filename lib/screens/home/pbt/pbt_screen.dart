// pbt_screen.dart
import 'package:flutter/material.dart';
import 'package:project/app/helpers/shared_preferences.dart';
import 'package:project/constant.dart';
import 'package:project/routes/route_manager.dart';
import 'package:project/screens/home/pbt/state_pbt_mapping.dart';
import 'package:project/theme.dart';

class PbtScreen extends StatefulWidget {
  const PbtScreen({super.key});

  @override
  State<PbtScreen> createState() => _PbtScreenState();
}

class _PbtScreenState extends State<PbtScreen> {
  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    Map<String, dynamic> details =
        arguments['locationDetail'] as Map<String, dynamic>;

    String selectedState = arguments['state'] as String;
    List<Map<String, dynamic>> pbtList = statePbtMap[selectedState] ?? [];

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        toolbarHeight: 100,
        foregroundColor: details['color'] == 4294961979 ? kBlack : kWhite,
        backgroundColor: Color(details['color']),
        centerTitle: true,
        title: Text(
          'Select PBT',
          style: textStyleNormal(
            fontSize: 26,
            color: details['color'] == 4294961979 ? kBlack : kWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: pbtList.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () async {
              await SharedPreferencesHelper.saveLocationDetail(
                state: selectedState,
                location: pbtList[index]['name'],
                color: pbtList[index]['color'],
                logo: pbtList[index]['logo'],
              );

              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoute.homeScreen,
                (route) => false,
              );
            },
            tileColor: pbtList[index]['name'] == details['location']
                ? Color(details['color']).withOpacity(0.4)
                : null,
            leading: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(50),
                ),
                image: DecorationImage(
                  image: AssetImage(pbtList[index]['logo']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Text(
              pbtList[index]['name'],
              style: textStyleNormal(
                fontWeight: pbtList[index]['name'] == details['location']
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
            trailing: pbtList[index]['name'] == details['location']
                ? const Icon(
                    Icons.check,
                    color: kBlack,
                  )
                : null,
          );
        },
      ),
    );
  }
}
