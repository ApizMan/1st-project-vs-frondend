import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:project/constant.dart';
import 'package:project/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewsUpdateScreen extends StatefulWidget {
  const NewsUpdateScreen({super.key});

  @override
  State<NewsUpdateScreen> createState() => _NewsUpdateScreenState();
}

class _NewsUpdateScreenState extends State<NewsUpdateScreen> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  final List<String> myNews = [
    newsImage1,
    newsImage2,
    newsImage3,
  ];
  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = myNews
        .map((item) => ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(item, fit: BoxFit.contain, width: 1000.0),
          ),
        ))
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.newsUpdate,
            style: textStyleNormal(
              color: kBlack,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          spaceVertical(height: 20.0),
          Container(
            height: 250, // Set a fixed height or adjust as needed
            decoration: BoxDecoration(
              color: kWhite,
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
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
                  children: myNews.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _controller.animateToPage(entry.key),
                      child: Container(
                        width: 12.0,
                        height: 12.0,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (Theme.of(context).brightness ==
                                      Brightness.dark
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
          )
        ],
      ),
    );
  }
}
