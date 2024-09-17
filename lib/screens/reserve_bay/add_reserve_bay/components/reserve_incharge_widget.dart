import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/form_bloc/form_bloc.dart';

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
            label: const Text('First Name'),
            hintText: 'Enter Person In Charge First Name',
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
            label: const Text('Last Name'),
            hintText: 'Enter Person In Charge Last Name',
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
            label: const Text('Phone Number'),
            hintText: 'Enter Phone Number',
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
        TextFieldBlocBuilder(
          textFieldBloc: formBloc.idNumber,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            label: const Text('ID Number'),
            hintText: 'Enter ID Number',
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
            label: const Text('Total Lot'),
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
            label: const Text('Reason'),
            hintText: 'Enter Reason',
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
            label: const Text('Lot Number'),
            hintText: 'Enter Lot Number',
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
            label: const Text('Location'),
            hintText: 'Enter Location',
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
