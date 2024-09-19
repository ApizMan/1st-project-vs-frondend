import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/constant.dart';
import 'package:project/form_bloc/form_bloc.dart';
import 'package:project/models/models.dart';
import 'package:project/screens/reserve_bay/view_reserve_bay/components/reserve_detail_widget.dart';
import 'package:project/screens/reserve_bay/view_reserve_bay/components/reserve_document_widget.dart';
import 'package:project/screens/reserve_bay/view_reserve_bay/components/reserve_incharge_widget.dart';
import 'package:project/screens/reserve_bay/view_reserve_bay/components/reserve_tnc_widget.dart';
import 'package:project/theme.dart';
import 'package:project/widget/loading_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ViewReserveBayScreen extends StatefulWidget {
  const ViewReserveBayScreen({super.key});

  @override
  State<ViewReserveBayScreen> createState() => _ViewReserveBayScreenState();
}

class _ViewReserveBayScreenState extends State<ViewReserveBayScreen> {
  UpdateReserveBayFormBloc? formBloc;
  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    Map<String, dynamic> details =
        arguments['locationDetail'] as Map<String, dynamic>;
    ReserveBayModel reserveBay =
        arguments['reserveBayModel'] as ReserveBayModel;
    return BlocProvider(
      create: (context) => UpdateReserveBayFormBloc(
        model: reserveBay,
      ),
      child: Builder(
        builder: (context) {
          formBloc = BlocProvider.of<UpdateReserveBayFormBloc>(context);
          return FormBlocListener<UpdateReserveBayFormBloc, String, String>(
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
                foregroundColor:
                    details['color'] == 4294961979 ? kBlack : kWhite,
                backgroundColor: Color(details['color']),
                centerTitle: true,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.viewReserveBay,
                      style: textStyleNormal(
                        fontSize: 26,
                        color: details['color'] == 4294961979 ? kBlack : kWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    spaceVertical(height: 5.0),
                    Text(
                      '${AppLocalizations.of(context)!.company}: ${reserveBay.companyName!}',
                      style: textStyleNormal(
                        color: details['color'] == 4294961979 ? kBlack : kWhite,
                      ),
                    ),
                  ],
                ),
              ),
              body: StepperFormBlocBuilder<UpdateReserveBayFormBloc>(
                formBloc: context.read<UpdateReserveBayFormBloc>(),
                type: StepperType.horizontal,
                physics: const BouncingScrollPhysics(),
                stepsBuilder: (formBloc) {
                  return [
                    _reserveStep1(formBloc!, reserveBay),
                    _reserveStep2(formBloc, reserveBay),
                    _reserveStep3(formBloc, reserveBay),
                    _reserveStep4(formBloc, reserveBay),
                  ];
                },
                onStepTapped: (formBloc, step) {
                  if (step == 0) {
                    formBloc!.updateCurrentStep(0);
                  } else if (step == 1) {
                    formBloc!.updateCurrentStep(1);
                  } else if (step == 2) {
                    formBloc!.updateCurrentStep(2);
                  } else if (step == 3) {
                    formBloc!.updateCurrentStep(3);
                  }
                },
                controlsBuilder:
                    (context, onStepContinue, onStepCancel, step, formBloc) =>
                        const SizedBox(),
              ),
            ),
          );
        },
      ),
    );
  }

  FormBlocStep _reserveStep1(
      UpdateReserveBayFormBloc reserveBayFormBloc, ReserveBayModel reserveBay) {
    return FormBlocStep(
      title: Text(
        AppLocalizations.of(context)!.reserveDetails,
        style: textStyleNormal(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: ReserveDetailWidget(
        formBloc: reserveBayFormBloc,
        reserveBay: reserveBay,
      ),
    );
  }

  FormBlocStep _reserveStep2(
      UpdateReserveBayFormBloc reserveBayFormBloc, ReserveBayModel reserveBay) {
    return FormBlocStep(
      title: Text(
        'PIC',
        style: textStyleNormal(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: ReserveInChargeWidget(
        formBloc: reserveBayFormBloc,
        reserveBay: reserveBay,
      ),
    );
  }

  FormBlocStep _reserveStep3(
      UpdateReserveBayFormBloc reserveBayFormBloc, ReserveBayModel reserveBay) {
    return FormBlocStep(
      title: Text(
        AppLocalizations.of(context)!.documents,
        style: textStyleNormal(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: ReserveDocumentWidget(
        formBloc: reserveBayFormBloc,
        reserveBay: reserveBay,
      ),
    );
  }

  FormBlocStep _reserveStep4(
      UpdateReserveBayFormBloc reserveBayFormBloc, ReserveBayModel reserveBay) {
    return FormBlocStep(
      title: Text(
        AppLocalizations.of(context)!.tnc,
        style: textStyleNormal(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: ReserveTncWidget(
        formBloc: reserveBayFormBloc,
        reserveBay: reserveBay,
      ),
    );
  }
}
