import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ntp/ntp.dart';
import 'package:project/app/helpers/shared_preferences.dart';
import 'package:project/constant.dart';
import 'package:project/form_bloc/form_bloc.dart';
import 'package:project/models/models.dart';
import 'package:project/routes/route_manager.dart';
import 'package:project/theme.dart';
import 'package:project/widget/loading_dialog.dart';
import 'package:project/widget/primary_button.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ParkingBodyScreen extends StatefulWidget {
  final UserModel userModel;
  final List<PlateNumberModel> carPlates;
  final List<PBTModel> pbtModel;
  final Map<String, dynamic> details;

  const ParkingBodyScreen({
    super.key,
    required this.userModel,
    required this.carPlates,
    required this.pbtModel,
    required this.details,
  });

  @override
  State<ParkingBodyScreen> createState() => _ParkingBodyScreenState();
}

class _ParkingBodyScreenState extends State<ParkingBodyScreen> {
  double _value = 0.65;
  int _remainingTime = 3600;
  DateTime _focusedDay = DateTime.now();
  List<PlateNumberModel> carPlates = [];
  String? selectedCarPlate;
  StoreParkingFormBloc? formBloc;

  final List<String> imgList = [
    kuantanLogo,
    terengganuLogo,
    machangLogo,
  ];

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

  // Helper method to get the color based on index
  int getColorForIndex(int index) {
    switch (index) {
      case 0:
        return kPrimaryColor.value;
      case 1:
        return kOrange.value;
      case 2:
        return kYellow.value;
      default:
        return Colors.transparent.value; // Default color or handle error
    }
  }

  @override
  void initState() {
    super.initState();
    getTime();
    // Check if carPlates list is not empty
    try {
      // Check if carPlates list is not empty
      if (widget.carPlates.isNotEmpty) {
        PlateNumberModel mainCarPlate = widget.carPlates.firstWhere(
          (plate) => plate.isMain == true,
          orElse: () => widget.carPlates.first,
        );
        // Set the selectedCarPlate with both plateNumber and id to match the Dropdown value
        selectedCarPlate = '${mainCarPlate.plateNumber}-${mainCarPlate.id}';
      } else {
        // Handle case where no car plates are available
        selectedCarPlate = null;
      }
    } catch (e) {
      e.toString();
    }
  }

  Future<void> getTime() async {
    _focusedDay = await NTP.now();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocProvider(
        create: (context) => StoreParkingFormBloc(
          platModel: widget.carPlates.isNotEmpty ? widget.carPlates : [],
          pbtModel: widget.pbtModel,
          details: widget.details,
        ),
        child: Builder(builder: (context) {
          formBloc = BlocProvider.of<StoreParkingFormBloc>(context);
          return FormBlocListener<StoreParkingFormBloc, String, String>(
            onSubmitting: (context, state) {
              LoadingDialog.show(context);
            },
            onSubmissionFailed: (context, state) => LoadingDialog.hide(context),
            onSuccess: (context, state) {
              LoadingDialog.hide(context);

              Navigator.popAndPushNamed(context, AppRoute.parkingReceiptScreen,
                  arguments: {
                    'userModel': widget.userModel,
                    'locationDetail': widget.details,
                    'amount': _value.toStringAsFixed(2),
                  });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.successResponse!),
                ),
              );
            },
            onFailure: (context, state) {
              LoadingDialog.hide(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.failureResponse!),
                ),
              );
            },
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
                      isEnabled: false,
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
                        return FieldItem(
                          onTap: () async {
                            if (value == imgName[0]) {
                              formBloc!.location
                                  .updateInitialValue(imgState[0]);

                              // Only handle the tapped item
                              await SharedPreferencesHelper.saveLocationDetail(
                                location: imgName[0],
                                state: imgState[0],
                                logo: imgList[0],
                                color: getColorForIndex(0),
                              );
                            } else if (value == imgName[1]) {
                              formBloc!.location
                                  .updateInitialValue(imgState[1]);

                              // Only handle the tapped item
                              await SharedPreferencesHelper.saveLocationDetail(
                                location: imgName[1],
                                state: imgState[1],
                                logo: imgList[1],
                                color: getColorForIndex(1),
                              );
                            } else {
                              formBloc!.location
                                  .updateInitialValue(imgState[2]);

                              // Only handle the tapped item
                              await SharedPreferencesHelper.saveLocationDetail(
                                location: imgName[2],
                                state: imgState[2],
                                logo: imgList[2],
                                color: getColorForIndex(2),
                              );
                            }

                            setState(() {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                AppRoute.homeScreen,
                                (route) => false,
                              );
                            });
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(value!),
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
                        onTap: () async {
                          if (value == imgState[0]) {
                            formBloc!.pbt.updateInitialValue(imgName[0]);
                            // Only handle the tapped item
                            await SharedPreferencesHelper.saveLocationDetail(
                              location: imgName[0],
                              state: imgState[0],
                              logo: imgList[0],
                              color: getColorForIndex(0),
                            );
                          } else if (value == imgState[1]) {
                            formBloc!.pbt.updateInitialValue(imgName[1]);
                            // Only handle the tapped item
                            await SharedPreferencesHelper.saveLocationDetail(
                              location: imgName[1],
                              state: imgState[1],
                              logo: imgList[1],
                              color: getColorForIndex(1),
                            );
                          } else {
                            formBloc!.pbt.updateInitialValue(imgName[2]);
                            // Only handle the tapped item
                            await SharedPreferencesHelper.saveLocationDetail(
                              location: imgName[2],
                              state: imgState[2],
                              logo: imgList[2],
                              color: getColorForIndex(2),
                            );
                          }

                          setState(() {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              AppRoute.homeScreen,
                              (route) => false,
                            );
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(value!),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              const SizedBox(height: 35),
                              Text(
                                AppLocalizations.of(context)!.duration,
                                style: GoogleFonts.secularOne(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                _formatDuration(_remainingTime),
                                style: GoogleFonts.secularOne(
                                  fontSize: 30,
                                  color: const Color.fromARGB(255, 12, 59, 97),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                AppLocalizations.of(context)!.amount,
                                style: GoogleFonts.secularOne(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'RM ${_value.toStringAsFixed(2)}',
                                style: GoogleFonts.secularOne(
                                  fontSize: 30,
                                  color: const Color.fromARGB(255, 19, 3, 108),
                                ),
                              ),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor:
                                      const Color.fromRGBO(2, 50, 114, 1),
                                  inactiveTickMarkColor:
                                      const Color.fromRGBO(217, 217, 217, 1.0),
                                  trackShape:
                                      const RoundedRectSliderTrackShape(),
                                  trackHeight: 10.0,
                                  overlayColor:
                                      const Color.fromRGBO(2, 50, 114, 1),
                                  overlayShape: const RoundSliderOverlayShape(
                                      overlayRadius: 28),
                                  valueIndicatorShape:
                                      const PaddleSliderValueIndicatorShape(),
                                  valueIndicatorColor:
                                      const Color.fromRGBO(2, 50, 114, 1),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Slider(
                                        min: 0.65,
                                        max: 4.8,
                                        divisions: 6,
                                        label:
                                            '${(((_value - 0.65) / (4.80 - 0.65) * 5) + 1).round()} hour',
                                        value: _value,
                                        onChanged: (double value) {
                                          setState(() {
                                            _value =
                                                (value / 0.65).round() * 0.65;
                                            _remainingTime = ((_value - 0.65) /
                                                            (4.80 - 0.65) *
                                                            5 +
                                                        1)
                                                    .round() *
                                                3600;
                                          });
                                        }),
                                  ],
                                ),
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
                spaceVertical(height: 20.0),
                PrimaryButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoute.parkingPaymentScreen,
                      arguments: {
                        'userModel': widget.userModel,
                        'selectedCarPlate': formBloc?.carPlateNumber.value!,
                        'duration': _formatDuration(_remainingTime),
                        'amount': _value.toStringAsFixed(2),
                        'locationDetail': widget.details,
                        'formBloc': formBloc,
                      },
                    );
                  },
                  label: Text(
                    AppLocalizations.of(context)!.confirm,
                    style: textStyleNormal(
                      color: kWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  buttonWidth: 0.8,
                  borderRadius: 10.0,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  String _formatDuration(int totalSeconds) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");

    int hours = totalSeconds ~/ 3600;
    int remainingMinutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    String formattedHours = twoDigits(hours);
    String formattedMinutes = twoDigits(remainingMinutes);
    String formattedSeconds = twoDigits(seconds);

    return "$formattedHours:$formattedMinutes:$formattedSeconds";
  }
}
