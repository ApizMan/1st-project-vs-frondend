import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/form_bloc/form_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class ReserveDetailWidget extends StatelessWidget {
  StoreReserveBayFormBloc formBloc;
  ReserveDetailWidget({
    super.key,
    required this.formBloc,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFieldBlocBuilder(
          textFieldBloc: formBloc.companyName,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            label: Text(AppLocalizations.of(context)!.companyName),
            hintText:
                '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.companyName}',
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
          textFieldBloc: formBloc.ssm,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            label: Text(AppLocalizations.of(context)!.ssmNumber),
            hintText:
                '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.ssmNumber}',
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
          selectFieldBloc: formBloc.businessType,
          decoration: InputDecoration(
            label: Text(AppLocalizations.of(context)!.businessType),
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
          textFieldBloc: formBloc.address1,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            label: Text(AppLocalizations.of(context)!.address1),
            hintText:
                '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.address1}',
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
          textFieldBloc: formBloc.address2,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            label: Text(AppLocalizations.of(context)!.address2),
            hintText:
                '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.address2}',
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
          textFieldBloc: formBloc.address3,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            label: Text(AppLocalizations.of(context)!.address3),
            hintText:
                '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.address3}',
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
          textFieldBloc: formBloc.postcode,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            label: Text(AppLocalizations.of(context)!.postcode),
            hintText:
                '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.postcode}',
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
          textFieldBloc: formBloc.city,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            label:  Text(AppLocalizations.of(context)!.city),
            hintText: '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.city}',
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
          textFieldBloc: formBloc.states,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            label: Text(AppLocalizations.of(context)!.state),
            hintText: '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.state}',
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
