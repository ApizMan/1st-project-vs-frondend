import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/component/home_screen.dart';
import 'package:project/component/signup_screen.dart';
import 'package:project/constant.dart';
import 'package:project/form_bloc/form_bloc.dart';
import 'package:project/resources/auth/auth_resources.dart';
import 'package:project/routes/route_manager.dart';
import 'package:project/theme.dart';
import 'package:project/widget/loading_dialog.dart';
import 'package:project/widget/primary_button.dart';
import 'package:project/widget/primary_button.dart';
import 'package:project/widget/widgets.dart';
import 'package:project/widget/background-image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  bool forgotpassword = false;
  late bool showPassword;
  late ValueNotifier<bool> _showPasswordNotifier;
  LoginFormBloc? formBloc;

  void _forgotPassword() {
    setState(() {
      forgotpassword = !forgotpassword;
    });
  }

  @override
  void initState() {
    super.initState();
    showPassword = true;
    _showPasswordNotifier = ValueNotifier<bool>(showPassword);
  }

  @override
  void dispose() {
    _showPasswordNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundImage(
      body: BlocProvider(
        create: (context) => LoginFormBloc(),
        child: Builder(
          builder: (context) {
            formBloc = BlocProvider.of<LoginFormBloc>(context);
            return FormBlocListener<LoginFormBloc, String, String>(
              onSubmitting: (context, state) {
                LoadingDialog.show(context);
              },
              onSubmissionFailed: (context, state) =>
                  LoadingDialog.hide(context),
              onSuccess: (context, state) {
                LoadingDialog.hide(context);
                Navigator.popAndPushNamed(
                  context,
                  AppRoute.homeScreen,
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 175.0,
                          height: 112.0,
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                              image: AssetImage(logo),
                            ),
                          ),
                        ),
                        const SizedBox(height: 35.0),
                        TextFieldBlocBuilder(
                          textFieldBloc: formBloc!.email,
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
                        ValueListenableBuilder(
                          valueListenable: _showPasswordNotifier,
                          builder: (context, value, child) {
                            return TextFieldBlocBuilder(
                              textFieldBloc: formBloc!.password,
                              obscureText: value,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                label: const Text('Password'),
                                hintText: 'Enter Password',
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    _showPasswordNotifier.value =
                                        !_showPasswordNotifier.value;
                                  },
                                  child: Icon(
                                    value
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: kGrey,
                                  ),
                                ),
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
                            );
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: CheckboxFieldBlocBuilder(
                                booleanFieldBloc: formBloc!.rememberMe,
                                body: Text(
                                  'Remember Me',
                                  style: textStyleNormal(
                                    fontWeight: FontWeight.bold,
                                    color: kPrimaryColor,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: _forgotPassword,
                              child: Text(
                                'Forget Password?',
                                style: textStyleNormal(
                                  fontWeight: FontWeight.bold,
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25.0),
                        PrimaryButton(
                          buttonWidth: 0.9,
                          borderRadius: 10.0,
                          onPressed: () => formBloc!.submit(),
                          label: Text(
                            'Login',
                            style: textStyleNormal(
                              color: kWhite,
                            ),
                          ),
                        ),
                        spaceVertical(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: textStyleNormal(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, AppRoute.signupScreen);
                              },
                              child: Text(
                                "Sign Up",
                                style: textStyleNormal(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
