import 'dart:async';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/app/helpers/validators.dart';
import 'package:project/models/models.dart';

class SignUpFormBloc extends FormBloc<String, String> {
  final SignUpModel model = SignUpModel();

  final firstName = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final lastName = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final idNumber = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final phoneNumber = TextFieldBloc(
    validators: [
      InputValidator.required,
      InputValidator.phoneNo,
    ],
  );

  final email = TextFieldBloc(
    validators: [
      InputValidator.required,
      InputValidator.emailChar,
    ],
  );

  final password = TextFieldBloc(
    validators: [
      InputValidator.required,
      InputValidator.passwordChar,
    ],
  );

  final confirmPassword = TextFieldBloc(
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
    initialValue: '',
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

  final carPlateNumber = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  SignUpFormBloc() {
    addFieldBlocs(
      step: 0,
      fieldBlocs: [
        firstName,
        lastName,
        idNumber,
        phoneNumber,
        email,
        password,
        confirmPassword,
      ],
    );

    addFieldBlocs(
      step: 1,
      fieldBlocs: [
        address1,
        address2,
        address3,
        postcode,
        city,
        states,
        carPlateNumber,
      ],
    );
  }

  @override
  FutureOr<void> onSubmitting() async {}
}
