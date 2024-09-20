import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/app/helpers/shared_preferences.dart';
import 'package:project/constant.dart';
import 'package:project/routes/route_manager.dart';
import 'package:project/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:project/widget/loading_dialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool isDropDownLanguage;

  @override
  void initState() {
    super.initState();
    isDropDownLanguage = false;
  }

  @override
  Widget build(BuildContext context) {
    List<String> language = [
      AppLocalizations.of(context)!.malay,
      AppLocalizations.of(context)!.english,
    ];

    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    Map<String, dynamic> details =
        arguments['locationDetail'] as Map<String, dynamic>;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        toolbarHeight: 100,
        foregroundColor: details['color'] == 4294961979 ? kBlack : kWhite,
        backgroundColor: Color(details['color'] ?? 0xFFFFFFFF),
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.settings,
          style: textStyleNormal(
            fontSize: 26,
            color: details['color'] == 4294961979 ? kBlack : kWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            onTap: () {
              setState(() {
                isDropDownLanguage = !isDropDownLanguage;
              });
            },
            leading: const Icon(
              Icons.language,
              color: kPrimaryColor,
            ),
            title: Text(
              AppLocalizations.of(context)!.language,
              style: textStyleNormal(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Icon(isDropDownLanguage
                ? Icons.keyboard_arrow_up
                : Icons.keyboard_arrow_down),
          ),
          if (isDropDownLanguage)
            ListView.builder(
              itemCount: language.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () async {
                    // Save the selected language and update locale
                    if (index == 0) {
                      await SharedPreferencesHelper.saveLanguage('ms');
                      Get.updateLocale(const Locale('ms'));
                    } else {
                      await SharedPreferencesHelper.saveLanguage('en');
                      Get.updateLocale(const Locale('en'));
                    }

                    // Show the loading dialog
                    LoadingDialog.show(context);

                    // Simulate a delay for processing
                    await Future.delayed(const Duration(milliseconds: 500));

                    // Hide the loading dialog
                    LoadingDialog.hide(context);

                    // Reload the screen with new settings
                    Navigator.popAndPushNamed(
                      context,
                      AppRoute.settingsScreen,
                      arguments: {
                        'locationDetail': details,
                      },
                    );
                  },
                  leading: const SizedBox.shrink(),
                  title: Text(
                    language[index],
                    style: textStyleNormal(
                      fontSize: 18,
                    ),
                  ),
                  trailing:
                      Get.locale?.languageCode == (index == 0 ? 'ms' : 'en')
                          ? const Icon(
                              Icons.done,
                              weight: 800,
                            )
                          : const SizedBox.shrink(),
                );
              },
            ),
        ],
      ),
    );
  }
}
