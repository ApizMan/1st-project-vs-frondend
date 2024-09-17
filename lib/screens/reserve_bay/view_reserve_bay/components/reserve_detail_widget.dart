import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/constant.dart';
import 'package:project/form_bloc/form_bloc.dart';
import 'package:project/models/models.dart';

// ignore: must_be_immutable
class ReserveDetailWidget extends StatelessWidget {
  UpdateReserveBayFormBloc formBloc;
  ReserveBayModel reserveBay;
  ReserveDetailWidget({
    super.key,
    required this.formBloc,
    required this.reserveBay,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFieldBlocBuilder(
          readOnly: true,
          textFieldBloc: formBloc.companyName,
          decoration: InputDecoration(
            label: const Text('Company Name'),
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
          readOnly: true,
          textFieldBloc: formBloc.ssm,
          decoration: InputDecoration(
            label: const Text('SSM Number'),
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
          readOnly: true,
          textFieldBloc: formBloc.businessType,
          decoration: InputDecoration(
            label: const Text('Business Type'),
            hintStyle: const TextStyle(
              color: Colors.black26,
            ),
            suffixIcon: const Icon(
              Icons.arrow_drop_down,
              color: kGrey,
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
          readOnly: true,
          textFieldBloc: formBloc.address1,
          decoration: InputDecoration(
            label: const Text('Address 1'),
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
          readOnly: true,
          textFieldBloc: formBloc.address2,
          decoration: InputDecoration(
            label: const Text('Address 2'),
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
          readOnly: true,
          textFieldBloc: formBloc.address3,
          decoration: InputDecoration(
            label: const Text('Address 3'),
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
          readOnly: true,
          textFieldBloc: formBloc.postcode,
          decoration: InputDecoration(
            label: const Text('Postcode'),
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
          readOnly: true,
          textFieldBloc: formBloc.city,
          decoration: InputDecoration(
            label: const Text('City'),
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
          readOnly: true,
          textFieldBloc: formBloc.states,
          decoration: InputDecoration(
            label: const Text('State'),
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
