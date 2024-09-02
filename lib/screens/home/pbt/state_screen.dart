// state_screen.dart
import 'package:flutter/material.dart';
import 'package:project/app/helpers/shared_preferences.dart';
import 'package:project/constant.dart';
import 'package:project/routes/route_manager.dart';
import 'package:project/screens/home/pbt/state_pbt_mapping.dart';
import 'package:project/theme.dart';

class StateScreen extends StatefulWidget {
  const StateScreen({super.key});

  @override
  State<StateScreen> createState() => _StateScreenState();
}

class _StateScreenState extends State<StateScreen> {
  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    Map<String, dynamic> details =
        arguments['locationDetail'] as Map<String, dynamic>;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        toolbarHeight: 100,
        foregroundColor: details['color'] == 4294961979 ? kBlack : kWhite,
        backgroundColor: Color(details['color']),
        centerTitle: true,
        title: Text(
          'Select State',
          style: textStyleNormal(
            fontSize: 26,
            color: details['color'] == 4294961979 ? kBlack : kWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: statesList.length,
        itemBuilder: (context, index) {
          String state = statesList[index];
          String flag = stateFlagMap[state] ?? '';

          return ListTile(
            onTap: () async {
              if (state == details['state']) {
                return;
              } else {
                // Navigate to the PbtScreen
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoute.pbtScreen,
                  ModalRoute.withName(AppRoute.stateScreen),
                  arguments: {
                    'locationDetail': details,
                    'state': state,
                  },
                );
              }
            },
            tileColor: state == details['state']
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
                  image: AssetImage(flag),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Text(
              state,
              style: textStyleNormal(
                fontWeight: state == details['state']
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
            trailing: state == details['state']
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
