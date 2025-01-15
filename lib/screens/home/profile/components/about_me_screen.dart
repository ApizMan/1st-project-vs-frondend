import 'package:flutter/material.dart';
import 'package:project/constant.dart';
import 'package:project/models/models.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:project/theme.dart';
import 'package:project/widget/primary_button.dart';

Future<void> displayAboutMe(BuildContext context, UserModel userModel) {
  return showModalBottomSheet(
    context: context,
    isDismissible: false,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              width: 100,
              child: const Divider(
                color: kGrey,
                thickness: 3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.aboutMe,
                      style: textStyleNormal(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: kBlack,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.name,
                      style: textStyleNormal(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: Text(
                      userModel.firstName!,
                      style: textStyleNormal(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (userModel.idNumber!.isNotEmpty)
                    Column(
                      children: [
                        Center(
                          child: Text(
                            AppLocalizations.of(context)!.idNumber,
                            style: textStyleNormal(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Center(
                          child: Text(
                            userModel.idNumber!,
                            style: textStyleNormal(
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  Center(
                    child: Text(
                      Localizations.of(context, AppLocalizations).phoneNumber,
                      style: textStyleNormal(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: Text(
                      userModel.phoneNumber!,
                      style: textStyleNormal(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.email,
                      style: textStyleNormal(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: Text(
                      userModel.email!,
                      style: textStyleNormal(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.address,
                      style: textStyleNormal(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          userModel.address1!,
                          style: textStyleNormal(
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          userModel.address2!,
                          style: textStyleNormal(
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          userModel.address3 ?? '',
                          style: textStyleNormal(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      userModel.postcode!.toString(),
                      style: textStyleNormal(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      ' ${userModel.city!}',
                      style: textStyleNormal(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      ' ${userModel.state!}',
                      style: textStyleNormal(
                        fontSize: 15,
                      ),
                    ),
                  ]),
                  spaceVertical(height: 10.0),
                  Center(
                    child: PrimaryButton(
                      color: kRed,
                      label: Text(
                        AppLocalizations.of(context)!.close,
                        style: textStyleNormal(
                          color: kWhite,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      borderRadius: 20.0,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
