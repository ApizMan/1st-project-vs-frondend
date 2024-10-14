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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SummonsScreen extends StatefulWidget {
  const SummonsScreen({super.key});

  @override
  State<SummonsScreen> createState() => _SummonsScreenState();
}

class _SummonsScreenState extends State<SummonsScreen> {
  late final SummonModel summonModel;
  late final CompoundModel compoundModel;
  List<SummonModel>? summonsList;
  late Future<void> _initData;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final TextEditingController _searchController = TextEditingController();
  // Use a Set to keep track of selected notices
  final Set<String> _selectedIds =
      <String>{}; // Change to String if you want to store other IDs like offenderIDNo or vehicleRegistrationNumber
  List<SummonModel> _selectedSummons =
      []; // Temporary list to store selected summons

  List<String> inputType = [
    'Offender ID No',
    'Notice No',
    'Plate Number',
  ];

  String _selectedInputType = 'Notice No'; // Default selected dropdown value

  @override
  void initState() {
    super.initState();
    compoundModel = CompoundModel();
    summonModel = SummonModel();
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
    final response = await CompoundResources.displayPrimaryCompound(
      prefix: '/compound/display',
    );

    try {
      // Parse the response to update the compound model
      compoundModel.actionCode = response['data']['actionCode'].toString();
      compoundModel.responseCode = response['data']['responseCode'].toString();
      compoundModel.responseMessage =
          response['data']['responseMessage'].toString();

      if (compoundModel.responseMessage == 'SUCCESS') {
        // Map the summonses data to SummonModel objects
        summonsList = (response['data']['summonses'] as List)
            .map((json) => SummonModel.fromJson(json))
            .toList();
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _onSearchChanged() async {
    String query = _searchController.text;

    if (query.isNotEmpty) {
      // Create the search parameters based on the selected dropdown value
      Map<String, dynamic> searchParams = {
        'OffenderIDNo': null,
        'NoticeNo': null,
        'VehicleRegistrationNumber': null,
      };

      if (_selectedInputType == 'Offender ID No') {
        searchParams['OffenderIDNo'] = query;
      } else if (_selectedInputType == 'Notice No') {
        searchParams['NoticeNo'] = query;
      } else if (_selectedInputType == 'Plate Number') {
        searchParams['VehicleRegistrationNumber'] = query;
      }

      final response = await CompoundResources.search(
        prefix: '/compound/search',
        body: jsonEncode(searchParams), // Send search parameters
      );

      try {
        // Parse the response to update the compound model
        compoundModel.actionCode = response['data']['actionCode'].toString();
        compoundModel.responseCode =
            response['data']['responseCode'].toString();
        compoundModel.responseMessage =
            response['data']['responseMessage'].toString();

        if (compoundModel.responseMessage == 'SUCCESS') {
          // Map the summonses data to SummonModel objects and display in the ListView
          setState(() {
            summonsList = (response['data']['summonses'] as List)
                .map((json) => SummonModel.fromJson(json))
                .toList();
          });
        } else {
          setState(() {
            summonsList = [];
          });
        }
      } catch (e) {
        print('Error: $e');
      }
    } else {
      // If the query is empty, reload the original summons list
      await _getSummons();
      setState(() {}); // Ensure the state is updated to reflect the changes
    }
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
                backgroundColor: Color(details['color']!),
                centerTitle: true,
                title: Text(
                  AppLocalizations.of(context)!.summons,
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
                          label: Text(AppLocalizations.of(context)!.search),
                          hintText: 'Enter Search Term',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              DropdownButton<String>(
                                value: _selectedInputType,
                                items: inputType.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedInputType = newValue!;
                                    _onSearchChanged(); // Trigger search when dropdown changes
                                  });
                                },
                              ),
                              spaceHorizontal(width: 10.0),
                              _searchController.text.isNotEmpty
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          _searchController.clear();
                                          _onSearchChanged(); // Trigger search changed to reload original list
                                        },
                                        child: const Icon(
                                          Icons.close,
                                          color: kRed,
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
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
                      spaceVertical(height: 10.0),
                      summonsList?.isNotEmpty ?? false
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: summonsList?.length ?? 0,
                              itemBuilder: (context, index) {
                                final notice = summonsList![index];
                                final isSelected = _selectedIds.contains(notice
                                    .noticeNo); // Change to your selected ID
                                return ScaleTap(
                                  onPressed: () {
                                    setState(() {
                                      // Toggle the selection state
                                      if (isSelected) {
                                        _selectedIds.remove(notice.noticeNo);
                                        _selectedSummons.remove(
                                            notice); // Remove from the temporary list
                                      } else {
                                        _selectedIds.add(notice.noticeNo!);
                                        _selectedSummons.add(
                                            notice); // Add to the temporary list
                                      }
                                    });
                                  },
                                  child: Card(
                                    color: isSelected
                                        ? Colors.blue.withOpacity(0.3)
                                        : kWhite, // Change background color when selected
                                    child: ListTile(
                                      title: Text(
                                        'Notice No: ${notice.noticeNo}',
                                        style: textStyleNormal(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          spaceVertical(height: 10.0),
                                          Text(
                                            'Vehicle No: ${notice.vehicleRegistrationNo}',
                                            style: textStyleNormal(),
                                          ),
                                          Text(
                                            'Offences Act: ${notice.offenceAct}',
                                            style: textStyleNormal(),
                                          ),
                                          Text(
                                            'Offences Date: ${notice.offenceDate}',
                                            style: textStyleNormal(),
                                          ),
                                          Text(
                                            'Amount: RM ${double.parse(notice.amount!).toStringAsFixed(2)}',
                                            style: textStyleNormal(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height *
                                      0.25),
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.thumb_up_alt_sharp,
                                      color: kGrey,
                                      size: 80,
                                    ),
                                    spaceVertical(height: 10.0),
                                    Text(
                                      'There no records of Compound.',
                                      style: textStyleNormal(
                                        color: kGrey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.all(20.0),
                child: PrimaryButton(
                  buttonWidth: 0.8,
                  borderRadius: 10.0,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoute.summonsPaymentScreen,
                      arguments: {
                        'locationDetail': details,
                        'userModel': userModel,
                        'selectedSummons':
                            _selectedSummons, // Pass the temporary list
                      },
                    );
                  },
                  label: Text(
                    AppLocalizations.of(context)!.pay,
                    style: textStyleNormal(
                      color: kWhite,
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
