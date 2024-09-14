import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:project/app/helpers/shared_preferences.dart';
import 'package:project/constant.dart';
import 'package:project/routes/route_manager.dart';

class SliderScreen extends StatefulWidget {
  const SliderScreen({Key? key}) : super(key: key);

  @override
  _SliderScreenState createState() => _SliderScreenState();
}

class _SliderScreenState extends State<SliderScreen> {
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

  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = imgList.asMap().entries.map((item) {
      final index = item.key;
      final image = item.value;

      // Helper method to get the color based on index
      int _getColorForIndex(int index) {
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

      return ScaleTap(
        onPressed: () async {
          // Only handle the tapped item
          await SharedPreferencesHelper.saveLocationDetail(
            location: imgName[index],
            state: imgState[index],
            logo: imgList[index],
            color: _getColorForIndex(index),
          );

          final details = await SharedPreferencesHelper.getLocationDetails();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                details['location'],
              ),
            ),
          );

          Future.delayed(
            const Duration(milliseconds: 700),
            () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoute.homeScreen,
                (route) => false,
              );
            },
          );
        },
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
              color: kWhite.withOpacity(0.7),
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(image, fit: BoxFit.contain, width: 1000.0),
              ),
            ),
          ),
        ),
      );
    }).toList();

    return SizedBox(
      height: 200, // Set a fixed height or adjust as needed
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: CarouselSlider(
                items: imageSliders,
                carouselController: _controller,
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 2.0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imgList.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => _controller.animateToPage(entry.key),
                  child: Container(
                    width: 12.0,
                    height: 12.0,
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black)
                          .withOpacity(_current == entry.key ? 0.9 : 0.4),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
