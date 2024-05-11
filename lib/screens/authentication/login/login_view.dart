import 'dart:developer';

import 'package:fire_login/blocs/auth/auth_bloc.dart';
import 'package:fire_login/screens/bottomnav/home.dart';
import 'package:fire_login/blocs/Google/google_auth_bloc.dart';
import 'package:fire_login/screens/authentication/ForgotPassword/forgot.dart';
import 'package:fire_login/screens/authentication/signup/user_signup.dart';
import 'package:fire_login/screens/profile/addrofile.dart';
import 'package:fire_login/widgets/signin/signin.dart';
import 'package:fire_login/widgets/textformfield/textformfield.dart';
import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    final authblocc = BlocProvider.of<AuthBloc>(context);

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthenticatedError) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              margin: EdgeInsets.all(5),
              behavior: SnackBarBehavior.floating,
              content: Center(
                child: Text(
                  'Enter correct email and password',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(
                        255,
                        255,
                        255,
                        255,
                      )),
                ),
              ),
              backgroundColor: Color.fromARGB(255, 0, 0, 0),
            ),
          );
        }
        if(state is UseralreadyExisting){
          log("user already exist");
        }
      },
      builder: (context, state) {
        if (state is Authenticated) {
          FocusScope.of(context).unfocus();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => Bottomnav()),
                (route) => false);
          });
        }
        return Scaffold(
            body: BlocListener<GoogleAuthBloc, GoogleAuthState>(
          listener: (context, state) {

            if (state is GoogleAuthsuccess) {

               if (state is UseralreadyExisting) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => Bottomnav()),
                    (route) => false);
              });
            }






              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => Bottomnav()),
                    (route) => false);
              });
            }
          },
          child: Container(
            // decoration: BoxDecoration(
            //     image: DecorationImage(
            //         image: AssetImage(
            //           'assets/images/background.jpg',
            //         ),
            //         fit: BoxFit.cover)),
            height: double.infinity,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: SingleChildScrollView(
                  child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    SizedBox(
                      height: mediaQuery.size.width * 0.1,
                    ),
                    Image.asset('assets/images/sign_in.png'),

                    Text(
                      "Let's you in",
                      style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 40)),
                    ),

                    SizedBox(
                      height: mediaQuery.size.width * 0.04,
                    ),
                    // emial

                    CustomTextFormField(
                      // ignore: body_might_complete_normally_nullable
                      value: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your email';
                        }
                      },
                      controller: _emailController,
                      Textcolor: Colormanager.grayText,
                      fonrmtype: 'Enter email',
                      formColor: Colormanager.whiteContainer,
                      icons: const Icon(
                        Icons.email,
                        size: 27,
                        color: Colormanager.iconscolor,
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    //password

                    CustomTextFormField(
                      // ignore: body_might_complete_normally_nullable
                      value: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your password';
                        }
                      },
                      controller: _passwordController,
                      suficon: const Icon(
                        Icons.remove_red_eye,
                        color: Colormanager.blackIcon,
                      ),
                      Textcolor: Colormanager.grayText,
                      fonrmtype: 'Enter password',
                      formColor: Colormanager.whiteContainer,
                      icons: const Icon(
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
                      child: const Padding(
                        padding: EdgeInsets.only(right: 25),
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

                    GestureDetector(
                      onTap: () {
                        if (_formkey.currentState!.validate()) {
                          authblocc.add(LoginEvent(
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim()));
                        }
                      },
                      child: Signin(
                        mediaQuery: mediaQuery,
                        buttontype: 'Sign in',
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.size.width * 0.06,
                    ),

                    const Padding(
                      padding: EdgeInsets.only(left: 10, right: 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
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
                      child: GestureDetector(
                        onTap: () {
                          context.read<GoogleAuthBloc>().add(SigninEvent());

                          // signingwith Google
                        },
                        child: BlocBuilder<GoogleAuthBloc, GoogleAuthState>(
                          builder: (context, state) {
                            if (state is GoogleAuthPendingn) {
                              Stack(
                                children: [
                                  Container(
                                    height: mediaQuery.size.height * 0.06,
                                    width: mediaQuery.size.width,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colormanager.whiteContainer,
                                        border: Border.all(
                                            width: 0.5,
                                            color: Colormanager.iconscolor)),
                                    child: Row(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(left: 8),
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
                                        const Center(
                                            child: Text(
                                          'Sign in with Google',
                                          style: TextStyle(
                                              color: Colormanager.blackText,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15),
                                        )),
                                        const Spacer(),
                                      ],
                                    ),
                                  ),
                                  const Center(
                                      child: CircularProgressIndicator(
                                    color: Colormanager.blueContainer,
                                  )),
                                ],
                              );
                            }

                            return Container(
                              height: mediaQuery.size.height * 0.06,
                              width: mediaQuery.size.width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colormanager.whiteContainer,
                                  border: Border.all(
                                      width: 0.5,
                                      color: Colormanager.iconscolor)),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 8),
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
                                  const Center(
                                      child: Text(
                                    'Sign in with Google',
                                    style: TextStyle(
                                        color: Colormanager.blackText,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15),
                                  )),
                                  const Spacer(),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    SizedBox(
                      height: mediaQuery.size.width * 0.03,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Dont't have an account ? ",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SignUp()));
                            },
                            child: const Text(
                              "Sign up",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colormanager.titleText),
                            )),
                      ],
                    )
                  ],
                ),
              )),
            ),
          ),
        ));
      },
    );
  }
}
