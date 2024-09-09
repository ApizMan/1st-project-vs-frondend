import 'dart:async';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/app/helpers/validators.dart';
import 'package:project/models/models.dart';

class MonthlyPassFormBloc extends FormBloc<String, String> {
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
  }
}
