import 'dart:async';
import 'dart:convert';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/app/helpers/shared_preferences.dart';
import 'package:project/app/helpers/validators.dart';
import 'package:project/models/models.dart';
import 'package:project/resources/auth/auth_resources.dart';

class SignUpFormBloc extends FormBloc<String, String> {
  final SignUpModel model = SignUpModel();
  final PlateNumberModel plateNumberModel = PlateNumberModel();

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

  final phoneNumber = TextFieldBloc(
    validators: [
      InputValidator.required,
      InputValidator.phoneNo,
    ],
  );

  final password = TextFieldBloc(
    validators: [
      InputValidator.required,
      InputValidator.passwordChar,
    ],
  );

  final confirmPassword = TextFieldBloc();

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

  final carPlateNumber = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final states = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  SignUpFormBloc() {
    // Add a validator for confirmPassword that compares it with password
    confirmPassword.addValidators([
      InputValidator.required,
      (value) {
        if (value != password.value) {
          return 'Passwords do not match';
        }
        return null;
      }
    ]);

    addFieldBlocs(
      step: 0,
      fieldBlocs: [
        firstName,
        lastName,
        email,
        idNumber,
        phoneNumber,
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

    // Listen to changes in the password field and revalidate confirmPassword
    password.onValueChanges(
      onData: (previous, current) async* {
        confirmPassword.updateValue(confirmPassword.value);
      },
    );
  }

  @override
  FutureOr<void> onSubmitting() async {
    // Ensure confirmPassword matches password
    if (password.value != confirmPassword.value) {
      confirmPassword.addFieldError('Passwords do not match');
      emitFailure(failureResponse: 'Passwords do not match');
      return;
    }

    await Future.delayed(const Duration(milliseconds: 1000));

    if (state.currentStep == 0) {
      model.firstName = firstName.value;
      model.lastName = lastName.value;
      model.email = email.value;
      model.idNumber = idNumber.value;
      model.phoneNumber = phoneNumber.value;
      model.password = password.value;

      emitSuccess();
    } else if (state.currentStep == 1) {
      model.address1 = address1.value;
      model.address2 = address2.value;
      model.address3 = address3.value;
      model.postcode = int.parse(postcode.value);
      model.city = city.value;
      model.state = states.value;

      plateNumberModel.isMain = true;
      plateNumberModel.plateNumber = carPlateNumber.value;

      final responseCreateAccount = await AuthResources.signUp(
        prefix: '/auth/signup',
        body: jsonEncode({
          'firstName': model.firstName,
          'secondName': model.lastName,
          'email': model.email,
          'idNumber': model.idNumber,
          'phoneNumber': model.phoneNumber,
          'password': model.password,
          'address1': model.address1,
          'address2': model.address2,
          'address3': model.address3,
          'postcode': model.postcode,
          'city': model.city,
          'state': model.state,
        }),
      );

      if (responseCreateAccount['error'] != null) {
        emitFailure(failureResponse: responseCreateAccount['error'].toString());
      } else {
        SharedPreferencesHelper.saveToken(
          responseCreateAccount['token'],
        );

        final responseCarPlate = await AuthResources.carPlate(
          prefix: '/carplatenumber/create',
          body: jsonEncode({
            'isMain': plateNumberModel.isMain,
            'plateNumber': plateNumberModel.plateNumber,
          }),
        );

        if (responseCarPlate['error'] != null) {
          emitFailure(failureResponse: responseCarPlate['error'].toString());
        } else {
          emitSuccess(successResponse: 'Success Created Account');
        }
      }
    }
  }
}
