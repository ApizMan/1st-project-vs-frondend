import 'dart:async';
import 'dart:convert';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/app/helpers/validators.dart';
import 'package:project/resources/resources.dart';

class StoreVehicleFormBloc extends FormBloc<String, String> {
  final plateNumber = TextFieldBloc(validators: [
    InputValidator.required,
  ]);

  StoreVehicleFormBloc() {
    addFieldBlocs(
      fieldBlocs: [
        plateNumber,
      ],
    );
  }

  @override
  FutureOr<void> onSubmitting() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    try {
      final response = await AuthResources.carPlate(
        prefix: '/carplatenumber/create',
        body: jsonEncode({
          'plateNumber': plateNumber.value.toString(),
          'isMain': false,
        }),
      );

      if (response['error'] != null) {
        emitFailure(failureResponse: response['error'].toString());
      } else {
        emitSuccess(successResponse: 'Plate Number Successfully Added');
      }
    } catch (e) {
      e.toString();
    }
  }
}
