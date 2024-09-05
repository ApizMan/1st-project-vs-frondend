import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:project/constant.dart';
import 'package:project/models/models.dart';
import 'package:project/resources/resources.dart';
import 'package:project/routes/route_manager.dart';
import 'package:project/theme.dart';
import 'package:project/widget/loading_dialog.dart';
import 'package:project/widget/primary_button.dart';

class SummonsScreen extends StatefulWidget {
  const SummonsScreen({super.key});

  @override
  State<SummonsScreen> createState() => _SummonsScreenState();
}

class _SummonsScreenState extends State<SummonsScreen> {
  List<CompoundModel> noticeList = []; // List to hold all Notice objects
  List<CompoundModel> filteredNoticeList =
      []; // List to hold filtered Notice objects
  late Future<void> _initData;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final TextEditingController _searchController = TextEditingController();
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _initData = _getSummons();
    _searchController.addListener(_onSearchChanged); // Add search listener
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _getSummons() async {
    final response = await CompoundResources.createReserveBay(
      prefix:
          'http://43.252.37.175/ParkingWebService/HandheldService.svc/SearchNotice',
      body: jsonEncode({}),
    );

    if (response['Notices'].isNotEmpty && mounted) {
      setState(() {
        noticeList = (response['Notices'] as List)
            .map((json) => CompoundModel.fromJson(json))
            .toList();
        filteredNoticeList = noticeList; // Initially display all notices
      });
    }
  }

  void _onSearchChanged() {
    setState(() {
      // Filter the list based on search input
      String query = _searchController.text.toLowerCase();
      filteredNoticeList = noticeList.where((notice) {
        return notice.noticeNo!.toLowerCase().contains(query) ||
            notice.vehicleNo!.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    Map<String, dynamic> details =
        arguments['locationDetail'] as Map<String, dynamic>;
    UserModel? userModel = arguments['userModel'] as UserModel?;
    return FutureBuilder<void>(
        future: _initData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: LoadingDialog(),
            );
          } else {
            return RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _getSummons,
              child: Scaffold(
                backgroundColor: kBackgroundColor,
                appBar: AppBar(
                  toolbarHeight: 100,
                  foregroundColor:
                      details['color'] == 4294961979 ? kBlack : kWhite,
                  backgroundColor: Color(details['color']),
                  centerTitle: true,
                  title: Text(
                    'Summons',
                    style: textStyleNormal(
                      fontSize: 26,
                      color: details['color'] == 4294961979 ? kBlack : kWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                body: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            label: const Text('Search'),
                            hintText: 'Enter Summons Name',
                            hintStyle: const TextStyle(
                              color: Colors.black26,
                            ),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? GestureDetector(
                                    onTap: () {
                                      _searchController.clear();
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      color: kRed,
                                    ),
                                  )
                                : const SizedBox(),
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
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredNoticeList.length,
                          itemBuilder: (context, index) {
                            final notice = filteredNoticeList[index];
                            return ScaleTap(
                              onPressed: () {
                                setState(() {
                                  _selectedIndex =
                                      index; // Mark this item as selected
                                });
                              },
                              child: Card(
                                child: ListTile(
                                  title: Text('Notice No: ${notice.noticeNo}'),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Vehicle No: ${notice.vehicleNo}'),
                                      Text(
                                          'Vehicle Make/Model: ${notice.vehicleMakeModel}'),
                                      Text(
                                          'Vehicle Type: ${notice.vehicleType}'),
                                      Text(
                                          'Compound Amount: ${notice.compoundAmount}'),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 100),
                        // if (filteredNoticeList.isNotEmpty)
                        PrimaryButton(
                          buttonWidth: 0.8,
                          borderRadius: 10.0,
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRoute.summonsPaymentScreen,
                              arguments: {
                                'locationDetail': details,
                                'summonsModel':
                                    // filteredNoticeList[_selectedIndex!],
                                    noticeList,
                                'index': _selectedIndex,
                                'userModel': userModel,
                              },
                            );
                          },
                          label: Text(
                            'Pay',
                            style: textStyleNormal(
                              color: kWhite,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        });
  }
}
