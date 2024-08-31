import 'dart:async';
import 'dart:convert';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/app/helpers/shared_preferences.dart';
import 'package:project/app/helpers/validators.dart';
import 'package:project/models/models.dart';
import 'package:project/resources/auth/auth_resources.dart';

class LoginFormBloc extends FormBloc<String, String> {
  final LoginModel model = LoginModel();

  final email = TextFieldBloc(
    validators: [
      InputValidator.required,
      InputValidator.emailChar,
    ],
  );

  final password = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final rememberMe = BooleanFieldBloc(
    initialValue: false,
  );

  LoginFormBloc() {
    addFieldBlocs(
      fieldBlocs: [
        email,
        password,
        rememberMe,
      ],
    );
  }

  @override
  FutureOr<void> onSubmitting() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    try {
      model.email = email.value;
      model.password = password.value;

      final response = await AuthResources.login(
        prefix: '/auth/signin',
        body: jsonEncode(
          {
            'email': email.value.toString(),
            'password': password.value.toString(),
          },
        ),
      );

      if (response['error'] != null) {
        emitFailure(failureResponse: response['error'].toString());
      } else {
        emitSuccess(successResponse: "Successfully Login");
        // Save token using SharedPreferences
        SharedPreferencesHelper.saveToken(
          response['token'],
        );
      }
    } catch (e) {
      e.toString();
    }
  }
}
