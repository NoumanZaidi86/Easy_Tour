import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';

List<String> imageList = [
  'images/splash1.jpeg',
  'images/splash2.jpeg',
  'images/splash3.jpeg',
  'images/splash4.jpeg',
  'images/splash5.jpeg',
  'images/splash6.jpeg',
  'images/splash7.jpeg',
];

class ImageSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 150.0,
        autoPlay: true,
        viewportFraction: 1.0,
        enlargeCenterPage: false,
      ),
      items: imageList.map((imagePath) {
        return Builder(
          builder: (BuildContext context) {
            return SizedBox(
              width: double.infinity,
              child: ClipRRect(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.fill,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
