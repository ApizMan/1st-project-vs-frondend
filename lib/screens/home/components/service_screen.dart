import 'package:flutter/material.dart';
import 'package:project/constant.dart';
import 'package:project/models/models.dart';
import 'package:project/resources/resources.dart';
import 'package:project/routes/route_manager.dart';
import 'package:project/theme.dart';
import 'package:project/widget/service_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ServiceScreen extends StatefulWidget {
  final UserModel? userModel;
  final List<PlateNumberModel>? plateNumbers;
  final Map<String, dynamic> details;
  const ServiceScreen({
    super.key,
    this.userModel,
    this.plateNumbers,
    required this.details,
  });

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  late final List<PBTModel> pbtModel;
  late final List<PromotionMonthlyPassModel> promotionMonthlyPassModel;
  late final List<PromotionMonthlyPassHistoryModel>
      promotionMonthlyPassHistoryModel;
  late Future<void> _initData;

  @override
  void initState() {
    _initData = _initDataCombined(); // Initialize both data fetching methods
    pbtModel = [];
    promotionMonthlyPassModel = [];
    _getPromotionMonthlyPassHistory();
    promotionMonthlyPassHistoryModel = [];
    super.initState();
  }

  Future<void> _initDataCombined() async {
    await Future.wait([_getPBT(), _getPromotionMonthlyPass()]);
  }

  Future<void> _getPBT() async {
    final data = await PbtResources.getPBT(prefix: '/pbt/');

    if (data != null && mounted) {
      setState(() {
        pbtModel.addAll(
          data
              .map<PBTModel>((item) => PBTModel(
                    id: item['id'],
                    name: item['name'],
                    description: item['description'],
                  ))
              .toList(),
        ); // Add new data
      });
    }
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

  Future<void> _getPromotionMonthlyPassHistory() async {
    final data = await PromotionsResources.getPromotionHistory(
        prefix: '/monthlyPass/all/promotion');

    if (data != null && mounted) {
      setState(() {
        promotionMonthlyPassHistoryModel.addAll(
          data
              .map<PromotionMonthlyPassHistoryModel>(
                  (item) => PromotionMonthlyPassHistoryModel(
                        id: item['id'],
                        promotionId: item['promotionId'],
                        userId: item['userId'],
                        timeUse: item['timeUse'],
                        createdAt: item['createdAt'],
                        updatedAt: item['updatedAt'],
                      ))
              .toList(),
        ); // Add new data
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.ourService,
            style: textStyleNormal(
              color: kBlack,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          spaceVertical(height: 20.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder(
                      future: _initData,
                      builder: (context, snapshot) {
                        return ServiceCard(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRoute.parkingScreen,
                              arguments: {
                                'locationDetail': widget.details,
                                'userModel': widget.userModel,
                                'plateNumbers': widget.plateNumbers ?? [],
                                'pbtModel': pbtModel,
                              },
                            );
                          },
                          image: parkingImage,
                          title: AppLocalizations.of(context)!.parking2,
                        );
                      }),
                  ServiceCard(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoute.summonsScreen,
                          arguments: {
                            'locationDetail': widget.details,
                            'userModel': widget.userModel,
                          });
                    },
                    image: summonImage,
                    title: AppLocalizations.of(context)!.summons,
                  ),
                  ServiceCard(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoute.reserveBayScreen,
                          arguments: {
                            'locationDetail': widget.details,
                          });
                    },
                    image: reserveBayImage,
                    title: AppLocalizations.of(context)!.reserveBays,
                  ),
                ],
              ),
              spaceVertical(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ServiceCard(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoute.monthlyPassScreen,
                        arguments: {
                          'locationDetail': widget.details,
                          'userModel': widget.userModel,
                          'plateNumbers': widget.plateNumbers ?? [],
                          'pbtModel': pbtModel,
                          'promotions': promotionMonthlyPassModel,
                          'history': promotionMonthlyPassHistoryModel,
                        },
                      );
                    },
                    image: monthlyPassImage,
                    title: AppLocalizations.of(context)!.monthlyPass,
                  ),
                  ServiceCard(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoute.transportInfoScreen,
                        arguments: {
                          'locationDetail': widget.details,
                        },
                      );
                    },
                    image: transportInfoImage,
                    title: AppLocalizations.of(context)!.transportInfo2,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
