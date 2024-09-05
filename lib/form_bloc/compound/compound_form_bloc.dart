import 'dart:async';
import 'dart:convert';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/app/helpers/shared_preferences.dart';
import 'package:project/app/helpers/validators.dart';
import 'package:project/models/models.dart';
import 'package:project/resources/reload/reload_resources.dart';

class CompoundFormBloc extends FormBloc<String, String> {
  final UserModel model;
  final other = TextFieldBloc();

  final token = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

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
  }) {
    addFieldBlocs(
      fieldBlocs: [
        other,
        token,
        amount,
        paymentMethod,
      ],
    );
  }

  @override
  FutureOr<void> onSubmitting() async {
    // Check if "Other" is selected and if so, validate the 'other' field

    if (token.value.isNotEmpty || other.value.isNotEmpty) {
      // if (paymentMethod.value == 'QR') {
      //   final response = await ReloadResources.reloadMoneyPageypay(
      //     prefix: '/payment/generate-qr',
      //     body: jsonEncode({
      //       'order_amount': double.parse(amount.value),
      //       'store_id': 'Token', //description
      //       'terminal_id': model.firstName, //email
      //       'shift_id': model.email, //city
      //     }),
      //   );

      //   await SharedPreferencesHelper.setPayment('QR');

      //   if (response['error'] != null) {
      //     emitFailure(failureResponse: response['error'].toString());
      //   } else {
      //     emitSuccess(successResponse: response['content']['qr']);
      //   }
      // } else {
      //   final response = await ReloadResources.reloadMoneyFPX(
      //     prefix: '/paymentfpx/recordBill-token/',
      //     body: jsonEncode({
      //       'NetAmount': double.parse(amount.value),
      //     }),
      //   );

      //   await SharedPreferencesHelper.setPayment('FPX');

      //   if (response['error'] != null) {
      //     emitFailure(failureResponse: response['error'].toString());
      //   } else {
      //     emitSuccess(successResponse: response['ShortcutLink']);
      //   }
      // }

      emitSuccess();
    } else {
      if (token.value.isEmpty) {
        // Assuming token holds 'Other'
        token.addFieldError('Select the Amount First');
        emitFailure();
        return;
      }

      if (other.value.isEmpty) {
        // Assuming token holds 'Other'
        other.addFieldError('Amount is required');
        emitFailure();
        return;
      }
    }
  }
}
