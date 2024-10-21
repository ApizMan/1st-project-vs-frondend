import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:project/constant.dart';
import 'package:project/form_bloc/form_bloc.dart';
import 'package:project/models/models.dart';
import 'package:project/routes/route_manager.dart';
import 'package:project/theme.dart';
import 'package:project/widget/loading_dialog.dart';
import 'package:project/widget/primary_button.dart';

Future<void> helpCenter(BuildContext context, List<PBTModel> pbtModel) async {
  HelpDeskFormBloc? formBloc;

  List<String> item = [
    AppLocalizations.of(context)!.seasonPass,
    AppLocalizations.of(context)!.reserveBays,
    AppLocalizations.of(context)!.parking,
    AppLocalizations.of(context)!.enforcement,
    AppLocalizations.of(context)!.others
  ];

  return showModalBottomSheet(
    context: context,
    isDismissible: false,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return BlocProvider(
        create: (context) => HelpDeskFormBloc(
          item: item,
          pbtModel: pbtModel,
        ),
        child: Builder(builder: (context) {
          formBloc = BlocProvider.of<HelpDeskFormBloc>(context);

          return FormBlocListener<HelpDeskFormBloc, String, String>(
            onSubmitting: (context, state) {
              LoadingDialog.show(context);
            },
            onSubmissionFailed: (context, state) => LoadingDialog.hide(context),
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
                            AppLocalizations.of(context)!.helpCenter,
                            style: textStyleNormal(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: kBlack,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: SizedBox(
                            child: DropdownFieldBlocBuilder<String>(
                              showEmptyItem: false,
                              selectFieldBloc:
                                  formBloc!.section, // Correct type now used
                              decoration: InputDecoration(
                                hintText:
                                    AppLocalizations.of(context)!.selectItem,
                                labelText:
                                    AppLocalizations.of(context)!.selectItem,
                                hintStyle: const TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                      width: 3, color: Colors.black),
                                ),
                              ),
                              itemBuilder: (context, value) {
                                return FieldItem(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Text(
                                        value), // Adjust to remove the forced nullable type
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: SizedBox(
                            child: DropdownFieldBlocBuilder<String?>(
                              showEmptyItem: false,
                              selectFieldBloc: formBloc!.pbt,
                              decoration: InputDecoration(
                                hintText:
                                    AppLocalizations.of(context)!.selectPbt,
                                labelText:
                                    AppLocalizations.of(context)!.selectPbt,
                                hintStyle: const TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                      width: 3, color: Colors.black),
                                ),
                              ),
                              itemBuilder: (context, value) {
                                // Find the PBTModel by id (value) and display its name
                                final pbt = formBloc!.pbtModel
                                    .firstWhere((pbt) => pbt.id == value);
                                return FieldItem(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Text(pbt.name!), // Display the name
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: 800,
                          child: TextFieldBlocBuilder(
                            maxLines: 15, // Specify a fixed height
                            textFieldBloc: formBloc!.description,
                            decoration: InputDecoration(
                              hintText:
                                  ' ${AppLocalizations.of(context)!.pleaseWriteHere}..... ',
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
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
          );
        }),
      );
    },
  );
}
