import 'package:flutter/material.dart';
import 'package:project/constant.dart';
import 'package:project/models/models.dart';
import 'package:project/routes/route_manager.dart';
import 'package:project/theme.dart';
import 'package:project/widget/service_card.dart';

class ServiceScreen extends StatefulWidget {
  final UserModel? userModel;
  final List<PlateNumberModel>? plateNumbers;
  const ServiceScreen({
    super.key,
    this.userModel,
    this.plateNumbers,
  });

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
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
                  ServiceCard(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoute.parkingScreen,
                        arguments: {
                          'userModel': widget.userModel,
                          'plateNumbers': widget.plateNumbers,
                        },
                      );
                    },
                    image: parkingImage,
                    title: 'Parking',
                  ),
                  ServiceCard(
                    onPressed: () {},
                    image: summonImage,
                    title: 'Summons',
                  ),
                  ServiceCard(
                    onPressed: () {},
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
                    onPressed: () {},
                    image: monthlyPassImage,
                    title: 'Monthly Pass',
                  ),
                  ServiceCard(
                    onPressed: () {},
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
