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
      final response = await ReloadResources.reloadMoneyPageypay(
        prefix: '/payment/generate-qr',
        body: jsonEncode({
          'order_amount': double.parse(amount.value),
          'store_id': 'Compound', //description
          'terminal_id': details['location'], //email
          'shift_id': model.idNumber, //city
          'to_whatsapp_no': model.phoneNumber,
        }),
      );

      GlobalState.paymentMethod = 'QR';

      if (response['error'] != null) {
        emitFailure(failureResponse: response['error'].toString());
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

        emitSuccess(successResponse: response['data']['content']['qr']);
      }
    } else {
      final response = await ReloadResources.reloadMoneyFPX(
        prefix: '/paymentfpx/recordBill-token/',
        body: jsonEncode({
          'NetAmount': double.parse(amount.value),
        }),
      );

      GlobalState.paymentMethod = 'FPX';

      await SharedPreferencesHelper.setOrderDetails(
        orderNo: response['BillId'].toString(),
        amount: amount.value.toString(),
        storeId: "Compound",
        shiftId: model.email!,
        terminalId: response['BatchName'].toString(),
        status: "paid",
      );

      if (response['error'] != null) {
        emitFailure(failureResponse: response['error'].toString());
      } else {
        emitSuccess(successResponse: response['ShortcutLink']);
      }
    }
  }
}
