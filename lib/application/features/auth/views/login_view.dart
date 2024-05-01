import 'package:fire_login/application/features/auth/auth_bloc/bloc/auth_bloc.dart';
import 'package:fire_login/application/features/auth/home/widgets/home.dart';
import 'package:fire_login/application/features/auth/views/Googlebloc/google_auth_bloc.dart';
import 'package:fire_login/application/features/auth/views/forgot.dart';
import 'package:fire_login/application/features/auth/views/user_signup.dart';
import 'package:fire_login/application/features/auth/views/widgets/signin.dart';
import 'package:fire_login/application/features/auth/views/widgets/textformfield.dart';
import 'package:fire_login/colors/colormanager.dart';
import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController _usernameController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _emailController = TextEditingController();

    final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

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
      },
      builder: (context, state) {
        if (state is Authenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const Home()),
                (route) => false);
          });
        }
        return Scaffold(
            body: BlocListener<GoogleAuthBloc, GoogleAuthState>(
          listener: (context, state) {
            if (state is GoogleAuthsuccess) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (_) => Home()),

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
                          textStyle: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 40)),
                    ),

                    SizedBox(
                      height: mediaQuery.size.width * 0.04,
                    ),
                    // emial

                    CutomTextFormField(
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
                      icons: Icon(
                        Icons.email,
                        size: 27,
                        color: Colormanager.iconscolor,
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    //password

                    CutomTextFormField(
                      // ignore: body_might_complete_normally_nullable
                      value: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your password';
                        }
                      },
                      controller: _passwordController,
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

                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
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
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8),
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
                                  Center(
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
                        Text(
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
              )),
            ),
          ),
        ));
      },
    );
  }
}
