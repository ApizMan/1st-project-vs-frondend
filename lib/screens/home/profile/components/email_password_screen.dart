import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/constant.dart';
import 'package:project/form_bloc/form_bloc.dart';
import 'package:project/models/models.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:project/routes/route_manager.dart';
import 'package:project/theme.dart';
import 'package:project/widget/loading_dialog.dart';
import 'package:project/widget/primary_button.dart';

Future<void> displayEmailPassword(
    BuildContext context, UserModel userModel, Map<String, dynamic> details) {
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
                      AppLocalizations.of(context)!.emailPassword,
                      style: textStyleNormal(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: kBlack,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10), // Spacer
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.email,
                      style: textStyleNormal(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
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
                  const SizedBox(height: 5),
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.password,
                      style: textStyleNormal(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: Text(
                      '********',
                      style: textStyleNormal(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  spaceVertical(height: 20.0),
                  Center(
                    child: PrimaryButton(
                      icon: const Icon(Icons.edit, color: kWhite),
                      label: Text(
                        AppLocalizations.of(context)!.edit,
                        style: textStyleNormal(
                          color: kWhite,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      borderRadius: 20.0,
                      onPressed: () async {
                        Navigator.pop(context);
                        await editEmail(context, userModel, details);
                      },
                    ),
                  ),
                  spaceVertical(height: 20.0),
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

Future<void> editEmail(
    BuildContext context, UserModel userModel, Map<String, dynamic> details) {
  UpdateUserProfileFormBloc? formBloc;

  return showModalBottomSheet(
    context: context,
    isDismissible: false,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return BlocProvider(
        create: (context) => UpdateUserProfileFormBloc(),
        child: Builder(builder: (context) {
          formBloc = context.read<UpdateUserProfileFormBloc>();

          return Padding(
            padding: EdgeInsets.only(
              // Add bottom padding for keyboard
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: FormBlocListener<UpdateUserProfileFormBloc, String, String>(
              onSubmitting: (context, state) {
                LoadingDialog.show(context);
              },
              onSubmissionFailed: (context, state) =>
                  LoadingDialog.hide(context),
              onSuccess: (context, state) {
                LoadingDialog.hide(context);
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoute.homeScreen,
                  (route) => false,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.successResponse!),
                  ),
                );
              },
              onFailure: (context, state) {
                LoadingDialog.hide(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.failureResponse!),
                  ),
                );
              },
              child: SingleChildScrollView(
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
                      padding: const EdgeInsets.only(
                          top: 20.0, bottom: 50.0, left: 30.0, right: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              '${AppLocalizations.of(context)!.edit} ${AppLocalizations.of(context)!.email}',
                              style: textStyleNormal(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: kBlack,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10), // Spacer
                          TextFieldBlocBuilder(
                            textFieldBloc: formBloc!.email,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              label: Text(AppLocalizations.of(context)!.email),
                              hintText:
                                  '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.email}',
                              hintStyle: const TextStyle(
                                color: Colors.black26,
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black12,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black12,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          spaceVertical(height: 20.0),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                PrimaryButton(
                                  color: kRed,
                                  buttonWidth: 0.4,
                                  label: Text(
                                    AppLocalizations.of(context)!.cancel,
                                    style: textStyleNormal(color: kWhite),
                                  ),
                                  borderRadius: 20.0,
                                  onPressed: () => Navigator.pop(context),
                                ),
                                PrimaryButton(
                                  buttonWidth: 0.4,
                                  label: Text(
                                    AppLocalizations.of(context)!.update,
                                    style: textStyleNormal(color: kWhite),
                                  ),
                                  borderRadius: 20.0,
                                  onPressed: () {
                                    formBloc!.submit();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      );
    },
  );
}
