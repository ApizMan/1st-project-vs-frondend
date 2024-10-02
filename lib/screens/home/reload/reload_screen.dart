import 'dart:convert';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:flutter/material.dart';
import 'package:project/app/helpers/shared_preferences.dart';
import 'package:project/component/webview.dart';
import 'package:project/constant.dart';
import 'package:project/form_bloc/form_bloc.dart';
import 'package:project/models/models.dart';
import 'package:project/resources/resources.dart';
import 'package:project/routes/route_manager.dart';
import 'package:project/theme.dart';
import 'package:project/widget/loading_dialog.dart';
import 'package:project/widget/primary_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ReloadScreen extends StatefulWidget {
  const ReloadScreen({super.key});
  @override
  State<ReloadScreen> createState() => _ReloadScreenState();
}

class _ReloadScreenState extends State<ReloadScreen> {
  String? _selectedLabel; // Variable to store the selected label
  bool isOtherValue = false; // Flag to determine if "Other" is selected
  late ReloadFormBloc formBloc; // Make it non-nullable
  late double amountReload;

  @override
  void initState() {
    super.initState();
    getReloadAmount();
  }

  Future<void> getReloadAmount() async {
    amountReload = await SharedPreferencesHelper.getReloadAmount();
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    Map<String, dynamic> details =
        arguments['locationDetail'] as Map<String, dynamic>;
    UserModel? userModel = arguments['userModel'] as UserModel?;

    return BlocProvider(
      create: (context) => ReloadFormBloc(
        model: userModel!,
        details: details,
      ),
      child: Builder(
        builder: (context) {
          formBloc = BlocProvider.of<ReloadFormBloc>(context);

          return FormBlocListener<ReloadFormBloc, String, String>(
            onSubmitting: (context, state) {
              LoadingDialog.show(context);
            },
            onSubmissionFailed: (context, state) => LoadingDialog.hide(context),
            onSuccess: (context, state) {
              LoadingDialog.hide(context);

              final payment = GlobalState.paymentMethod;

              try {
                if (payment == 'FPX') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          WebViewPage(url: state.successResponse!),
                    ),
                  ).then((value) async {
                    final order =
                        await SharedPreferencesHelper.getOrderDetails();

                    final response = await ReloadResources.reloadProcess(
                      prefix: '/paymentfpx/callbackurl-fpx/',
                      body: jsonEncode({
                        'ActivityTag': "CheckPaymentStatus",
                        'LanguageCode': "en",
                        'AppReleaseId': "34",
                        'GMTTimeDifference': 8,
                        'PaymentTxnRef': null,
                        'BillId': order['orderNo'],
                        'BillReference': null,
                      }),
                    );

                    if (response['SFM']['Constant'] ==
                        'SFM_EXECUTE_PAYMENT_SUCCESS') {
                      final response = await ReloadResources.reloadSuccessful(
                        prefix: '/payment/callbackUrl/pegeypay',
                        body: jsonEncode({
                          'order_no': order['orderNo'],
                          'order_amount': double.parse(order['amount']),
                          'order_status': order['status'],
                          'store_id': order['storeId'],
                          'shift_id': order['shiftId'],
                          'terminal_id': order['terminalId'],
                        }),
                      );

                      if (response['order_status'] == 'paid') {
                        Navigator.pushNamed(
                          context,
                          AppRoute.reloadReceiptScreen,
                          arguments: {
                            'locationDetail': details,
                            'userModel': userModel,
                            'amount': double.parse(order['amount']),
                          },
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('UnSuccessful Reload'),
                          ),
                        );
                      }
                    } else if (response['SFM']['Constant'] ==
                        "SFM_EXECUTE_PAYMENT_FAILED") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Payment FPX Unsuccessful'),
                        ),
                      );
                    } else if (response['SFM']['Constant'] ==
                            "SFM_EXECUTE_PAYMENT_CANCELLED" ||
                        response['SFM']['Constant'] == "SFM_TXN_NOT_FOUND") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('You have Cancel Payment'),
                        ),
                      );
                    } else if (response['SFM']['Constant'] ==
                        "SFM_EXECUTE_PAYMENT_UNCONFIRMED") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Payment execution is unconfirmed. please contact Customer Support.'),
                        ),
                      );
                    } else if (response['SFM']['Constant'] ==
                            "SFM_EXECUTE_PAYMENT_IN_PREP" ||
                        response['SFM']['Constant'] ==
                            "SFM_EXECUTE_PAYMENT_PENDING_AUTH") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Payment execution is pending. Please wait.'),
                        ),
                      );
                    }
                  });
                } else {
                  Navigator.pushNamed(
                    context,
                    AppRoute.reloadQRScreen,
                    arguments: {
                      'locationDetail': details,
                      'qrCodeUrl': state.successResponse!,
                    },
                  ).then((value) async {
                    final order =
                        await SharedPreferencesHelper.getOrderDetails();

                    final response = await ReloadResources.reloadProcess(
                      prefix: '/payment/transaction-details',
                      body: jsonEncode({
                        'order_no': order['orderNo'],
                      }),
                    );

                    if (response['status'] == 'success') {
                      if (response['content']['order_status'] == 'successful') {
                        final response = await ReloadResources.reloadSuccessful(
                          prefix: '/payment/callbackUrl/pegeypay',
                          body: jsonEncode({
                            'order_no': order['orderNo'],
                            'order_amount': double.parse(order['amount']),
                            'order_status': order['status'],
                            'store_id': order['storeId'],
                            'shift_id': order['shiftId'],
                            'terminal_id': order['terminalId'],
                          }),
                        );

                        if (response['order_status'] == 'paid') {
                          Navigator.pushNamed(
                            context,
                            AppRoute.reloadReceiptScreen,
                            arguments: {
                              'locationDetail': details,
                              'userModel': userModel,
                              'amount': double.parse(
                                  response['order_amount'].toString()),
                            },
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('UnSuccessful Reload'),
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(response['content']['order_status']),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(response['status']),
                        ),
                      );
                    }
                  });
                }
              } catch (e) {
                e.toString();
              }
            },
            onFailure: (context, state) {
              LoadingDialog.hide(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.failureResponse!),
                ),
              );
            },
            child: Scaffold(
              backgroundColor: kBackgroundColor,
              appBar: AppBar(
                toolbarHeight: 100,
                foregroundColor:
                    details['color'] == 4294961979 ? kBlack : kWhite,
                backgroundColor: Color(details['color']),
                centerTitle: true,
                title: Text(
                  AppLocalizations.of(context)!.reload,
                  style: textStyleNormal(
                    fontSize: 26,
                    color: details['color'] == 4294961979 ? kBlack : kWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: PrimaryButton(
                buttonWidth: 0.8,
                borderRadius: 10.0,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoute.reloadPaymentScreen,
                    arguments: {
                      'locationDetail': details,
                      'userModel': userModel,
                      'formBloc': formBloc,
                    },
                  );
                },
                label: Text(
                  AppLocalizations.of(context)!.confirm,
                  style: textStyleNormal(
                    color: kWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              body: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.18,
                      child: GridView.count(
                        crossAxisCount: 3, // 3 columns
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 2,
                        children: [
                          _buildGridItem('RM 10.00'),
                          _buildGridItem('RM 20.00'),
                          _buildGridItem('RM 30.00'),
                          _buildGridItem('RM 40.00'),
                          _buildGridItem('RM 50.00'),
                          _buildGridItem(AppLocalizations.of(context)!.other),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isOtherValue,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: BlocBuilder<ReloadFormBloc,
                          FormBlocState<String, String>>(
                        bloc: formBloc,
                        builder: (context, state) {
                          return TextFieldBlocBuilder(
                            textFieldBloc: formBloc.other,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            onChanged: (value) {
                              if (isOtherValue) {
                                formBloc.token.updateValue(value);
                                formBloc.amount.updateValue(value);
                              }
                            },
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.amount,
                              hintText:
                                  '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.amount}',
                              hintStyle: const TextStyle(
                                color: Colors.black26,
                              ),
                              prefixText: 'RM ',
                              prefixStyle: textStyleNormal(),
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
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: BlocBuilder<ReloadFormBloc,
                        FormBlocState<String, String>>(
                      bloc: formBloc,
                      builder: (context, state) {
                        return TextFieldBlocBuilder(
                          readOnly: true,
                          textFieldBloc: formBloc.token,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.token,
                            prefixStyle: textStyleNormal(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
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
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGridItem(String label) {
    bool isHighlighted = _selectedLabel == label;

    return ScaleTap(
      onPressed: () {
        setState(() {
          _selectedLabel = label;

          if (label != AppLocalizations.of(context)!.other) {
            // Update token with value from label
            formBloc.token.updateValue(label.replaceAll('RM ', ''));
            formBloc.other.updateValue(label.replaceAll('RM ', ''));
            formBloc.amount.updateValue(label.replaceAll('RM ', ''));
            // Hide the 'Other' field if another option is selected
            isOtherValue = false;
          } else {
            formBloc.other.clear();
            formBloc.token.clear();
            formBloc.amount.clear();
            // Show the 'Other' field
            isOtherValue = true;
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isHighlighted ? kPrimaryColor : kWhite,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: Colors.grey.withOpacity(0.3),
            width: 1,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: textStyleNormal(
            fontSize: 16,
            color: isHighlighted ? kWhite : kBlack,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
