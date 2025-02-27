import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/constant.dart';
import 'package:project/form_bloc/form_bloc.dart';
import 'package:project/screens/screens.dart';
import 'package:project/theme.dart';
import 'package:project/widget/loading_dialog.dart';
import 'package:project/widget/primary_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddReserveBayScreen extends StatefulWidget {
  const AddReserveBayScreen({super.key});

  @override
  State<AddReserveBayScreen> createState() => _AddReserveBayScreenState();
}

class _AddReserveBayScreenState extends State<AddReserveBayScreen> {
  StoreReserveBayFormBloc? formBloc;
  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    Map<String, dynamic> details =
        arguments['locationDetail'] as Map<String, dynamic>;
    return BlocProvider(
      create: (context) => StoreReserveBayFormBloc(),
      child: Builder(builder: (context) {
        formBloc = BlocProvider.of<StoreReserveBayFormBloc>(context);
        return FormBlocListener<StoreReserveBayFormBloc, String, String>(
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
                AppLocalizations.of(context)!.addReserveBay,
                style: textStyleNormal(
                  fontSize: 26,
                  color: details['color'] == 4294961979 ? kBlack : kWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: StepperFormBlocBuilder<StoreReserveBayFormBloc>(
              formBloc: context.read<StoreReserveBayFormBloc>(),
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
                              AppLocalizations.of(context)!.back,
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
                              AppLocalizations.of(context)!.next,
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
                              AppLocalizations.of(context)!.next,
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
                              AppLocalizations.of(context)!.next,
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
                              AppLocalizations.of(context)!.submit,
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

  FormBlocStep _reserveStep1(StoreReserveBayFormBloc reserveBayFormBloc) {
    return FormBlocStep(
      title: Text(
        AppLocalizations.of(context)!.reserveDetails,
        style: textStyleNormal(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: ReserveDetailWidget(formBloc: reserveBayFormBloc),
    );
  }

  FormBlocStep _reserveStep2(StoreReserveBayFormBloc reserveBayFormBloc) {
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

  FormBlocStep _reserveStep3(StoreReserveBayFormBloc reserveBayFormBloc) {
    return FormBlocStep(
      title: Text(
        AppLocalizations.of(context)!.documents,
        style: textStyleNormal(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: ReserveDocumentWidget(formBloc: reserveBayFormBloc),
    );
  }

  FormBlocStep _reserveStep4(StoreReserveBayFormBloc reserveBayFormBloc) {
    return FormBlocStep(
      title: Text(
        AppLocalizations.of(context)!.tnc,
        style: textStyleNormal(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: ReserveTncWidget(formBloc: reserveBayFormBloc),
    );
  }
}
