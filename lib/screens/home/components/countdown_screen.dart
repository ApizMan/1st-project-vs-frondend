import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:project/app/helpers/shared_preferences.dart';
import 'package:project/constant.dart';
import 'package:project/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CountdownScreen extends StatefulWidget {
  final DateTime expiredAt;
  final Map<String, dynamic> details;
  const CountdownScreen(
      {super.key, required this.details, required this.expiredAt});

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  Timer? _timer;
  Duration remainingTime = const Duration();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  // ignore: unused_field

  @override
  void initState() {
    super.initState();
    initializeNotifications();
    startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
            '@mipmap/ic_launcher'); // Ensure you have an icon resource
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void startCountdown() {
    _timer?.cancel(); // Cancel any existing timer
    DateTime now = DateTime.now();

    // Calculate the difference between expiredAt and the current time
    remainingTime = widget.expiredAt.difference(now);

    if (remainingTime.isNegative) {
      remainingTime = Duration.zero; // Parking already expired
    }

    // Start the countdown timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime > Duration.zero) {
          // Decrease the remaining time by 1 second
          remainingTime = remainingTime - const Duration(seconds: 1);

          SharedPreferencesHelper.setParkingDuration(
              duration: formatDuration(remainingTime));

          // Trigger notification when there are 5 minutes left
          if (remainingTime.inMinutes <= 5 &&
              remainingTime.inSeconds >= 270 &&
              remainingTime.inSeconds < 300) {
            _showNotification();
          }
        } else {
          SharedPreferencesHelper.setParkingExpired(isStart: false);
          _timer?.cancel(); // Stop the timer when the countdown finishes
        }
      });
    });
  }

  void _showNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'countdown_channel', // This should match the channel ID in MainActivity.kt
      'Countdown Notifications',
      channelDescription: 'Notification when there are 5 minutes remaining',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Parking Time',
      'You have 5 minutes left!',
      notificationDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.expiredAt.isAfter(DateTime.now()) ? true : false,
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.46,
        padding: const EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
          color: Color(widget.details['color']).withOpacity(0.5),
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
                    color:
                        widget.details['color'] == 4294961979 ? kBlack : kWhite,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  DateFormat('dd-MM-yyyy HH:mm')
                      .format(widget.expiredAt.add(const Duration(hours: 8))),
                  style: textStyleNormal(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: widget.details['color'] == 4294961979
                          ? kBlack
                          : kWhite),
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
                    color:
                        widget.details['color'] == 4294961979 ? kBlack : kWhite,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  formatDuration(remainingTime),
                  style: textStyleNormal(
                    color:
                        widget.details['color'] == 4294961979 ? kBlack : kWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ), // Show loading while retrieving the time
              ],
            ),
          ],
        ),
      ),
    );
  }
}
