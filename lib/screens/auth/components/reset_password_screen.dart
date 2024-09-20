import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:get/get.dart';
import 'package:project/constant.dart';
import 'package:project/form_bloc/form_bloc.dart';
import 'package:project/routes/route_manager.dart';
import 'package:project/theme.dart';
import 'package:project/widget/background-image.dart';
import 'package:project/widget/loading_dialog.dart';
import 'package:project/widget/primary_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  ResetPasswordFormBloc? formBloc;

  @override
  Widget build(BuildContext context) {
    return BackgroundImage(
      appBar: AppBar(
        foregroundColor: kWhite,
        backgroundColor: Colors.transparent,
      ),
      body: BlocProvider(
        create: (context) => ResetPasswordFormBloc(),
        child: Builder(builder: (context) {
          formBloc = BlocProvider.of<ResetPasswordFormBloc>(context);

          return FormBlocListener<ResetPasswordFormBloc, String, String>(
            onSubmitting: (context, state) {
              LoadingDialog.show(context);
            },
            onSubmissionFailed: (context, state) => LoadingDialog.hide(context),
            onSuccess: (context, state) {
              LoadingDialog.hide(context);

              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoute.loginScreen,
                (route) => false,
              );

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.successResponse!),
                ),
              );
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
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 20.0),
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: const BoxDecoration(
                    color: kWhite,
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.resetPassword,
                        style: textStyleNormal(
                          fontSize: Get.locale!.languageCode == 'en' ? 28 : 24,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor,
                        ),
                      ),
                      spaceVertical(height: 20.0),
                      Text(
                        AppLocalizations.of(context)!.resetPasswordDesc,
                        style: textStyleNormal(
                          fontWeight: FontWeight.bold,
                          color: kGrey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      spaceVertical(height: 20.0),
                      TextFieldBlocBuilder(
                        textFieldBloc: formBloc!.otp,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          label: Text(AppLocalizations.of(context)!.otp),
                          hintText:
                              '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.otp}',
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
                        textFieldBloc: formBloc!.password,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          label:
                              Text(AppLocalizations.of(context)!.newPassword),
                          hintText:
                              '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.newPassword}',
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
                      spaceVertical(height: 20.0),
                      PrimaryButton(
                        buttonWidth: 0.7,
                        borderRadius: 10.0,
                        onPressed: () => formBloc!.submit(),
                        label: Text(
                          AppLocalizations.of(context)!.send,
                          style: textStyleNormal(
                            color: kWhite,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
