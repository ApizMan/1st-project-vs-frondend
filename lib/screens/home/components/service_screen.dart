import 'package:flutter/material.dart';
import 'package:project/constant.dart';
import 'package:project/models/models.dart';
import 'package:project/resources/resources.dart';
import 'package:project/routes/route_manager.dart';
import 'package:project/theme.dart';
import 'package:project/widget/service_card.dart';

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
  late Future<void> _initDataPBT;

  @override
  void initState() {
    _initDataPBT = _getPBT();
    pbtModel = [];
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Our Service',
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
                children: [
                  FutureBuilder(
                      future: _initDataPBT,
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
                          title: 'Parking',
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
                    title: 'Summons',
                  ),
                  ServiceCard(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoute.reserveBayScreen,
                          arguments: {
                            'locationDetail': widget.details,
                          });
                    },
                    image: reserveBayImage,
                    title: 'Reserve Bay',
                  ),
                ],
              ),
              spaceVertical(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        },
                      );
                    },
                    image: monthlyPassImage,
                    title: 'Monthly Pass',
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
                    title: 'Transport Info',
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
