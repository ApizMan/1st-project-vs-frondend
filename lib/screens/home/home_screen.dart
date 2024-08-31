import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:project/constant.dart';
import 'package:project/models/models.dart';
import 'package:project/resources/resources.dart';
import 'package:project/screens/screens.dart';
import 'package:project/theme.dart';
import 'package:project/widget/loading_dialog.dart';

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

  @override
  void initState() {
    super.initState();
    userModel = UserModel();
    _initData = _getUserDetails();
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

        if (data['plateNumbers'] != null) {
          userModel.plateNumbers = (data['plateNumbers'] as List)
              .map((e) => PlateNumberModel.fromJson(e))
              .toList();
        }

        if (data['reserveBays'] != null) {
          userModel.reserveBays = (data['reserveBays'] as List)
              .map((e) => ReserveBayModel.fromJson(e))
              .toList();
        }

        lastUpdated = DateFormat('d MMMM y HH:mm').format(DateTime.now());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: LoadingDialog(),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
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
                    Stack(
                      children: [
                        _clockingCountdown(context),
                        _topWidget(context, userModel),
                      ],
                    ),
                    spaceVertical(height: 20.0),
                    const SliderScreen(),
                    spaceVertical(height: 20.0),
                    ServiceScreen(
                      userModel: userModel,
                      plateNumbers: userModel.plateNumbers,
                    ),
                    spaceVertical(height: 20.0),
                    const NewsUpdateScreen(),
                    spaceVertical(height: 20.0),
                  ],
                ),
              ),
            ),
          );
        }
      },
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
          backgroundColor: kPrimaryColor,
          toolbarHeight: 100,
          leadingWidth: 200,
          leading: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 30,
                child: Icon(
                  Icons.person,
                  size: 40,
                ),
              ),
              spaceHorizontal(width: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome',
                    style: textStyleNormal(
                      color: kWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${userModel.firstName} ${userModel.secondName}',
                    style: textStyleNormal(
                      color: kWhite,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: kWhite,
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
      height: MediaQuery.of(context).size.height * 0.32,
      decoration: const BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.only(
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
            bottom: 40.0,
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
                    'Available Balance',
                    style: textStyleNormal(
                      color: kWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'RM ${userModel.wallet?.amount?.toDouble().toStringAsFixed(2) ?? '0.00'}',
                        style: textStyleNormal(
                          color: kWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: 42,
                        ),
                      ),
                      spaceHorizontal(width: 10.0),
                      ScaleTap(
                        onPressed: () {},
                        child: const CircleAvatar(
                          radius: 18,
                          backgroundColor: kWhite,
                          child: Icon(
                            Icons.add,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Updated on $lastUpdated',
                    style: textStyleNormal(
                      color: kWhite,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const Column(
                mainAxisSize:
                    MainAxisSize.min, // Shrink wrap the column vertically
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center vertically
                children: [
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      CircleAvatar(
                        backgroundColor: kWhite,
                        radius: 50,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Image(
                            image: AssetImage(
                              kuantanLogo,
                            ),
                          ),
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 212, 212, 212),
                        child: Icon(
                          Icons.change_circle,
                          color: kPrimaryColor,
                        ),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _clockingCountdown(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.37,
      padding: const EdgeInsets.only(bottom: 10.0),
      decoration: const BoxDecoration(
        color: kSecondaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40.0),
          bottomRight: Radius.circular(40.0),
        ),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Text(
          'Parking Time Remaining: ',
          style: textStyleNormal(
            color: kBlack,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
