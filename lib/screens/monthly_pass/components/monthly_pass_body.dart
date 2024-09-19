import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/app/helpers/shared_preferences.dart';
import 'package:project/component/webview.dart';
import 'package:project/constant.dart';
import 'package:project/form_bloc/form_bloc.dart';
import 'package:project/models/models.dart';
import 'package:project/resources/resources.dart';
import 'package:project/routes/route_manager.dart';
import 'package:project/theme.dart';
import 'package:project/widget/loading_dialog.dart';
import 'package:project/widget/primary_button.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MonthlyPassBody extends StatefulWidget {
  final UserModel userModel;
  final List<PlateNumberModel> carPlates;
  final List<PBTModel> pbtModel;
  final Map<String, dynamic> details;
  const MonthlyPassBody({
    super.key,
    required this.carPlates,
    required this.userModel,
    required this.pbtModel,
    required this.details,
  });

  @override
  State<MonthlyPassBody> createState() => _MonthlyPassBodyState();
}

class _MonthlyPassBodyState extends State<MonthlyPassBody> {
  late DateTime _focusedDay;
  String selectedLocation = 'Kuantan';
  int _selectedMonth = 1;
  DateTime _dateTime = DateTime.now();
  MonthlyPassFormBloc? formBloc;
  late double amountReload;
  late MonthlyPassModel monthlyPassModel;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now(); // Initialize _focusedDay with current date
    getReloadAmount();
    monthlyPassModel = MonthlyPassModel();
  }

  Future<void> getReloadAmount() async {
    amountReload = await SharedPreferencesHelper.getReloadAmount();
  }

  Map<String, List<int>> pricesPerMonth = {
    'Kuantan': [1, 3, 12],
    'Machang': [1, 3, 6, 12],
    'Kuala Terengganu': [1, 3, 6, 12]
  };

  Map<String, Map<int, double>> prices = {
    'Kuantan': {1: 79.50, 3: 207.00, 12: 667.80},
    'Machang': {1: 60.00, 3: 180.00, 6: 360.00, 12: 720},
    'Kuala Terengganu': {1: 100, 3: 300, 6: 600, 12: 1200},
  };

  final List<String> imgName = [
    'PBT Kuantan',
    'PBT Kuala Terengganu',
    'PBT Machang',
  ];

  final List<String> imgState = [
    'Pahang',
    'Terengganu',
    'Kelantan',
  ];

  String calculateEndDate() {
    // Calculate end date based on the selected duration from the slider
    int selectedDuration = _selectedMonth.toInt();
    DateTime endDate = _dateTime.add(Duration(days: selectedDuration * 30));
    return endDate.toString().split(" ")[0];
  }

  String getDurationLabel(int months) {
    if (months == 1.0) {
      String month = Get.locale!.languageCode == 'en' ? 'month' : 'bulan';
      return '1 $month';
    } else {
      String month = Get.locale!.languageCode == 'en' ? 'months' : 'bulan';
      return '${months.toInt()} $month';
    }
  }

  double calculatePrice() {
    // Check if selectedLocation is a valid key in pricesPerMonth
    if (pricesPerMonth.containsKey(selectedLocation)) {
      // Check if _selectedMonth is a valid key in the selectedLocation
      double? price = prices[selectedLocation]?[_selectedMonth];

      // If price is not null, return it, otherwise return a default value
      return price ?? 0.0;
    } else {
      // Handle the case where selectedLocation is not a valid key
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<int> availableMonths = pricesPerMonth[selectedLocation]!;
    return BlocProvider(
      create: (context) => MonthlyPassFormBloc(
        platModel: widget.carPlates.isNotEmpty ? widget.carPlates : [],
        pbtModel: widget.pbtModel,
        details: widget.details,
        model: widget.userModel,
      ),
      child: Builder(builder: (context) {
        formBloc = BlocProvider.of<MonthlyPassFormBloc>(context);
        return FormBlocListener<MonthlyPassFormBloc, String, String>(
          onSubmitting: (context, state) {
            LoadingDialog.show(context);
          },
          onSubmissionFailed: (context, state) => LoadingDialog.hide(context),
          onSuccess: (context, state) {
            LoadingDialog.hide(context);

            final payment = GlobalState.paymentMethod;

            try {
              if (payment == 'FPX') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        WebViewPage(url: state.successResponse!),
                  ),
                ).then((value) async {
                  final order = await SharedPreferencesHelper.getOrderDetails();

                  final selectPlate =
                      await SharedPreferencesHelper.getCarPlate();

                  final durationMonthly =
                      await SharedPreferencesHelper.getMonthlyDuration();

                  final response = await ReloadResources.reloadProcess(
                    prefix: '/paymentfpx/callbackurl-fpx/',
                    body: jsonEncode({
                      'ActivityTag': "CheckPaymentStatus",
                      'LanguageCode': 'en',
                      'AppReleaseId': 34,
                      'GMTTimeDifference': 8,
                      'PaymentTxnRef': null,
                      'BillId': order['orderNo'],
                      'BillReference': "Reload${order['terminalId']}",
                    }),
                  );

                  if (response['SFM']['Constant'] ==
                      'SFM_EXECUTE_PAYMENT_SUCCESS') {
                    final response =
                        await MonthlyPassResources.createMonthlyPass(
                      prefix: '/monthlyPass/create',
                      body: jsonEncode(
                        {
                          'plateNumberId':
                              monthlyPassModel.plateNumber.toString(),
                          'pbtId': monthlyPassModel.pbt.toString(),
                          'amount': double.parse(monthlyPassModel.amount!),
                          'duration': monthlyPassModel.duration.toString(),
                          'location': monthlyPassModel.location.toString(),
                        },
                      ),
                    );

                    if (response['status'] == 'success') {
                      Navigator.pushNamed(
                        context,
                        AppRoute.monthlyPassReceiptScreen,
                        arguments: {
                          'locationDetail': widget.details,
                          'selectedCarPlate': selectPlate,
                          'amount': double.parse(response['data']['amount']),
                          'duration': durationMonthly,
                        },
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Monthly Pass Unsuccessful Store to Database'),
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Payment FPX Unseccessful'),
                      ),
                    );
                  }
                });
              } else {
                Navigator.pushNamed(
                  context,
                  AppRoute.reloadQRScreen,
                  arguments: {
                    'locationDetail': widget.details,
                    'qrCodeUrl': state.successResponse!,
                  },
                ).then((value) async {
                  final order = await SharedPreferencesHelper.getOrderDetails();

                  final selectPlate =
                      await SharedPreferencesHelper.getCarPlate();

                  final durationMonthly =
                      await SharedPreferencesHelper.getMonthlyDuration();

                  final response = await ReloadResources.reloadProcess(
                    prefix: '/payment/transaction-details',
                    body: jsonEncode({
                      'order_no': order['orderNo'],
                    }),
                  );

                  if (response['status'] == 'success') {
                    if (response['content']['order_status'] == 'successful') {
                      final response = await ReloadResources.reloadSuccessful(
                        prefix: '/payment/callbackUrl/pegeypay',
                        body: jsonEncode({
                          'order_no': order['orderNo'],
                          'order_amount': double.parse(order['amount']),
                          'order_status': order['status'],
                          'store_id': order['storeId'],
                          'shift_id': order['shiftId'],
                          'terminal_id': order['terminalId'],
                        }),
                      );

                      if (response['order_status'] == 'paid') {
                        final response =
                            await MonthlyPassResources.createMonthlyPass(
                          prefix: '/monthlyPass/create',
                          body: jsonEncode(
                            {
                              'plateNumber':
                                  monthlyPassModel.plateNumber.toString(),
                              'pbt': monthlyPassModel.pbt.toString(),
                              'amount': double.parse(monthlyPassModel.amount!),
                              'duration': monthlyPassModel.duration.toString(),
                              'location': monthlyPassModel.location.toString(),
                            },
                          ),
                        );

                        if (response['status'] == 'success') {
                          Navigator.pushNamed(
                            context,
                            AppRoute.monthlyPassReceiptScreen,
                            arguments: {
                              'locationDetail': widget.details,
                              'selectedCarPlate': selectPlate,
                              'amount':
                                  double.parse(response['data']['amount']),
                              'duration': durationMonthly,
                            },
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Monthly Pass Unsuccessful Store to Database'),
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('UnSuccessful Reload'),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(response['content']['order_status']),
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(response['status']),
                      ),
                    );
                  }
                });
              }
            } catch (e) {
              e.toString();
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 15),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_left_sharp),
                      onPressed: () {
                        setState(() {
                          _focusedDay =
                              _focusedDay.subtract(const Duration(days: 7));
                        });
                      },
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TableCalendar(
                            firstDay: DateTime.utc(2010, 10, 16),
                            lastDay: DateTime.utc(2030, 3, 14),
                            focusedDay: _focusedDay,
                            locale: Get.locale!.languageCode,
                            calendarFormat: CalendarFormat.week,
                            onFormatChanged: (format) {
                              setState(() {
                                // Update the calendar format if needed
                              });
                            },
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                _focusedDay = focusedDay;
                              });
                            },
                            headerStyle: const HeaderStyle(
                              formatButtonVisible: false,
                              titleTextStyle: TextStyle(fontSize: 0),
                            ),
                            headerVisible: false,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_right_sharp),
                      onPressed: () {
                        setState(() {
                          _focusedDay =
                              _focusedDay.add(const Duration(days: 7));
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                if (widget.carPlates.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: DropdownFieldBlocBuilder<String?>(
                      showEmptyItem: false,
                      selectFieldBloc: formBloc!.carPlateNumber,
                      decoration: InputDecoration(
                        label: Text(AppLocalizations.of(context)!.plateNumber),
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
                        // Ensure value is non-null before using it
                        if (value != null) {
                          final carPlate = widget.carPlates.firstWhere(
                            (plate) => plate.plateNumber == value,
                            orElse: () => widget.carPlates.first,
                          );

                          return FieldItem(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(value), // Display the car plate number
                                  if (carPlate.isMain == true)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      decoration: BoxDecoration(
                                        color: kGrey,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        'Default',
                                        style: textStyleNormal(),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return const FieldItem(
                              child: Text("No car plate selected"));
                        }
                      },
                    ),
                  ),
                if (widget.pbtModel.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: DropdownFieldBlocBuilder<String?>(
                      showEmptyItem: false,
                      selectFieldBloc: formBloc!.pbt, // Bind to PBT field bloc
                      decoration: InputDecoration(
                        label: const Text('PBT'),
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
                        final pbtValue = widget.pbtModel.firstWhere(
                          (pbt) => pbt.name == value,
                          orElse: () => widget.pbtModel.first,
                        );

                        return FieldItem(
                          onTap: () {
                            if (pbtValue.name == imgName[0]) {
                              formBloc!.location
                                  .updateInitialValue(imgState[0]);
                            } else if (pbtValue.name == imgName[1]) {
                              formBloc!.location
                                  .updateInitialValue(imgState[1]);
                            } else {
                              formBloc!.location
                                  .updateInitialValue(imgState[2]);
                            }
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(pbtValue.name!),
                          ),
                        );
                      },
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: DropdownFieldBlocBuilder<String?>(
                    showEmptyItem: false,
                    selectFieldBloc:
                        formBloc!.location, // Bind to PBT field bloc
                    decoration: InputDecoration(
                      label: Text(AppLocalizations.of(context)!.location),
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
                        onTap: () {
                          if (value == imgState[0]) {
                            formBloc!.pbt.updateInitialValue(imgName[0]);
                          } else if (value == imgState[1]) {
                            formBloc!.pbt.updateInitialValue(imgName[1]);
                          } else {
                            formBloc!.pbt.updateInitialValue(imgName[2]);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(value!),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisSize:
                      MainAxisSize.min, // Set the mainAxisSize to 'min'
                  mainAxisAlignment: MainAxisAlignment
                      .center, // Adjusts the position of the row items
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Align vertically in the center
                        crossAxisAlignment: CrossAxisAlignment
                            .center, // Align horizontally in the center
                        children: [
                          Text(
                            AppLocalizations.of(context)!.monthlyPass2,
                            style: GoogleFonts.dmSans(
                              color: const Color.fromARGB(255, 31, 36, 132),
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            getDurationLabel(_selectedMonth),
                            style: GoogleFonts.oswald(
                              color: const Color.fromARGB(255, 31, 36, 132),
                              fontSize: 38,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Instead of using SizedBox, give the VerticalDivider its width here
                    Container(
                      width:
                          1, // Set the width for the divider to ensure it's visible
                      height:
                          100, // Optionally adjust the height to control the divider size
                      color: kGrey,
                      margin: const EdgeInsets.symmetric(
                          horizontal:
                              20), // Add some horizontal space around the divider
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Align vertically in the center
                        crossAxisAlignment: CrossAxisAlignment
                            .center, // Align horizontally in the center
                        children: [
                          Text(
                            AppLocalizations.of(context)!.amount2,
                            style: GoogleFonts.dmSans(
                              color: const Color.fromARGB(255, 31, 36, 132),
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 30),
                          Text(
                            'RM ${calculatePrice().toStringAsFixed(2)}',
                            style: GoogleFonts.oswald(
                              color: const Color.fromARGB(255, 31, 36, 132),
                              fontSize: 38,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: const Color.fromRGBO(2, 50, 114, 1),
                    inactiveTrackColor:
                        const Color.fromRGBO(217, 217, 217, 1.0),
                    trackShape: const RoundedRectSliderTrackShape(),
                    trackHeight: 10.0,
                    overlayColor: const Color.fromRGBO(2, 50, 114, 1),
                    overlayShape:
                        const RoundSliderOverlayShape(overlayRadius: 28),
                    valueIndicatorShape:
                        const PaddleSliderValueIndicatorShape(),
                    valueIndicatorColor: const Color.fromRGBO(2, 50, 114, 1),
                  ),
                  child: Column(
                    children: <Widget>[
                      Slider(
                        min: 0,
                        max: availableMonths.length - 1,
                        divisions: availableMonths.length - 1,
                        value:
                            availableMonths.indexOf(_selectedMonth).toDouble(),
                        onChanged: (double value) {
                          setState(() {
                            _selectedMonth = availableMonths[value.toInt()];
                          });
                        },
                        label: getDurationLabel(_selectedMonth),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  borderRadius: 10.0,
                  buttonWidth: 0.8,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoute.monthlyPassPaymentScreen,
                      arguments: {
                        'selectedCarPlate': formBloc?.carPlateNumber.value!,
                        'amount': calculatePrice().toStringAsFixed(2),
                        'duration': getDurationLabel(_selectedMonth),
                        'locationDetail': widget.details,
                        'formBloc': formBloc,
                        'monthlyPassModel': monthlyPassModel,
                      },
                    );
                    formBloc!.amount
                        .updateValue(calculatePrice().toStringAsFixed(2));
                  },
                  label: Text(
                    AppLocalizations.of(context)!.confirm,
                    style: textStyleNormal(
                      color: kWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
