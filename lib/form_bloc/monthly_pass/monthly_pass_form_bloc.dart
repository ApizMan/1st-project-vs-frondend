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
  final List<PromotionMonthlyPassModel> promotionModel;
  final List<PBTModel> pbtModel;
  final Map<String, dynamic> details;

  final SelectFieldBloc<String?, dynamic> carPlateNumber;
  final SelectFieldBloc<String?, dynamic> pbt;
  final SelectFieldBloc<String?, dynamic> promotion;
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
    required this.promotionModel,
    required this.details,
    required this.model,
  })  : pbt = SelectFieldBloc(
          items: pbtModel.map((pbt) => pbt.name).toList(),
        ),
        promotion = SelectFieldBloc(
          items: promotionModel.map((promotion) => promotion.title).toList(),
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
        promotion,
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

      if (response['error'] != null) {
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
          storeId: "MonthlyPass",
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
        'order_number': 'CCPMP-$serialNumber',
        'order_amount': double.parse(amount.value),
        'validity_qr': "10",
        'store_id': 'Monthly Pass', // description
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
      prefix: '/paymentfpx/recordBill-seasonpass/',
      body: jsonEncode({
        'NetAmount': double.parse(amount.value),
      }),
    );

    // Ensure response is properly typed as Map<String, dynamic>
    return response;
  }
}
