import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:project/constant.dart';
import 'package:project/form_bloc/form_bloc.dart';

class ReserveDocumentWidget extends StatelessWidget {
  final ReserveBayFormBloc formBloc;
  const ReserveDocumentWidget({super.key, required this.formBloc});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFieldBlocBuilder(
          readOnly: true,
          textFieldBloc: formBloc.designatedBayName,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            prefix: ScaleTap(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['pdf'],
                );

                if (result != null) {
                  final file = result.files.single;
                  formBloc.designatedBayName.updateValue(file.name);
                  formBloc.designatedBay.updateValue(file.path ?? '');
                }
              },
              child: formBloc.idCard.value != ''
                  ? const SizedBox()
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
            label: const Text('Intended Designated Bay'),
            border: InputBorder.none,
            enabledBorder: formBloc.idCard.value != ''
                ? OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black12,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  )
                : InputBorder.none,
            filled: true,
            fillColor: kBackgroundColor,
          ),
        ),
        TextFieldBlocBuilder(
          readOnly: true,
          textFieldBloc: formBloc.certificateName,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            prefix: ScaleTap(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['pdf'],
                );

                if (result != null) {
                  final file = result.files.single;
                  formBloc.certificateName.updateValue(file.name);
                  formBloc.certificate.updateValue(file.path ?? '');
                }
              },
              child: formBloc.idCard.value != ''
                  ? const SizedBox()
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
            label: const Text('Company Registration Certificate'),
            border: InputBorder.none,
            enabledBorder: formBloc.idCard.value != ''
                ? OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black12,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  )
                : InputBorder.none,
            filled: true,
            fillColor: kBackgroundColor,
          ),
        ),
        TextFieldBlocBuilder(
          readOnly: true,
          textFieldBloc: formBloc.idCardName,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            prefix: ScaleTap(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['pdf'],
                );

                if (result != null) {
                  final file = result.files.single;
                  formBloc.idCardName.updateValue(file.name);
                  formBloc.idCard.updateValue(file.path ?? '');
                }
              },
              child: formBloc.idCard.value != ''
                  ? const SizedBox()
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
            label: const Text('Identification Card (Front & Back)'),
            border: InputBorder.none,
            enabledBorder: formBloc.idCard.value != ''
                ? OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black12,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  )
                : InputBorder.none,
            filled: true,
            fillColor: kBackgroundColor,
          ),
        ),
      ],
    );
  }
}
