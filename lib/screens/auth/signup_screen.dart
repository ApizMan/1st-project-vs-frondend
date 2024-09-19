import 'package:flutter/material.dart';
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
        'Account',
        style: textStyleNormal(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: formBloc.state.currentStep == 0
          ? Text(
              'This section is for your\naccount information',
              style: textStyleNormal(fontSize: 12),
            )
          : const SizedBox(),
      content: Column(
        children: [
          TextFieldBlocBuilder(
            textFieldBloc: formBloc.firstName,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              label: const Text('First Name'),
              hintText: 'Enter First Name',
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
              label: const Text('Last Name'),
              hintText: 'Enter Last Name',
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
              label: const Text('Email'),
              hintText: 'Enter Email',
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
              label: const Text('ID Number'),
              hintText: 'Enter ID Number',
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
              label: const Text('Phone Number'),
              hintText: 'Enter Phone Number',
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
            textFieldBloc: formBloc.password,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              label: const Text('Password'),
              hintText: 'Enter Password',
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
            textFieldBloc: formBloc.confirmPassword,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              label: const Text('Confirm Password'),
              hintText: 'Enter Confirm Password',
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

  FormBlocStep _addressStep(SignUpFormBloc formBloc) {
    return FormBlocStep(
      title: Text(
        'Address',
        style: textStyleNormal(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: formBloc.state.currentStep == 1
          ? Text(
              'This section is for your\naddress information',
              style: textStyleNormal(),
            )
          : const SizedBox(),
      content: Column(
        children: [
          TextFieldBlocBuilder(
            textFieldBloc: formBloc.address1,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              label: const Text('Address 1'),
              hintText: 'Enter Address 1',
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
              label: const Text('Address 2'),
              hintText: 'Enter Address 2',
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
              label: const Text('Address 3'),
              hintText: 'Enter Address 3',
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
              label: const Text('Postcode'),
              hintText: 'Enter Postcode',
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
              label: const Text('City'),
              hintText: 'Enter City',
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
              label: const Text('State'),
              hintText: 'Enter State',
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
            decoration: InputDecoration(
              label: const Text('Car Plate Number'),
              hintText: 'Enter Car Plate Number',
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
