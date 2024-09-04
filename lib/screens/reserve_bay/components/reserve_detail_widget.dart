import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/form_bloc/form_bloc.dart';

// ignore: must_be_immutable
class ReserveDetailWidget extends StatelessWidget {
  ReserveBayFormBloc formBloc;
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
            label: const Text('Company Name'),
            hintText: 'Enter Company Name',
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
            label: const Text('SSM Number'),
            hintText: 'Enter SSM Number',
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
            label: const Text('Business Type'),
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
            label: const Text('Address 1'),
            hintText: 'Enter Address 1',
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
            label: const Text('Address 2'),
            hintText: 'Enter Address 2',
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
            label: const Text('Address 3'),
            hintText: 'Enter Address 3',
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
            label: const Text('Postcode'),
            hintText: 'Enter Postcode',
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
            label: const Text('City'),
            hintText: 'Enter City',
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
            label: const Text('State'),
            hintText: 'Enter State',
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
