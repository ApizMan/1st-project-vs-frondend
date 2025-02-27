import 'dart:async';
import 'dart:convert';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/app/helpers/shared_preferences.dart';
import 'package:project/app/helpers/validators.dart';
import 'package:project/constant.dart';
import 'package:project/models/models.dart';
import 'package:project/resources/resources.dart';

class CompoundFormBloc extends FormBloc<String, String> {
  final UserModel model;
  final Map<String, dynamic> details;

  final amount = TextFieldBloc(
    validators: [
      InputValidator.amount,
    ],
  );

  final paymentMethod = SelectFieldBloc(
    items: ['QR', 'FPX'],
    validators: [
      InputValidator.required,
    ],
  );

  CompoundFormBloc({
    required this.model,
    required this.details,
  }) {
    addFieldBlocs(
      fieldBlocs: [
        amount,
        paymentMethod,
      ],
    );
  }

  @override
  FutureOr<void> onSubmitting() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    if (paymentMethod.value == 'QR') {
      final response = await getQR();

      GlobalState.paymentMethod = 'QR';

      if (response['error'] != null) {
        // emitFailure(failureResponse: response['error'].toString());
        final response = await PegeypayResources.refreshToken(
          prefix: '/payment/public/refresh-token',
        );

        await SharedPreferencesHelper.setPegeypayToken(
          token: response['access_token'],
        );

        await getQR();

        await onSubmitting();
      } else {
        await SharedPreferencesHelper.setOrderDetails(
          orderNo: response['order']['order_no'],
          amount: response['order']['order_amount'].toString(),
          shiftId: response['order']['shift_id'],
          terminalId: response['order']['terminal_id'],
          storeId: response['order']['store_id'],
          toWhatsappNo: response['order']['to_whatsapp_no'],
          status: 'paid',
        );

        emitSuccess(
          // successResponse: response['data']['content']['qr'],
          successResponse: response['data']['content']['iframe_url'],
        );
      }
    } else {
      final response = await getFPX();

      GlobalState.paymentMethod = 'FPX';

      if (response['SFM']['Constant'] == "SFM_GENERAL_ERROR") {
        // emitFailure(failureResponse: response['error'].toString());
        await PegeypayResources.refreshToken(
          prefix: '/paymentfpx/public',
        );

        await getFPX();

        await onSubmitting();
      } else {
        await SharedPreferencesHelper.setOrderDetails(
          orderNo: response['BillId'].toString(),
          amount: amount.value.toString(),
          storeId: "Compound",
          shiftId: model.email!,
          terminalId: response['BatchName'].toString(),
          status: "paid",
        );

        emitSuccess(successResponse: response['ShortcutLink']);
      }
    }
  }

  Future<Map<String, dynamic>> getQR() async {
    String serialNumber =
        generateSerialNumber(); // Generate random serial number

    final response = await PegeypayResources.generateQR(
      prefix: '/payment/generate-qr',
      body: jsonEncode({
        'order_output': "online",
        'order_number': 'CCPC-$serialNumber',
        'order_amount': double.parse(amount.value),
        'validity_qr': "10",
        'store_id': 'Compound', // description
        'terminal_id': details['location'], // email
        'shift_id': model.idNumber, // city
        'to_whatsapp_no': model.phoneNumber,
      }),
    );

    // Ensure response is properly typed as Map<String, dynamic>
    return response;
  }

  Future<Map<String, dynamic>> getFPX() async {
    final response = await ReloadResources.reloadMoneyFPX(
      prefix: '/paymentfpx/recordBill-compound/',
      body: jsonEncode({
        'NetAmount': double.parse(amount.value),
      }),
    );

    // Ensure response is properly typed as Map<String, dynamic>
    return response;
  }
}
