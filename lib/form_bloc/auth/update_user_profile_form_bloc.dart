import 'dart:async';
import 'dart:convert';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/app/helpers/validators.dart';
import 'package:project/resources/resources.dart';

class UpdateUserProfileFormBloc extends FormBloc<String, String> {
  final email = TextFieldBloc(
    validators: [
      InputValidator.emailChar,
      InputValidator.required,
    ],
  );

  UpdateUserProfileFormBloc() {
    addFieldBlocs(
      fieldBlocs: [
        email,
      ],
    );
  }

  @override
  FutureOr<void> onSubmitting() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    try {
      final response = await AuthResources.editProfile(
        prefix: '/auth/update',
        body: jsonEncode({
          'email': email.value.toString(),
        }),
      );

      if (response['error'] != null) {
        emitFailure(failureResponse: response['error'].toString());
      } else {
        emitSuccess(successResponse: response['message']);
      }
    } catch (e) {
      e.toString();
    }
  }
}
