import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/constant.dart';
import 'package:project/form_bloc/form_bloc.dart';
import 'package:project/routes/route_manager.dart';
import 'package:project/theme.dart';
import 'package:project/widget/background-image.dart';
import 'package:project/widget/loading_dialog.dart';
import 'package:project/widget/primary_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  SignUpFormBloc? formBloc;
  late bool showPassword;
  late bool showConfirmPassword;
  late ValueNotifier<bool> _showPasswordNotifier;
  late ValueNotifier<bool> _showConfirmPasswordNotifier;

  @override
  void initState() {
    super.initState();
    showPassword = true;
    _showPasswordNotifier = ValueNotifier<bool>(showPassword);
    showConfirmPassword = true;
    _showConfirmPasswordNotifier = ValueNotifier<bool>(showConfirmPassword);
  }

  @override
  void dispose() {
    _showPasswordNotifier.dispose();
    _showConfirmPasswordNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundImage(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: kWhite,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context, AppRoute.loginScreen, (route) => false),
          icon: const Icon(Icons.arrow_back, color: kWhite),
        ),
        title: Text(
          AppLocalizations.of(context)!.createNewAccount,
          style: textStyleNormal(
            fontSize: 26,
            color: kWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => SignUpFormBloc(),
        child: Builder(builder: (context) {
          formBloc = BlocProvider.of<SignUpFormBloc>(context);
          return FormBlocListener<SignUpFormBloc, String, String>(
            onSubmitting: (context, state) {
              LoadingDialog.show(context);
            },
            onSubmissionFailed: (context, state) => LoadingDialog.hide(context),
            onSuccess: (context, state) {
              LoadingDialog.hide(context);
              if (state.stepCompleted == state.lastStep) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoute.homeScreen,
                  (route) => false,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.successResponse!),
                  ),
                );
              }
            },
            onFailure: (context, state) {
              LoadingDialog.hide(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.failureResponse!),
                ),
              );
            },
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.12,
                  left: 20.0,
                  right: 20.0,
                  bottom: MediaQuery.of(context).size.height * 0.1,
                ),
                child: Container(
                  padding: const EdgeInsets.only(top: 20.0),
                  decoration: const BoxDecoration(
                    color: kWhite,
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: StepperFormBlocBuilder<SignUpFormBloc>(
                    formBloc: context.read<SignUpFormBloc>(),
                    type: StepperType.horizontal,
                    physics: const BouncingScrollPhysics(),
                    stepsBuilder: (formBloc) {
                      return [
                        _accountStep(formBloc!),
                        _addressStep(formBloc),
                      ];
                    },
                    controlsBuilder: (context, onStepContinue, onStepCancel,
                        step, formBloc) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Visibility(
                                visible: step != 0,
                                child: PrimaryButton(
                                  color: kGrey,
                                  onPressed: onStepCancel,
                                  borderRadius: 10.0,
                                  buttonWidth: 0.35,
                                  label: Text(
                                    AppLocalizations.of(context)!.back,
                                    style: textStyleNormal(color: kWhite),
                                  ),
                                ),
                              ),
                            ),
                            spaceHorizontal(width: step != 0 ? 20.0 : 0),
                            Expanded(
                              flex: step != 0 ? 1 : 100,
                              child: PrimaryButton(
                                onPressed: step == 0
                                    ? onStepContinue
                                    : () => formBloc.submit(),
                                borderRadius: 10.0,
                                label: Text(
                                  step != 0
                                      ? AppLocalizations.of(context)!.submit
                                      : AppLocalizations.of(context)!.next,
                                  style: textStyleNormal(color: kWhite),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  FormBlocStep _accountStep(SignUpFormBloc formBloc) {
    return FormBlocStep(
      title: Text(
        AppLocalizations.of(context)!.account,
        style: textStyleNormal(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: formBloc.state.currentStep == 0
          ? Text(
              AppLocalizations.of(context)!.accountDesc,
              style: textStyleNormal(fontSize: 12),
            )
          : const SizedBox(),
      content: Column(
        children: [
          TextFieldBlocBuilder(
            textFieldBloc: formBloc.firstName,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              label: Text(AppLocalizations.of(context)!.firstName),
              hintText:
                  '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.firstName}',
              hintStyle: const TextStyle(
                color: Colors.black26,
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black12,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black12,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.8),
            ),
          ),
          TextFieldBlocBuilder(
            textFieldBloc: formBloc.lastName,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              label: Text(AppLocalizations.of(context)!.lastName),
              hintText:
                  '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.lastName}',
              hintStyle: const TextStyle(
                color: Colors.black26,
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black12,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black12,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.8),
            ),
          ),
          TextFieldBlocBuilder(
            textFieldBloc: formBloc.email,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              label: Text(AppLocalizations.of(context)!.email),
              hintText:
                  '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.email}',
              hintStyle: const TextStyle(
                color: Colors.black26,
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black12,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black12,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.8),
            ),
          ),
          TextFieldBlocBuilder(
            textFieldBloc: formBloc.idNumber,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              label: Text(AppLocalizations.of(context)!.idNumber),
              hintText:
                  '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.idNumber}',
              hintStyle: const TextStyle(
                color: Colors.black26,
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black12,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black12,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.8),
            ),
          ),
          TextFieldBlocBuilder(
            textFieldBloc: formBloc.phoneNumber,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              label: Text(AppLocalizations.of(context)!.phoneNumber),
              hintText:
                  '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.phoneNumber}',
              hintStyle: const TextStyle(
                color: Colors.black26,
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black12,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black12,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.8),
            ),
          ),
          ValueListenableBuilder(
              valueListenable: _showPasswordNotifier,
              builder: (context, value, child) {
                return TextFieldBlocBuilder(
                  textFieldBloc: formBloc.password,
                  obscureText: value,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    label: Text(AppLocalizations.of(context)!.password),
                    hintText:
                        '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.password}',
                    hintStyle: const TextStyle(
                      color: Colors.black26,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        _showPasswordNotifier.value =
                            !_showPasswordNotifier.value;
                      },
                      child: Icon(
                        value ? Icons.visibility : Icons.visibility_off,
                        color: kGrey,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black12,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black12,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                  ),
                );
              }),
          ValueListenableBuilder(
              valueListenable: _showConfirmPasswordNotifier,
              builder: (context, value, child) {
                return TextFieldBlocBuilder(
                  textFieldBloc: formBloc.confirmPassword,
                  obscureText: value,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    label: Text(AppLocalizations.of(context)!.confirmPassword),
                    hintText:
                        '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.confirmPassword}',
                    hintStyle: const TextStyle(
                      color: Colors.black26,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        _showConfirmPasswordNotifier.value =
                            !_showConfirmPasswordNotifier.value;
                      },
                      child: Icon(
                        value ? Icons.visibility : Icons.visibility_off,
                        color: kGrey,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black12,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black12,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                  ),
                );
              }),
        ],
      ),
    );
  }

  FormBlocStep _addressStep(SignUpFormBloc formBloc) {
    return FormBlocStep(
      title: Text(
        AppLocalizations.of(context)!.address,
        style: textStyleNormal(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: formBloc.state.currentStep == 1
          ? Text(
              AppLocalizations.of(context)!.addressDesc,
              style: textStyleNormal(),
            )
          : const SizedBox(),
      content: Column(
        children: [
          TextFieldBlocBuilder(
            textFieldBloc: formBloc.address1,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              label: Text(AppLocalizations.of(context)!.address1),
              hintText:
                  '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.address1}',
              hintStyle: const TextStyle(
                color: Colors.black26,
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black12,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black12,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.8),
            ),
          ),
          TextFieldBlocBuilder(
            textFieldBloc: formBloc.address2,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              label: Text(AppLocalizations.of(context)!.address2),
              hintText:
                  '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.address2}',
              hintStyle: const TextStyle(
                color: Colors.black26,
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black12,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black12,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.8),
            ),
          ),
          TextFieldBlocBuilder(
            textFieldBloc: formBloc.address3,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              label: Text(AppLocalizations.of(context)!.address3),
              hintText:
                  '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.address3}',
              hintStyle: const TextStyle(
                color: Colors.black26,
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black12,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black12,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.8),
            ),
          ),
          TextFieldBlocBuilder(
            textFieldBloc: formBloc.postcode,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              label: Text(AppLocalizations.of(context)!.postcode),
              hintText:
                  '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.postcode}',
              hintStyle: const TextStyle(
                color: Colors.black26,
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black12,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black12,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.8),
            ),
          ),
          TextFieldBlocBuilder(
            textFieldBloc: formBloc.city,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              label: Text(AppLocalizations.of(context)!.city),
              hintText:
                  '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.city}',
              hintStyle: const TextStyle(
                color: Colors.black26,
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black12,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black12,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.8),
            ),
          ),
          TextFieldBlocBuilder(
            textFieldBloc: formBloc.states,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              label: Text(AppLocalizations.of(context)!.state),
              hintText:
                  '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.state}',
              hintStyle: const TextStyle(
                color: Colors.black26,
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black12,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black12,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.8),
            ),
          ),
          TextFieldBlocBuilder(
            textFieldBloc: formBloc.carPlateNumber,
            textInputAction: TextInputAction.next,
            inputFormatters: [
              // This ensures that the input is displayed as uppercase
              FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]")),
              UpperCaseTextFormatter(),
            ],
            decoration: InputDecoration(
              label: Text(AppLocalizations.of(context)!.carPlateNumber),
              hintText:
                  '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.carPlateNumber}',
              hintStyle: const TextStyle(
                color: Colors.black26,
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black12,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black12,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
