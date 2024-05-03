import 'package:fire_login/application/features/auth/auth_bloc/bloc/auth_bloc.dart';
import 'package:fire_login/application/features/auth/home/widgets/home.dart';
import 'package:fire_login/application/features/auth/models/user_model.dart';
import 'package:fire_login/application/features/auth/views/Googlebloc/google_auth_bloc.dart';
import 'package:fire_login/application/features/auth/views/login_view.dart';
import 'package:fire_login/application/features/auth/views/widgets/textformfield.dart';
import 'package:fire_login/colors/colormanager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authbloc = BlocProvider.of<AuthBloc>(context);

    MediaQueryData mediaQuery = MediaQuery.of(context);

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
                    fontWeight: FontWeight.w400,
                    color: Color.fromARGB(
                      255,
                      255,
                      255,
                      255,
                    ),
                  ),
                ),
              ),
              backgroundColor: Color.fromARGB(255, 0, 0, 0),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is Authenticated) {
          FocusScope.of(context).unfocus(); 
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Home()),
                (route) => false);
          });
        }

        return Scaffold(
            body: Container(
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
                    Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.cover,
                      height: 320,
                    ),
                    Text(
                      "Create New Account",
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25)),
                    ),

                    // emial

                    SizedBox(
                      height: mediaQuery.size.width * 0.04,
                    ),

                    CutomTextFormField(
                      // ignore: body_might_complete_normally_nullable
                      value: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your username';
                        }
                      },
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
                      height: mediaQuery.size.width * 0.04,
                    ),

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
                      height: mediaQuery.size.width * 0.04,
                    ),

                    //password

                    CutomTextFormField(
                      value: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your password ';
                        }
                        return null;
                      },
                      controller: _passwordController,
                      Textcolor: Colormanager.grayText,
                      fonrmtype: 'Enter password',
                      formColor: Colormanager.whiteContainer,
                      icons: Icon(
                        FontAwesomeIcons.lock,
                        size: 20,
                        color: Colormanager.iconscolor,
                      ),
                      suficon: Icon(
                        Icons.remove_red_eye,
                        color: Colormanager.blackIcon,
                      ),
                    ),

                    SizedBox(
                      height: mediaQuery.size.width * 0.04,
                    ),

                    // reginster button

                    GestureDetector(
                      onTap: () {
                        if (_formkey.currentState!.validate()) {
                          
                          UserModel user = UserModel(
                            email: _emailController.text,
                            password: _passwordController.text.trim(),
                            userName: _usernameController.text.trim(),
                          );
                          authbloc.add(SignupEvent(user: user));
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Container(
                          height: mediaQuery.size.height * 0.06,
                          width: mediaQuery.size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colormanager.blueContainer),
                          child: Center(
                              child: Text(
                            'Sign up',
                            style: TextStyle(
                                color: Colormanager.whiteText,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          )),
                        ),
                      ),
                    ),

                    // GestureDetector(
                    //     onTap: () {

                    //         print('navigationg-----------------');
                    //       UserModel user = UserModel(
                    //         email: _emailController.text,
                    //         password: _passwordController.text,
                    //         userName: _usernameController.text,
                    //       );

                    //       authbloc.add(SignupEvent(user: user));
                    //     },
                    //     child: Signin(
                    //       mediaQuery: mediaQuery,
                    //       buttontype: 'Sign up',
                    //     )),

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
                                builder: (context) => LoginPage()));
                          },
                          child: Text(
                            "Sign in",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colormanager.titleText),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
      },
    );
  }
}
