import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HealthNews extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HealthNewsState();
  }
}

class _HealthNewsState extends State<HealthNews> {
  final CarouselController _controller = CarouselController();
  final List<String> imgList = [
    'https://via.placeholder.com/600',
    'https://via.placeholder.com/600',
    'https://via.placeholder.com/600',
  ];
  final int indicatorCount = 3;
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Automatic Scrolling Carousel')),
      body: Stack(
        children: [
          CarouselSlider(
         
            items: imgList
                .map((item) => Container(

                      margin: EdgeInsets.all(5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        child: Image.network(
                          item,
                          fit: BoxFit.cover,
                          width: 1000.0,
                        ),
                      ),
                    ))
                .toList(),
            options: CarouselOptions(
            
            
              aspectRatio: 3/1.8,

              enlargeCenterPage: true,
              
              
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              onPageChanged: (index, reason) {
                _currentIndex.value = index;
              },
            ),
            carouselController: _controller,
          ),
          Positioned(
            bottom: 20.0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(indicatorCount, (indicatorIndex) {
                return ValueListenableBuilder<int>(
                  valueListenable: _currentIndex,
                  builder: (context, currentIndex, child) {
                    int activeIndex = currentIndex % imgList.length;
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: activeIndex == indicatorIndex
                            ? Color.fromRGBO(0, 0, 0, 0.9)
                            : Color.fromRGBO(0, 0, 0, 0.4),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
 