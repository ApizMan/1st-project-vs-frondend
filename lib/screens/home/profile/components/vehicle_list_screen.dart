import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/constant.dart';
import 'package:project/form_bloc/form_bloc.dart';
import 'package:project/models/models.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:project/resources/resources.dart';
import 'package:project/routes/route_manager.dart';
import 'package:project/theme.dart';
import 'package:project/widget/loading_dialog.dart';
import 'package:project/widget/primary_button.dart';

Future<void> vehicleList(BuildContext context, UserModel userModel) {
  return showModalBottomSheet(
    context: context,
    isDismissible: false,
    builder: (BuildContext context) {
      return SingleChildScrollView(
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
                      AppLocalizations.of(context)!.listOfVehicle,
                      style: textStyleNormal(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: kBlack,
                      ),
                    ),
                  ),
                  for (int i = 0; i < userModel.plateNumbers!.length; i++)
                    Column(
                      children: [
                        const SizedBox(height: 10), // Spacer
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${AppLocalizations.of(context)!.carPlate} ${i + 1}',
                                  style: textStyleNormal(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  userModel.plateNumbers![i].plateNumber!,
                                  style: textStyleNormal(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                userModel.plateNumbers![i].isMain != true
                                    ? PrimaryButton(
                                        label: Text(
                                          AppLocalizations.of(context)!
                                              .setAsMain,
                                          style: textStyleNormal(
                                            color: kWhite,
                                            fontSize: 8,
                                          ),
                                        ),
                                        borderRadius: 10.0,
                                        buttonWidth: 0.3,
                                        onPressed: () async {
                                          // Call the updateCarPlate function to set the selected plate as the main one
                                          await updatePlate(context,
                                              userModel.plateNumbers![i].id!);
                                        },
                                      )
                                    : Container(
                                        width: 120,
                                        height: 20,
                                        padding:
                                            const EdgeInsets.only(top: 3.0),
                                        decoration: BoxDecoration(
                                          color: kGrey.withOpacity(0.3),
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                          border: Border.all(
                                            color: Colors.grey.withOpacity(0.3),
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          "Default",
                                          style: textStyleNormal(
                                              color: kWhite, fontSize: 8),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    size: 20,
                                  ),
                                  onPressed: () async {
                                    _showDeleteConfirmationDialog(
                                        context, userModel.plateNumbers![i]);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  spaceVertical(height: 50.0),
                  Center(
                    child: PrimaryButton(
                      icon: const Icon(Icons.add, color: kWhite),
                      label: Text(
                        AppLocalizations.of(context)!.addVehicle,
                        style: textStyleNormal(
                            color: kWhite,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                      borderRadius: 20.0,
                      onPressed: () async {
                        if (userModel.plateNumbers!.length >= 2) {
                          _showErrorDialog(
                              context,
                              AppLocalizations.of(context)!.error,
                              AppLocalizations.of(context)!.errorDesc);
                        } else {
                          _showAddVehicleDialog(context, userModel);
                        }
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

Future<void> _showAddVehicleDialog(BuildContext context, UserModel userModel) {
  StoreVehicleFormBloc? formBloc;

  return showModalBottomSheet(
    context: context,
    isDismissible: false,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return BlocProvider(
        create: (context) => StoreVehicleFormBloc(),
        child: Builder(builder: (context) {
          formBloc = context.read<StoreVehicleFormBloc>();

          return Padding(
            padding: EdgeInsets.only(
              // Add bottom padding for keyboard
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: FormBlocListener<StoreVehicleFormBloc, String, String>(
              onSubmitting: (context, state) {
                LoadingDialog.show(context);
              },
              onSubmissionFailed: (context, state) =>
                  LoadingDialog.hide(context),
              onSuccess: (context, state) {
                LoadingDialog.hide(context);
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
                              AppLocalizations.of(context)!.addVehicle,
                              style: textStyleNormal(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: kBlack,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10), // Spacer
                          TextFieldBlocBuilder(
                            textFieldBloc: formBloc!.plateNumber,
                            inputFormatters: [
                              // This ensures that the input is displayed as uppercase
                              FilteringTextInputFormatter.allow(
                                  RegExp("[a-zA-Z0-9]")),
                              UpperCaseTextFormatter(),
                            ],
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              label:
                                  Text(AppLocalizations.of(context)!.vehicleNo),
                              hintText:
                                  '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.vehicleNo}',
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
                                  icon: const Icon(Icons.add, color: kWhite),
                                  label: Text(
                                    AppLocalizations.of(context)!.add,
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

void _showErrorDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

void _showDeleteConfirmationDialog(
    BuildContext context, PlateNumberModel carPlate) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(AppLocalizations.of(context)!.confirmDeletion),
        content: Text(
            '${AppLocalizations.of(context)!.confirmDeletionDesc} ${carPlate.plateNumber}?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await deleteplate(context, carPlate.id!);
            },
            child: Text(AppLocalizations.of(context)!.confirm),
          ),
        ],
      );
    },
  );
}

Future<void> deleteplate(BuildContext context, String id) async {
  final response = await AuthResources.deleteCarPlate(
    prefix: '/carplatenumber/delete/$id',
  );

  if (response['error'] != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response['error'].toString()),
      ),
    );
  } else {
    await Navigator.pushNamedAndRemoveUntil(
        context, AppRoute.homeScreen, (context) => false);
    await Future.delayed(
        const Duration(seconds: 1)); // Add delay to show the Snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response['message'].toString()),
      ),
    );
  }
}

Future<void> updatePlate(BuildContext context, String id) async {
  final response = await AuthResources.updateCarPlate(
    prefix: '/carplatenumber/update/$id',
    body: jsonEncode({
      'isMain': true,
    }),
  );

  if (response['error'] != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response['error'].toString()),
      ),
    );
  } else {
    await Navigator.pushNamedAndRemoveUntil(
        context, AppRoute.homeScreen, (context) => false);
    await Future.delayed(
        const Duration(seconds: 1)); // Add delay to show the Snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response['message'].toString()),
      ),
    );
  }
}
