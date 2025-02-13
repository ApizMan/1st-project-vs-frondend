// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:ntp/ntp.dart';
import 'package:project/app/helpers/shared_preferences.dart';
import 'package:project/component/webview.dart';
//import 'package:project/component/generate_qr.dart';
import 'package:project/constant.dart';
import 'package:project/form_bloc/form_bloc.dart';
import 'package:project/models/models.dart';
import 'package:project/resources/resources.dart';
import 'package:project/routes/route_manager.dart';
import 'package:project/theme.dart';
import 'package:project/widget/loading_dialog.dart';
import 'package:project/widget/primary_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SummonsPaymentScreen extends StatefulWidget {
  const SummonsPaymentScreen({super.key});

  @override
  State<SummonsPaymentScreen> createState() => _ReloadPaymentScreenState();
}

class _ReloadPaymentScreenState extends State<SummonsPaymentScreen> {
  // ignore: unused_field
  String? _qrCodeUrl;
  String? shortcutLink;
  CompoundFormBloc? formBloc;
  DateTime? currentTime;

  @override
  void initState() {
    super.initState();
    getLiveTime();
  }

  void getLiveTime() async {
    currentTime = await NTP.now();
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    Map<String, dynamic> details =
        arguments['locationDetail'] as Map<String, dynamic>;
    UserModel? userModel = arguments['userModel'] as UserModel?;
    List<SummonModel>? selectedSummons =
        arguments['selectedSummons'] as List<SummonModel>?;
    double totalAmount = 0.0;
    return BlocProvider(
      create: (context) => CompoundFormBloc(
        model: userModel!,
        details: details,
      ),
      child: Builder(builder: (context) {
        formBloc = BlocProvider.of<CompoundFormBloc>(context);
        return FormBlocListener<CompoundFormBloc, String, String>(
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
                    builder: (context) => WebViewPage(
                      title: "FPX",
                      url: state.successResponse!,
                      details: details,
                    ),
                  ),
                ).then((value) async {
                  final order = await SharedPreferencesHelper.getOrderDetails();

                  final response = await ReloadResources.reloadProcess(
                    prefix: '/paymentfpx/callbackurl-fpx/',
                    body: jsonEncode({
                      'ActivityTag': "CheckPaymentStatus",
                      'LanguageCode': 'en',
                      'AppReleaseId': 34,
                      'GMTTimeDifference': 8,
                      'PaymentTxnRef': null,
                      'BillId': order['orderNo'],
                      'BillReference': null,
                    }),
                  );

                  if (response['SFM']['Constant'] ==
                      'SFM_EXECUTE_PAYMENT_SUCCESS') {
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(currentTime!);
                    for (var i = 0; i < selectedSummons.length; i++) {
                      final response = await CompoundResources.pay(
                        prefix: '/compound/payCompound',
                        body: jsonEncode(
                          {
                            'OwnerIDNo': "111111111111",
                            'OwnerCategoryID': "1",
                            'VehicleRegistrationNumber': selectedSummons[i]
                                .vehicleRegistrationNo
                                .toString(),
                            'NoticeNo': selectedSummons[i].noticeNo.toString(),
                            'ReceiptNo': 'RC-${selectedSummons[i].noticeNo}',
                            'PaymentTransactionType': null,
                            'PaymentDate': formattedDate,
                            'PaidAmount': selectedSummons[i].amount.toString(),
                            'ChannelType': null,
                            'PaymentStatus': null,
                            'PaymentMode': null,
                            'PaymentLocation': 'FPX',
                            'Notes': selectedSummons[i]
                                .offenceDescription
                                .toString(),
                          },
                        ),
                      );

                      if (response['data']['responseMessage'] == 'SUCCESS') {
                        DateTime now = await NTP.now();
                        String isoTimestamp = now.toUtc().toIso8601String();

                        final response = await CompoundResources.store(
                          prefix: '/compound/store',
                          body: jsonEncode({
                            'OwnerIdNo': "111111111111",
                            'OwnerCategoryId': "1",
                            'VehicleRegistrationNumber': selectedSummons[i]
                                .vehicleRegistrationNo
                                .toString(),
                            'NoticeNo': selectedSummons[i].noticeNo.toString(),
                            'ReceiptNo': 'RC-${selectedSummons[i].noticeNo}',
                            'PaymentTransactionType': null,
                            'PaymentDate': isoTimestamp.toString(),
                            'PaidAmount': selectedSummons[i].amount.toString(),
                            'ChannelType': null,
                            'PaymentStatus': null,
                            'PaymentMode': null,
                            'PaymentLocation': 'FPX',
                            'Notes': selectedSummons[i]
                                .offenceDescription
                                .toString(),
                          }),
                        );

                        if (response['status'] == 'success') {
                          Navigator.pushNamed(
                            context,
                            AppRoute.summonsReceiptScreen,
                            arguments: {
                              'locationDetail': details,
                              'selectedSummons': selectedSummons,
                              'totalAmount': totalAmount,
                            },
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Compound Unsuccessful Store to Database'),
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Compound Unsuccessful To Pay'),
                          ),
                        );
                      }
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
                        content:
                            Text('Payment execution is pending. Please wait.'),
                      ),
                    );
                  }
                });
              } else {
                // Navigator.pushNamed(
                //   context,
                //   AppRoute.reloadQRScreen,
                //   arguments: {
                //     'locationDetail': details,
                //     'qrCodeUrl': state.successResponse!,
                //   },
                // )
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WebViewPage(
                      title: "QR Code",
                      url: state.successResponse!,
                      details: details,
                    ),
                  ),
                ).then((value) async {
                  final order = await SharedPreferencesHelper.getOrderDetails();

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
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(currentTime!);
                        for (var i = 0; i < selectedSummons.length; i++) {
                          final response = await CompoundResources.pay(
                            prefix: '/compound/payCompound',
                            body: jsonEncode(
                              {
                                'OwnerIDNo': "111111111111",
                                'OwnerCategoryID': "1",
                                'VehicleRegistrationNumber': selectedSummons[i]
                                    .vehicleRegistrationNo
                                    .toString(),
                                'NoticeNo':
                                    selectedSummons[i].noticeNo.toString(),
                                'ReceiptNo':
                                    'RC-${selectedSummons[i].noticeNo}',
                                'PaymentTransactionType': null,
                                'PaymentDate': formattedDate,
                                'PaidAmount':
                                    selectedSummons[i].amount.toString(),
                                'ChannelType': null,
                                'PaymentStatus': null,
                                'PaymentMode': null,
                                'PaymentLocation': 'QR Code',
                                'Notes': selectedSummons[i]
                                    .offenceDescription
                                    .toString(),
                              },
                            ),
                          );

                          if (response['data']['responseMessage'] ==
                              'SUCCESS') {
                            DateTime now = await NTP.now();
                            String isoTimestamp = now.toUtc().toIso8601String();

                            final response = await CompoundResources.store(
                              prefix: '/compound/store',
                              body: jsonEncode({
                                'OwnerIDNo': "111111111111",
                                'OwnerCategoryID': "1",
                                'VehicleRegistrationNumber': selectedSummons[i]
                                    .vehicleRegistrationNo
                                    .toString(),
                                'NoticeNo':
                                    selectedSummons[i].noticeNo.toString(),
                                'ReceiptNo':
                                    'RC-${selectedSummons[i].noticeNo}',
                                'PaymentTransactionType': null,
                                'PaymentDate': isoTimestamp.toString(),
                                'PaidAmount':
                                    selectedSummons[i].amount.toString(),
                                'ChannelType': null,
                                'PaymentStatus': null,
                                'PaymentMode': null,
                                'PaymentLocation': 'QR Code',
                                'Notes': selectedSummons[i]
                                    .offenceDescription
                                    .toString(),
                              }),
                            );

                            if (response['status'] == 'success') {
                              Navigator.pushNamed(
                                context,
                                AppRoute.summonsReceiptScreen,
                                arguments: {
                                  'locationDetail': details,
                                  'selectedSummons': selectedSummons,
                                  'totalAmount': totalAmount,
                                },
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Compound Unsuccessful Store to Database'),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Compound Unsuccessful To Pay'),
                              ),
                            );
                          }
                        }
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
              foregroundColor: details['color'] == 4294961979 ? kBlack : kWhite,
              backgroundColor: Color(details['color']),
              centerTitle: true,
              title: Text(
                AppLocalizations.of(context)!.payment,
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
              borderRadius: 10.0,
              buttonWidth: 0.8,
              onPressed: () {
                // formBloc!.paymentMethod.updateValue("QR");
                formBloc!.submit();
              },
              label: Text(
                AppLocalizations.of(context)!.pay,
                style: textStyleNormal(color: Colors.white),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 150,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                        itemCount: selectedSummons!.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          double amount =
                              double.parse(selectedSummons[index].amount!);
                          totalAmount += amount; // Accumulate the total amount

                          // Update the value in the formBloc
                          formBloc!.amount.updateValue(totalAmount.toString());

                          return Container(
                            margin: const EdgeInsets.only(top: 20),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 20.0),
                            decoration: BoxDecoration(
                              color: kWhite,
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
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.date,
                                      style: textStyleNormal(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 50),
                                    Expanded(
                                      child: Text(
                                        selectedSummons[index].offenceDate!,
                                        style: textStyleNormal(),
                                        textAlign: TextAlign
                                            .right, // Align text to the right
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.noticeNo,
                                      style: textStyleNormal(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 50),
                                    Expanded(
                                      child: Text(
                                        selectedSummons[index].noticeNo!,
                                        style: textStyleNormal(),
                                        textAlign: TextAlign
                                            .right, // Align text to the right
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .typeOfOffences,
                                        style: textStyleNormal(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(width: 50),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        selectedSummons[index].offenceAct!,
                                        style: textStyleNormal(),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .description,
                                        style: textStyleNormal(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(width: 50),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        selectedSummons[index]
                                            .offenceDescription!,
                                        style: textStyleNormal(),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        AppLocalizations.of(context)!.location,
                                        style: textStyleNormal(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(width: 50),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        selectedSummons[index].offenceLocation!,
                                        style: textStyleNormal(),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.plateNumber,
                                      style: textStyleNormal(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 50),
                                    Expanded(
                                      child: Text(
                                        selectedSummons[index]
                                            .vehicleRegistrationNo!,
                                        style: textStyleNormal(),
                                        textAlign: TextAlign
                                            .right, // Align text to the right
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .compoundRate,
                                      style: textStyleNormal(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 50),
                                    Expanded(
                                      child: Text(
                                        'RM ${double.parse(selectedSummons[index].amount!).toStringAsFixed(2)}',
                                        style: textStyleNormal(),
                                        textAlign: TextAlign
                                            .right, // Align text to the right
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                    const SizedBox(height: 40),
                    Center(
                      child: Text(
                        AppLocalizations.of(context)!.compountPaymentDesc,
                        style: textStyleNormal(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Divider(
                      color: Colors.black,
                      thickness: 1.0,
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 150,
                      child: RadioButtonGroupFieldBlocBuilder<String>(
                        padding: EdgeInsets.zero,
                        canTapItemTile: true,
                        groupStyle: const FlexGroupStyle(
                          direction: Axis.horizontal,
                        ),
                        selectFieldBloc: formBloc!.paymentMethod,
                        decoration: InputDecoration(
                          labelText:
                              AppLocalizations.of(context)!.paymentMethod,
                          labelStyle: textStyleNormal(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        itemBuilder: (context, item) {
                          bool isSelected =
                              formBloc!.paymentMethod.value == item;
                          return FieldItem(
                            child: GestureDetector(
                              onTap: () =>
                                  formBloc!.paymentMethod.updateValue(item),
                              child: Container(
                                width: item == 'QR' ? 80 : 120,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.blue.withOpacity(0.2)
                                      : Colors.transparent,
                                  border: isSelected
                                      ? Border.all(color: Colors.blue, width: 2)
                                      : null,
                                  image: DecorationImage(
                                    image: AssetImage(
                                      item == 'QR'
                                          ? 'assets/images/duitnow.png'
                                          : 'assets/images/fpx.png',
                                    ),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 50),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              AppLocalizations.of(context)!.paymentDesc2,
                              style: textStyleNormal(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
