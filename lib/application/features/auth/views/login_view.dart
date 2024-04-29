import 'package:fire_login/application/features/auth/views/forgot.dart';
import 'package:fire_login/application/features/auth/views/user_signup.dart';
import 'package:fire_login/application/features/auth/views/widgets/signin.dart';
import 'package:fire_login/application/features/auth/views/widgets/textformfield.dart';
import 'package:fire_login/colors/colormanager.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {

    TextEditingController  _usernameController =TextEditingController();
    TextEditingController  _passwordcontroller =TextEditingController();

    


    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
        body: SingleChildScrollView(
      child: SizedBox(
        // decoration: BoxDecoration(
        //     image: DecorationImage(
        //         image: AssetImage(
        //           'assets/images/background.jpg',
        //         ),
        //         fit: BoxFit.cover)),
        height: mediaQuery.size.height,
        width: mediaQuery.size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: mediaQuery.size.width * 0.1,
              ),
              Image.asset('assets/images/sign_in.png'),

              Text(
                "Let's you in",
                style: GoogleFonts.poppins(
                    textStyle:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 40)),
              ),

              SizedBox(
                height: mediaQuery.size.width * 0.04,
              ),
              // emial

              CutomTextFormField(
                controller: _usernameController,
                Textcolor: Colormanager.grayText,
                fonrmtype: 'Enter username',
                formColor: Colormanager.whiteContainer,
                icons: Icon(
                  Icons.account_circle,
                  size: 27,
                  color: Colormanager.iconscolor,
                ),
              ),

              SizedBox(
                height: 10,
              ),

              //password

              CutomTextFormField(
                controller: _passwordcontroller,
                suficon: Icon(
                  Icons.remove_red_eye,
                  color: Colormanager.blackIcon,
                ),
                Textcolor: Colormanager.grayText,
                fonrmtype: 'Enter password',
                formColor: Colormanager.whiteContainer,
                icons: Icon(
                  FontAwesomeIcons.lock,
                  size: 20,
                  color: Colormanager.iconscolor,
                ),
              ),

              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ForgotPassword()));
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 25),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                          color: Colormanager.titleText,
                          fontWeight: FontWeight.w600,
                          fontSize: 13),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: mediaQuery.size.width * 0.05,
              ),

              Signin(mediaQuery: mediaQuery),
              SizedBox(
                height: mediaQuery.size.width * 0.06,
              ),

              Padding(
                padding: const EdgeInsets.only(left: 10, right: 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'or continue with',
                        style: TextStyle(
                            color: Colormanager.grayText,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Expanded(
                      child: Divider(),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: mediaQuery.size.width * 0.05,
              ),

              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Container(
                  height: mediaQuery.size.height * 0.06,
                  width: mediaQuery.size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colormanager.whiteContainer,
                      border: Border.all(
                          width: 0.5, color: Colormanager.iconscolor)),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Image(
                          image: AssetImage(
                            'assets/images/googleLogo.png',
                          ),
                          fit: BoxFit.cover,
                          height: 35,
                        ),
                      ),
                      SizedBox(
                        width: mediaQuery.size.width * 0.14,
                      ),
                      Center(
                          child: Text(
                        'Sign in with Google',
                        style: TextStyle(
                            color: Colormanager.blackText,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      )),
                      Spacer(),
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: mediaQuery.size.width * 0.03,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Dont't have an account ? ",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => SignUp()));
                      },
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colormanager.titleText),
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
