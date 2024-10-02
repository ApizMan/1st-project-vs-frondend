import 'dart:async';
import 'dart:convert';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/models/models.dart';
import 'package:project/resources/resources.dart';

class StoreParkingFormBloc extends FormBloc<String, String> {
  final List<PlateNumberModel>? platModel;
  final List<PBTModel> pbtModel;
  final Map<String, dynamic> details;

  final SelectFieldBloc<String?, dynamic> carPlateNumber;
  final SelectFieldBloc<String?, dynamic> pbt;
  final SelectFieldBloc<String?, dynamic> location;

  final TextFieldBloc amount;

  StoreParkingFormBloc({
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
      ],
    );
  }

  @override
  FutureOr<void> onSubmitting() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    try {
      // Parse as double since the value can have decimals
      double amountDouble = double.parse(amount.value);

      final response = await ParkingResources.payment(
        prefix: '/payment/parking',
        body: jsonEncode({
          'amount': amountDouble,
        }),
      );

      if (response['error'] != null) {
        emitFailure(failureResponse: response['error'].toString());
      } else {
        final responseParking = await ParkingResources.createParking(
          prefix: '/parking/create',
          body: jsonEncode({
            'walletTransactionId': response['walletTransactionid'].toString(),
            'plateNumber': carPlateNumber.value,
            'pbt': pbt.value,
            'location': location.value,
          }),
        );

        if (responseParking['error'] != null) {
          emitFailure(failureResponse: response['error'].toString());
        } else {
          emitSuccess(successResponse: 'Payment Parking Successful!');
        }
      }
    } catch (e) {
      emitFailure(failureResponse: 'An error occurred: ${e.toString()}');
      // Log for debugging
    }
  }
}
