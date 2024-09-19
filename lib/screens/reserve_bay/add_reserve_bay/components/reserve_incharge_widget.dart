import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/form_bloc/form_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class ReserveInChargeWidget extends StatelessWidget {
  StoreReserveBayFormBloc formBloc;
  ReserveInChargeWidget({
    super.key,
    required this.formBloc,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFieldBlocBuilder(
          textFieldBloc: formBloc.picFirstName,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            label: Text(AppLocalizations.of(context)!.firstName),
            hintText:
                '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.firstName} ${AppLocalizations.of(context)!.personInCharge}',
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
          textFieldBloc: formBloc.picLastName,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            label: Text(AppLocalizations.of(context)!.lastName),
            hintText:
                '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.lastName} ${AppLocalizations.of(context)!.personInCharge}',
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
            label: Text(AppLocalizations.of(context)!.phoneNumber),
            hintText:
                '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.phoneNumber}',
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
        TextFieldBlocBuilder(
          textFieldBloc: formBloc.idNumber,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            label: Text(AppLocalizations.of(context)!.idNumber),
            hintText:
                '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.idNumber}',
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
        DropdownFieldBlocBuilder<String?>(
          showEmptyItem: false,
          selectFieldBloc: formBloc.totalLot,
          decoration: InputDecoration(
            label: Text(AppLocalizations.of(context)!.totalLot),
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
          itemBuilder: (context, value) {
            return FieldItem(
              child: Text(value!),
            );
          },
        ),
        TextFieldBlocBuilder(
          textFieldBloc: formBloc.reason,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            label: Text(AppLocalizations.of(context)!.reason),
            hintText:
                '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.reason}',
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
          textFieldBloc: formBloc.lotNumber,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            label: Text(AppLocalizations.of(context)!.lotNumber),
            hintText:
                '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.lotNumber}',
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
          textFieldBloc: formBloc.location,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            label: Text(AppLocalizations.of(context)!.location),
            hintText:
                '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.location}',
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
    );
  }
}
