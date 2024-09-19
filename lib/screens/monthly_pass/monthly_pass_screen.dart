import 'package:flutter/material.dart';
import 'package:project/constant.dart';
import 'package:project/models/models.dart';
import 'package:project/screens/screens.dart';
import 'package:project/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MonthlyPassScreen extends StatelessWidget {
  const MonthlyPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    Map<String, dynamic> details =
        arguments['locationDetail'] as Map<String, dynamic>;
    UserModel? userModel = arguments['userModel'] as UserModel?;
    List<PlateNumberModel>? plateNumbers =
        arguments['plateNumbers'] as List<PlateNumberModel>?;
    List<PBTModel>? pbtModel = arguments['pbtModel'] as List<PBTModel>?;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        toolbarHeight: 100,
        foregroundColor: details['color'] == 4294961979 ? kBlack : kWhite,
        backgroundColor: Color(details['color']),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              AppLocalizations.of(context)!.monthlyPass,
              style: textStyleNormal(
                fontSize: 26,
                color: details['color'] == 4294961979 ? kBlack : kWhite,
                fontWeight: FontWeight.bold,
              ),
            ),
            spaceVertical(height: 5.0),
            Text(
              AppLocalizations.of(context)!.onStreet,
              style: textStyleNormal(
                color: details['color'] == 4294961979 ? kBlack : kWhite,
              ),
            ),
          ],
        ),
      ),
      body: MonthlyPassBody(
        carPlates: plateNumbers!,
        details: details,
        pbtModel: pbtModel!,
        userModel: userModel!,
      ),
    );
  }
}
