import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:project/component/pdf_view.dart';
import 'package:project/constant.dart';
import 'package:project/form_bloc/form_bloc.dart';
import 'package:project/models/models.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:project/widget/custom_dialog.dart';

class ReserveDocumentWidget extends StatefulWidget {
  final UpdateReserveBayFormBloc formBloc;
  final Map<String, dynamic> details;
  final ReserveBayModel reserveBay;

  const ReserveDocumentWidget({
    super.key,
    required this.formBloc,
    required this.details,
    required this.reserveBay,
  });

  @override
  State<ReserveDocumentWidget> createState() => _ReserveDocumentWidgetState();
}

class _ReserveDocumentWidgetState extends State<ReserveDocumentWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildDocumentPreview(
          context,
          widget.formBloc.designatedBay,
          AppLocalizations.of(context)!.intendedDesignatedBay,
        ),
        _buildDocumentPreview(
          context,
          widget.formBloc.certificate,
          AppLocalizations.of(context)!.companyRegistrationCertificate,
        ),
        _buildDocumentPreview(
          context,
          widget.formBloc.idCard,
          AppLocalizations.of(context)!.identificationCard,
        ),
      ],
    );
  }

  Widget _buildDocumentPreview(
      BuildContext context, TextFieldBloc stateBloc, String label) {
    return StreamBuilder<TextFieldBlocState?>(
      stream: stateBloc.stream,
      builder: (context, snapshot) {
        return TextFieldBlocBuilder(
          readOnly: true,
          textFieldBloc: stateBloc,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            prefix: ScaleTap(
              onPressed: stateBloc.value != 'empty'
                  ? () {
                      if (stateBloc.value.contains('.pdf')) {
                        // Navigate to PDF viewer screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PdfViewerScreen(
                              details: widget.details,
                              pdfUrl:
                                  stateBloc.value, // Use the value for PDF URL
                            ),
                          ),
                        );
                      } else {
                        CustomDialog.show(
                          context,
                          isDissmissable: false,
                          center: Image.network(stateBloc.value),
                          btnOkText: 'Close',
                          btnOkOnPress: () => Navigator.pop(context),
                        );
                      }
                    }
                  : null,
              child: stateBloc.value != 'empty'
                  ? stateBloc.value.contains('.pdf')
                      ? Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.2,
                          decoration: BoxDecoration(
                            color: kWhite.withOpacity(0.7),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20.0)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.picture_as_pdf,
                              color: Colors.red),
                        )
                      : Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.2,
                          decoration: BoxDecoration(
                            color: kWhite.withOpacity(0.7),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20.0)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Image.network(
                            stateBloc.value,
                            fit: BoxFit.cover,
                          ),
                        )
                  : Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.2,
                      decoration: BoxDecoration(
                        color: kWhite.withOpacity(0.7),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20.0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child:
                          const Icon(Icons.upload_file, color: kPrimaryColor),
                    ),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            label: Text(label),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            filled: true,
            fillColor: kBackgroundColor,
          ),
        );
      },
    );
  }
}
