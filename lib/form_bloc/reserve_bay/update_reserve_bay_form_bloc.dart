import 'dart:async';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/app/helpers/validators.dart';
import 'package:project/models/models.dart';

class UpdateReserveBayFormBloc extends FormBloc<String, String> {
  final ReserveBayModel model;
  final companyName = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final ssm = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final businessType = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final address1 = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final address2 = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final address3 = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final postcode = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final city = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final states = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final picFirstName = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final picLastName = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final phoneNumber = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final email = TextFieldBloc(
    validators: [
      InputValidator.required,
      InputValidator.emailChar,
    ],
  );

  final idNumber = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final totalLot = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final reason = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final lotNumber = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final location = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final designatedBay = TextFieldBloc(
    initialValue: 'empty',
  );

  final designatedBayName = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final certificate = TextFieldBloc(
    initialValue: 'empty',
  );

  final certificateName = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final idCard = TextFieldBloc(
    initialValue: 'empty',
  );

  final idCardName = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final tnc = BooleanFieldBloc(
    initialValue: true,
  );

  UpdateReserveBayFormBloc({
    required this.model,
  }) {
    companyName.updateValue(model.companyName ?? '');
    ssm.updateValue(model.companyRegistration ?? '');
    businessType.updateValue(model.businessType ?? '');
    address1.updateValue(model.address1 ?? '');
    address2.updateValue(model.address2 ?? '');
    address3.updateValue(model.address3 ?? '');
    postcode.updateValue(model.postcode ?? '');
    city.updateValue(model.city ?? '');
    states.updateValue(model.state ?? '');

    addFieldBlocs(
      step: 0,
      fieldBlocs: [
        companyName,
        ssm,
        businessType,
        address1,
        address2,
        address3,
        postcode,
        city,
        states,
      ],
    );

    picFirstName.updateValue(model.picFirstName ?? '');
    picLastName.updateValue(model.picLastName ?? '');
    phoneNumber.updateValue(model.phoneNumber ?? '');
    email.updateValue(model.email ?? '');
    idNumber.updateValue(model.idNumber ?? '');
    totalLot.updateValue(model.totalLotRequired == 300
        ? '3 Bulan: RM 300'
        : model.totalLotRequired == 600
            ? '6 Bulan: RM 600'
            : '12 Bulan: RM 1,200');
    reason.updateValue(model.reason ?? '');
    lotNumber.updateValue(model.lotNumber ?? '');
    location.updateValue(model.location ?? '');

    designatedBay.updateValue(model.designatedBayPicture ?? '');
    certificate.updateValue(model.registerNumberPicture ?? '');
    idCard.updateValue(model.idCardPicture ?? '');

    addFieldBlocs(
      step: 1,
      fieldBlocs: [
        picFirstName,
        picLastName,
        phoneNumber,
        email,
        idNumber,
        totalLot,
        reason,
        lotNumber,
        location,
      ],
    );

    addFieldBlocs(
      step: 2,
      fieldBlocs: [
        designatedBay,
        designatedBayName,
        certificate,
        certificateName,
        idCard,
        idCardName,
      ],
    );

    addFieldBlocs(
      step: 3,
      fieldBlocs: [
        tnc,
      ],
    );
  }

  @override
  FutureOr<void> onSubmitting() async {
    await Future.delayed(const Duration(milliseconds: 1000));
  }
}
