import 'dart:async';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/models/models.dart';

class StoreParkingFormBloc extends FormBloc<String, String> {
  final List<PlateNumberModel> platModel;
  final List<PBTModel> pbtModel;
  final Map<String, dynamic> details;

  final SelectFieldBloc<String?, dynamic> carPlateNumber;
  final SelectFieldBloc<String?, dynamic> pbt;
  final location = SelectFieldBloc(items: [
    'Kelantan',
    'Terengganu',
    'Pahang',
  ]);

  StoreParkingFormBloc({
    required this.platModel,
    required this.pbtModel,
    required this.details,
  })  : pbt = SelectFieldBloc(
          items: pbtModel.map((pbt) => pbt.name).toList(), // Map PBT names
        ),
        carPlateNumber = SelectFieldBloc(
          items: platModel.map((plate) => plate.plateNumber).toList(),
          initialValue: platModel
              .firstWhere((plate) => plate.isMain!)
              .plateNumber, // Select 'isMain' plate
        ) {
    pbt.updateInitialValue(details['location']);
    location.updateInitialValue(details['state']);
    addFieldBlocs(
      fieldBlocs: [
        carPlateNumber,
        pbt,
        location,
      ],
    );
  }

  @override
  FutureOr<void> onSubmitting() async {
    await Future.delayed(const Duration(milliseconds: 1000));
  }
}
