import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/constant.dart';
import 'package:project/form_bloc/form_bloc.dart';
import 'package:project/routes/route_manager.dart';
import 'package:project/theme.dart';
import 'package:project/widget/loading_dialog.dart';
import 'package:project/widget/primary_button.dart';
import 'package:project/widget/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  ForgotPasswordFormBloc? formBloc;

  @override
  Widget build(BuildContext context) {
    return BackgroundImage(
      appBar: AppBar(
        foregroundColor: kWhite,
        backgroundColor: Colors.transparent,
      ),
      body: BlocProvider(
        create: (context) => ForgotPasswordFormBloc(),
        child: Builder(builder: (context) {
          formBloc = BlocProvider.of<ForgotPasswordFormBloc>(context);

          return FormBlocListener<ForgotPasswordFormBloc, String, String>(
            onSubmitting: (context, state) {
              LoadingDialog.show(context);
            },
            onSubmissionFailed: (context, state) => LoadingDialog.hide(context),
            onSuccess: (context, state) {
              LoadingDialog.hide(context);

              Navigator.pushNamed(context, AppRoute.resetPasswordScreen);

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
                        AppLocalizations.of(context)!.forgetPassword,
                        style: textStyleNormal(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor,
                        ),
                      ),
                      spaceVertical(height: 20.0),
                      Text(
                        AppLocalizations.of(context)!.forgetPasswordDesc,
                        style: textStyleNormal(
                          fontWeight: FontWeight.bold,
                          color: kGrey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      spaceVertical(height: 20.0),
                      TextFieldBlocBuilder(
                        textFieldBloc: formBloc!.email,
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
