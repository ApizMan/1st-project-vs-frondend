import 'dart:async';
import 'dart:convert';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/app/helpers/shared_preferences.dart';
import 'package:project/app/helpers/validators.dart';
import 'package:project/constant.dart';
import 'package:project/models/models.dart';
import 'package:project/resources/resources.dart';

class MonthlyPassFormBloc extends FormBloc<String, String> {
  final UserModel model;
  final List<PlateNumberModel>? platModel;
  final List<PBTModel> pbtModel;
  final Map<String, dynamic> details;

  final SelectFieldBloc<String?, dynamic> carPlateNumber;
  final SelectFieldBloc<String?, dynamic> pbt;
  final SelectFieldBloc<String?, dynamic> location;

  final TextFieldBloc amount;

  final paymentMethod = SelectFieldBloc(
    items: ['QR', 'FPX'],
    validators: [
      InputValidator.required,
    ],
  );

  MonthlyPassFormBloc({
    required this.platModel,
    required this.pbtModel,
    required this.details,
    required this.model,
  })  : pbt = SelectFieldBloc(
          items: pbtModel.map((pbt) => pbt.name).toList(),
        ),
        carPlateNumber = SelectFieldBloc(
          items: (platModel?.isNotEmpty ?? false)
              ? platModel!.map((plate) => plate.plateNumber).toList()
              : [],
          initialValue: platModel
                  ?.firstWhere(
                    (plate) => plate.isMain ?? false,
                    orElse: () => platModel.first,
                  )
                  .plateNumber ??
              '',
        ),
        location = SelectFieldBloc(
          items: ['Kelantan', 'Terengganu', 'Pahang'],
        ),
        amount = TextFieldBloc() {
    pbt.updateInitialValue(details['location'] ?? '');
    location.updateInitialValue(details['state'] ?? '');
    addFieldBlocs(
      fieldBlocs: [
        carPlateNumber,
        pbt,
        location,
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
          'store_id': 'Monthly Pass', //description
          'terminal_id': details['location'], //email
          'shift_id': model.email, //city
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
        terminalId: response['BatchName'].toString(),
      );

      if (response['error'] != null) {
        emitFailure(failureResponse: response['error'].toString());
      } else {
        emitSuccess(successResponse: response['ShortcutLink']);
      }
    }
  }
}
