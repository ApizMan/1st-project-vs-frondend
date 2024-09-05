import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/constant.dart';
import 'package:project/form_bloc/form_bloc.dart';
import 'package:project/screens/screens.dart';
import 'package:project/theme.dart';
import 'package:project/widget/loading_dialog.dart';
import 'package:project/widget/primary_button.dart';

class ReserveBayScreen extends StatefulWidget {
  const ReserveBayScreen({super.key});

  @override
  State<ReserveBayScreen> createState() => _ReserveBayScreenState();
}

class _ReserveBayScreenState extends State<ReserveBayScreen> {
  ReserveBayFormBloc? formBloc;
  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    Map<String, dynamic> details =
        arguments['locationDetail'] as Map<String, dynamic>;
    return BlocProvider(
      create: (context) => ReserveBayFormBloc(),
      child: Builder(builder: (context) {
        formBloc = BlocProvider.of<ReserveBayFormBloc>(context);
        return FormBlocListener<ReserveBayFormBloc, String, String>(
          onSubmitting: (context, state) {
            LoadingDialog.show(context);
          },
          onSubmissionFailed: (context, state) => LoadingDialog.hide(context),
          onSuccess: (context, state) {
            LoadingDialog.hide(context);

            if (state.stepCompleted == state.lastStep) {
              Navigator.pop(context);
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
          child: Scaffold(
            backgroundColor: kBackgroundColor,
            appBar: AppBar(
              toolbarHeight: 100,
              foregroundColor: details['color'] == 4294961979 ? kBlack : kWhite,
              backgroundColor: Color(details['color']),
              centerTitle: true,
              title: Text(
                'Reserve Bay',
                style: textStyleNormal(
                  fontSize: 26,
                  color: details['color'] == 4294961979 ? kBlack : kWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: StepperFormBlocBuilder<ReserveBayFormBloc>(
              formBloc: context.read<ReserveBayFormBloc>(),
              type: StepperType.horizontal,
              physics: const BouncingScrollPhysics(),
              stepsBuilder: (formBloc) {
                return [
                  _reserveStep1(formBloc!),
                  _reserveStep2(formBloc),
                  _reserveStep3(formBloc),
                  _reserveStep4(formBloc),
                ];
              },
              controlsBuilder:
                  (context, onStepContinue, onStepCancel, step, formBloc) {
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
                              'Back',
                              style: textStyleNormal(color: kWhite),
                            ),
                          ),
                        ),
                      ),
                      spaceHorizontal(width: step != 0 ? 20.0 : 0),
                      if (step == 0)
                        Expanded(
                          flex: 100,
                          child: PrimaryButton(
                            onPressed: onStepContinue,
                            borderRadius: 10.0,
                            label: Text(
                              'Next',
                              style: textStyleNormal(color: kWhite),
                            ),
                          ),
                        )
                      else if (step == 1)
                        Expanded(
                          flex: 1,
                          child: PrimaryButton(
                            onPressed: onStepContinue,
                            borderRadius: 10.0,
                            label: Text(
                              'Next',
                              style: textStyleNormal(color: kWhite),
                            ),
                          ),
                        )
                      else if (step == 2)
                        Expanded(
                          flex: 1,
                          child: PrimaryButton(
                            onPressed: onStepContinue,
                            borderRadius: 10.0,
                            label: Text(
                              'Next',
                              style: textStyleNormal(color: kWhite),
                            ),
                          ),
                        )
                      else
                        Expanded(
                          flex: 1,
                          child: PrimaryButton(
                            onPressed: () {
                              setState(() {
                                formBloc.submit();
                              });
                            },
                            borderRadius: 10.0,
                            label: Text(
                              'Submit',
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
        );
      }),
    );
  }

  FormBlocStep _reserveStep1(ReserveBayFormBloc reserveBayFormBloc) {
    return FormBlocStep(
      title: Text(
        'Reserve\nDetails',
        style: textStyleNormal(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: ReserveDetailWidget(formBloc: reserveBayFormBloc),
    );
  }

  FormBlocStep _reserveStep2(ReserveBayFormBloc reserveBayFormBloc) {
    return FormBlocStep(
      title: Text(
        'PIC',
        style: textStyleNormal(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: ReserveInChargeWidget(formBloc: reserveBayFormBloc),
    );
  }

  FormBlocStep _reserveStep3(ReserveBayFormBloc reserveBayFormBloc) {
    return FormBlocStep(
      title: Text(
        'Documents',
        style: textStyleNormal(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: ReserveDocumentWidget(formBloc: reserveBayFormBloc),
    );
  }

  FormBlocStep _reserveStep4(ReserveBayFormBloc reserveBayFormBloc) {
    return FormBlocStep(
      title: Text(
        'T&C',
        style: textStyleNormal(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: ReserveTncWidget(formBloc: reserveBayFormBloc),
    );
  }
}
