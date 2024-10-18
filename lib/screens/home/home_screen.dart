// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as permission;
import 'package:project/app/helpers/shared_preferences.dart';
import 'package:project/constant.dart';
import 'package:project/models/models.dart';
import 'package:project/resources/resources.dart';
import 'package:project/routes/route_manager.dart';
import 'package:project/screens/home/components/countdown_screen.dart';
import 'package:project/screens/screens.dart';
import 'package:project/theme.dart';
import 'package:project/widget/custom_dialog.dart';
import 'package:project/widget/loading_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final UserModel userModel;
  String lastUpdated = '';
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  late Future<void> _initData;
  late Map<String, dynamic> details;
  late bool isUpdate;
  late String durationParking;
  late bool isStart;
  Location locationController = Location();
  late final List<PromotionMonthlyPassModel> promotionMonthlyPassModel;

  DateTime? expiredAt = DateTime.now();

  @override
  void initState() {
    super.initState();
    analyzeLocation();
    getLocation();
    analyzeParkingExpired();
    userModel = UserModel();
    _initData = _getUserDetails();
    promotionMonthlyPassModel = [];
    _getPromotionMonthlyPass();
  }

  Future<void> getLocation() async {
    PermissionStatus permissionGranted;

    permissionGranted = await locationController.hasPermission();

    if (permissionGranted == PermissionStatus.denied) {
      await CustomDialog.show(
        context,
        icon: Icons.location_on,
        dialogType: 2,
        description:
            'Our GPS detect you in Kuantan specifically in Jalan Woh Ah Jang. Please confirm if this is accurate or inaccurate.',
        btnOkText: 'Yes',
        btnOkOnPress: () async {
          permissionGranted = await locationController.requestPermission();
          await permission.Permission.notification.request();
          if (permissionGranted != PermissionStatus.granted) {
            return;
          } else {
            Navigator.pop(context);
          }
        },
        btnCancelText: 'No',
        btnCancelOnPress: () {
          Navigator.pop(context);
        },
      );
    }
  }

  Future<void> analyzeLocation() async {
    details = await SharedPreferencesHelper.getLocationDetails();
  }

  Future<void> analyzeParkingExpired() async {
    durationParking = await SharedPreferencesHelper.getParkingExpired();
    isStart = await SharedPreferencesHelper.getParkingExpiredStatus();

    setState(() {
      expiredAt = DateTime.parse(durationParking);
    });
  }

  Future<void> _getUserDetails() async {
    final data =
        await ProfileResources.getProfile(prefix: '/auth/user-profile');

    if (data != null && mounted) {
      setState(() {
        userModel.id = data['id'];
        userModel.email = data['email'];
        userModel.firstName = data['firstName'];
        userModel.secondName = data['secondName'];
        userModel.idNumber = data['idNumber'];
        userModel.phoneNumber = data['phoneNumber'];
        userModel.address1 = data['address1'];
        userModel.address2 = data['address2'];
        userModel.address3 = data['address3'];
        userModel.city = data['city'];
        userModel.state = data['state'];
        userModel.postcode = data['postcode'];

        if (data['wallet'] != null) {
          userModel.wallet = WalletModel.fromJson(data['wallet']);
        }

        if (data['plateNumbers'].isNotEmpty) {
          userModel.plateNumbers = (data['plateNumbers'] as List)
              .map((e) => PlateNumberModel.fromJson(e))
              .toList();
        }

        if (data['reserveBays'].isNotEmpty) {
          userModel.reserveBays = (data['reserveBays'] as List)
              .map((e) => ReserveBayModel.fromJson(e))
              .toList();
        }

        lastUpdated = DateFormat('d MMMM y HH:mm').format(DateTime.now());
      });
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyToken);
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoute.loginScreen, (context) => false);
  }

  Future<void> _getPromotionMonthlyPass() async {
    final data = await PromotionsResources.getPromotionMonthlyPass(
        prefix: '/promotion/public');

    if (data != null && mounted) {
      setState(() {
        promotionMonthlyPassModel.addAll(
          data
              .map<PromotionMonthlyPassModel>(
                  (item) => PromotionMonthlyPassModel(
                        id: item['id'],
                        title: item['title'],
                        description: item['description'],
                        type: item['type'],
                        rate: item['rate'],
                        date: item['date'],
                        expiredDate: item['expiredDate'],
                        image: item['image'],
                        timeUse: item['timeUse'],
                        createdAt: item['createdAt'],
                        updatedAt: item['updatedAt'],
                      ))
              .toList(),
        ); // Add new data
      });
    }
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        CustomDialog.show(
          context,
          title: AppLocalizations.of(context)!.exitApp,
          description: AppLocalizations.of(context)!.exitAppDesc,
          btnOkText: AppLocalizations.of(context)!.exit,
          btnCancelText: AppLocalizations.of(context)!.cancel,
          btnOkOnPress: () {
            exit(0);
          },
          btnCancelOnPress: () => Navigator.pop(context),
        );
        return Future.value(false);
      },
      child: FutureBuilder<void>(
        future: _initData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: LoadingDialog(),
            );
          } else if (snapshot.hasError) {
            Future.delayed(const Duration(milliseconds: 500), () async {
              await logout();
            });
            return const Scaffold(body: LoadingDialog());
          } else {
            return RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _getUserDetails,
              child: Scaffold(
                backgroundColor: kBackgroundColor,
                extendBodyBehindAppBar: true,
                appBar: _appBarBuilder(context),
                body: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Wrap Stack inside a Container or SizedBox with specific height
                      SizedBox(
                        height: MediaQuery.of(context).size.height *
                            0.48, // You can adjust this based on your layout
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            double screenHeight = constraints.maxHeight;
                            double screenWidth = constraints.maxWidth;

                            return Stack(
                              children: [
                                // Position the countdown at the top or any desired position
                                Positioned(
                                  top: screenHeight *
                                      0.0, // Adjust the top position based on screen size
                                  left: screenWidth *
                                      0.0, // Adjust left position if necessary
                                  right: screenWidth *
                                      0.0, // Adjust right position if necessary
                                  child: Visibility(
                                    visible: isStart,
                                    child: _clockingCountdown(
                                        context, countDownDuration),
                                  ),
                                ),
                                // Position the top widget
                                Positioned(
                                  top:
                                      0, // You can adjust this value based on screen height
                                  left: 0,
                                  right: 0,
                                  child: _topWidget(context, userModel),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      const SliderScreen(),
                      spaceVertical(height: 20.0),
                      ServiceScreen(
                        details: details,
                        userModel: userModel,
                        plateNumbers: userModel.plateNumbers,
                      ),
                      spaceVertical(height: 20.0),
                      NewsUpdateScreen(
                        promotionMonthlyPassModel: promotionMonthlyPassModel,
                      ),
                      spaceVertical(height: 20.0),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  PreferredSize _appBarBuilder(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100.0),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        child: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Color(details['color']),
          toolbarHeight: 100,
          leadingWidth: 250,
          leading: Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ScaleTap(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoute.profileScreen,
                        arguments: {
                          'userModel': userModel,
                          'locationDetail': details,
                        });
                  },
                  child: const CircleAvatar(
                    radius: 30,
                    child: Icon(
                      Icons.person,
                      size: 40,
                    ),
                  ),
                ),
                spaceHorizontal(width: 20.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.welcome,
                        style: textStyleNormal(
                          color:
                              details['color'] == 4294961979 ? kBlack : kWhite,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${userModel.firstName} ${userModel.secondName}',
                        style: textStyleNormal(
                          color:
                              details['color'] == 4294961979 ? kBlack : kWhite,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoute.notificationScreen,
                    arguments: {
                      'locationDetail': details,
                    },
                  );
                },
                icon: Icon(
                  Icons.notifications_outlined,
                  color: details['color'] == 4294961979 ? kBlack : kWhite,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topWidget(BuildContext context, UserModel userModel) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.37,
      decoration: BoxDecoration(
        color: Color(details['color']),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40.0),
          bottomRight: Radius.circular(40.0),
        ),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 30.0,
            right: 30.0,
            bottom: 20.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize:
                    MainAxisSize.min, // Shrink wrap the column vertically
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center vertically
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.availableBalance,
                    style: textStyleNormal(
                      color: details['color'] == 4294961979 ? kBlack : kWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        // ignore: unrelated_type_equality_checks
                        '${userModel.wallet?.amount == 0 ? 0.00 : double.parse(userModel.wallet!.amount!).toStringAsFixed(2)}',
                        style: textStyleNormal(
                          color:
                              details['color'] == 4294961979 ? kBlack : kWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: 34,
                        ),
                      ),
                      spaceHorizontal(width: 10.0),
                      ScaleTap(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoute.reloadScreen,
                              arguments: {
                                'locationDetail': details,
                                'userModel': userModel,
                              });
                          // Navigator.of(context).push(MaterialPageRoute(
                          //       builder: (context) => ReloadCreditScreen(
                          //           userProfile: userModel!)));
                        },
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor:
                              details['color'] == 4294961979 ? kBlack : kWhite,
                          child: Icon(
                            Icons.add,
                            color: Color(details['color']),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    Get.locale!.languageCode == 'ms'
                        ? '${AppLocalizations.of(context)!.updatedOn}\n$lastUpdated'
                        : '${AppLocalizations.of(context)!.updatedOn} $lastUpdated',
                    style: textStyleNormal(
                      color: details['color'] == 4294961979 ? kBlack : kWhite,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisSize:
                    MainAxisSize.min, // Shrink wrap the column vertically
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center vertically
                children: [
                  ScaleTap(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoute.stateScreen,
                        arguments: {
                          'locationDetail': details,
                        },
                      );
                    },
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        CircleAvatar(
                          backgroundColor: kWhite,
                          radius: 50,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image(
                              image: AssetImage(
                                details['logo'],
                              ),
                            ),
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor:
                              const Color.fromARGB(255, 212, 212, 212),
                          child: Icon(
                            Icons.change_circle,
                            color: Color(details['color']),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: Text(
                      details['location'],
                      style: textStyleNormal(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: details['color'] == 4294961979 ? kBlack : kWhite,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _clockingCountdown(BuildContext context, Duration countdownDuration) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.46,
      padding: const EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
        color: Color(details['color']).withOpacity(0.5),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40.0),
          bottomRight: Radius.circular(40.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${AppLocalizations.of(context)!.expiredDate}: ',
                style: textStyleNormal(
                  fontSize: 18,
                  color: details['color'] == 4294961979 ? kBlack : kWhite,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                DateFormat('dd-MM-yyyy HH:mm')
                    .format(expiredAt!.add(const Duration(hours: 8))),
                style: textStyleNormal(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: details['color'] == 4294961979 ? kBlack : kWhite),
              ), // Show loading while retrieving the time
            ],
          ),
          spaceVertical(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${AppLocalizations.of(context)!.parkingTimeRemaining}: ',
                style: textStyleNormal(
                  color: details['color'] == 4294961979 ? kBlack : kWhite,
                ),
              ),
              const SizedBox(height: 10),
              expiredAt != null
                  ? CountdownScreen(
                      details: details,
                      expiredAt: expiredAt!,
                    )
                  : const Text(
                      'Loading...'), // Show loading while retrieving the time
            ],
          ),
        ],
      ),
    );
  }
}
