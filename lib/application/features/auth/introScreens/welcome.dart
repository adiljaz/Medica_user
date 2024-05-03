import 'package:fire_login/application/features/auth/home/widgets/home.dart';
import 'package:fire_login/application/features/auth/introScreens/bloc/nextpage_bloc.dart';
import 'package:fire_login/application/features/auth/introScreens/second_intro.dart';
import 'package:fire_login/application/features/auth/introScreens/third_into.dart';
import 'package:fire_login/application/features/auth/introScreens/widgets/pageview_one.dart';
import 'package:fire_login/application/features/auth/views/login_view.dart';
import 'package:fire_login/colors/colormanager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// ignore: must_be_immutable
class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                PageView(
                  controller: controller,
                  onPageChanged: (index) {
                    // print(index);
                    if (index == 2) {
                      BlocProvider.of<NextpageBloc>(context)
                          .add(CheckNextClickEvent(pageTwo: true));
                    } else {
                      BlocProvider.of<NextpageBloc>(context)
                          .add(CheckNextClickEvent(pageTwo: false));
                    }
                  },
                  children: [
                    WelcomePageView(controller: controller),
                    SecondIntro(),
                    ThirdIntro(),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(onTap: () {
                controller.jumpToPage(2);
              }, child: BlocBuilder<NextpageBloc, NextpageState>(
                builder: (context, state) {
                  print(state);
                  if (state is OnclickDone) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => LoginPage()),
                            (route) => false);
                      },
                      child: Text('Done',
                          style: TextStyle(
                            color: Colormanager.titleText,
                          )),
                    );
                  }
                  return Text('Skip',
                      style: TextStyle(
                        color: Colormanager.titleText,
                      ));
                },
              )),
              SmoothPageIndicator(
                controller: controller,
                count: 3,
                effect: WormEffect(
                  dotWidth: 10,
                  dotHeight: 10,
                ),
              ),
              GestureDetector(
                onTap: () {
                  controller.nextPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeIn);
                },
                child: Text(
                  'Next',
                  style: TextStyle(color: Colormanager.titleText),
                ),
              ),
            ],
          ),
          SizedBox(
            height: mediaQuery.size.height * 0.02,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: Container(
              width: mediaQuery.size.width * 0.8,
              height: mediaQuery.size.height * 0.053,
              child: Center(
                  child: Text(
                'Get Started',
                style: TextStyle(
                    color: Colormanager.whiteText, fontWeight: FontWeight.bold),
              )),
              decoration: BoxDecoration(
                  color: Colormanager.blueContainer,
                  borderRadius: BorderRadius.circular(5)),
            ),
          ),
          SizedBox(
            height: mediaQuery.size.height * 0.03,
          )
        ],
      ),
    );
  }
}
