
import 'package:fire_login/blocs/intro/nextpage_bloc.dart';
import 'package:fire_login/screens/introScreens/second_intro.dart';
import 'package:fire_login/screens/introScreens/third_into.dart';
import 'package:fire_login/widgets/introwidgets/pageview_one.dart';
import 'package:fire_login/screens/authentication/login/login_view.dart';
import 'package:fire_login/utils/colors/colormanager.dart';
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
                    const SecondIntro(),
                    const ThirdIntro(),
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
                      child: const Text('Done',
                          style: TextStyle(
                            color: Colormanager.titleText,
                          )),
                    );
                  }
                  return const Text('Skip',
                      style: TextStyle(
                        color: Colormanager.titleText,
                      ));
                },
              )),
              SmoothPageIndicator(
                controller: controller,
                count: 3,
                effect: const WormEffect(
                  dotWidth: 10,
                  dotHeight: 10,
                ),
              ),
              GestureDetector(
                onTap: () {
                  controller.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeIn);
                },
                child: const Text(
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
              decoration: BoxDecoration(
                  color: Colormanager.blueContainer,
                  borderRadius: BorderRadius.circular(5)),
              child: const Center(
                  child: Text(
                'Get Started',
                style: TextStyle(
                    color: Colormanager.whiteText, fontWeight: FontWeight.bold),
              )),
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
