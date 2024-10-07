// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:project/constant.dart';
import 'package:project/form_bloc/form_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReserveDocumentWidget extends StatelessWidget {
  final StoreReserveBayFormBloc formBloc;

  const ReserveDocumentWidget({super.key, required this.formBloc});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildDocumentField(
          context,
          label: AppLocalizations.of(context)!.intendedDesignatedBay,
          textFieldBloc: formBloc.designatedBayName,
          fileTypeBloc: formBloc.designatedBay,
          allowedExtensions: ['pdf'],
        ),
        _buildDocumentField(
          context,
          label: AppLocalizations.of(context)!.companyRegistrationCertificate,
          textFieldBloc: formBloc.certificateName,
          fileTypeBloc: formBloc.certificate,
          allowedExtensions: ['pdf'],
        ),
        _buildDocumentField(
          context,
          label: AppLocalizations.of(context)!.identificationCard,
          textFieldBloc: formBloc.idCardName,
          fileTypeBloc: formBloc.idCard,
          allowedExtensions: ['pdf'],
        ),
      ],
    );
  }

  Widget _buildDocumentField(
    BuildContext context, {
    required String label,
    required TextFieldBloc textFieldBloc,
    required TextFieldBloc fileTypeBloc,
    required List<String> allowedExtensions,
  }) {
    return StreamBuilder<TextFieldBlocState?>(
      stream: textFieldBloc.stream,
      builder: (context, snapshot) {
        return TextFieldBlocBuilder(
          readOnly: true,
          textFieldBloc: textFieldBloc,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            prefix: ScaleTap(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: allowedExtensions,
                );

                if (result != null) {
                  final file = File(result.files.single.path!);

                  // Show a loading indicator while uploading
                  showDialog(
                    context: context,
                    builder: (context) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );

                  // Upload file to Firebase and get the URL
                  String url = await _uploadFileToFirebase(file);

                  // Remove the loading indicator
                  Navigator.pop(context);

                  if (url.isNotEmpty) {
                    // Update the TextFieldBloc with the file name and URL
                    textFieldBloc.updateValue(file.path.split('/').last);
                    fileTypeBloc.updateValue(url);
                  }
                }
              },
              child: fileTypeBloc.value != 'empty'
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
            suffixIcon: fileTypeBloc.value != 'empty'
                ? GestureDetector(
                    onTap: () {
                      fileTypeBloc.updateValue('empty');
                      textFieldBloc.updateValue('');
                    },
                    child: const Icon(
                      Icons.close,
                      color: kRed,
                    ),
                  )
                : const SizedBox(),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            label: Text(label),
            border: InputBorder.none,
            enabledBorder: fileTypeBloc.value != 'empty'
                ? OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black12,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  )
                : InputBorder.none,
            focusedBorder: fileTypeBloc.value != 'empty'
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
        );
      },
    );
  }

  // Helper function to upload file to Firebase and get the download URL
  Future<String> _uploadFileToFirebase(File file) async {
    try {
      // Create a reference to the Firebase Storage location
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('uploads/${file.path.split('/').last}');

      // Upload the file
      final uploadTask = storageRef.putFile(file);

      // Wait for the upload to complete and get the download URL
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      return e.toString();
    }
  }
}
