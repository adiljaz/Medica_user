import 'package:fire_login/blocs/Forgot/forgot_password_bloc.dart';
import 'package:fire_login/widgets/textformfield/textformfield.dart';
import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers

    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Form(
        key: _formkey,
        child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
          listener: (context, state) {
            if (state is ForgotpasswordDone) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Center(
                  child: Text(
                    'Check your email successfully sended',
                    style: TextStyle(color: Colormanager.whiteText),
                  ),
                ),
                margin: EdgeInsets.all(10),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Color.fromARGB(255, 0, 0, 0),
              ));
              // Optionally, navigate away after success
              Navigator.of(context).pop();
            }

            if (state is ForgotpasswordError) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Center(
                  child: Text(
                    'Enter valid Email !',
                    style: TextStyle(
                        color: Colormanager.whiteText,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                margin: EdgeInsets.all(10),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Color.fromARGB(255, 255, 17, 0),
              ));
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: SizedBox(
                height: mediaQuery.size.height,
                width: mediaQuery.size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Text(
                      'Forgot Password',
                      style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 32)),
                    ),
                    SizedBox(height: mediaQuery.size.height * 0.03),
                    Text(
                      '''Enter your Email and we will send you a 
                password reset link !''',
                      style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colormanager.grayText)),
                    ),
                    SizedBox(height: mediaQuery.size.height * 0.03),
                    CustomTextFormField(
                      // ignore: body_might_complete_normally_nullable
                      value: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your email';
                        }
                      },
                      controller: _emailController,
                      icons: const Icon(
                        Icons.email,
                        color: Colormanager.iconscolor,
                      ),
                      Textcolor: Colormanager.grayText,
                      fonrmtype: 'Enter email',
                      formColor: Colormanager.whiteContainer,
                    ),
                    const Spacer(),
                    Image.asset('assets/images/forgot.png'),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: GestureDetector(
                        onTap: () {
                          if (_formkey.currentState!.validate()) {
                             FocusScope.of(context).unfocus(); 
                            BlocProvider.of<ForgotPasswordBloc>(context)
                                .add(ForgotClickEvent(_emailController.text));
                          }
                        },
                        child: Container(
                          height: mediaQuery.size.height * 0.06,
                          width: mediaQuery.size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colormanager.blueContainer),
                          child: const Center(
                              child: Text(
                            'Continue',
                            style: TextStyle(
                                color: Colormanager.whiteText,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          )),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.size.height * 0.03,
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
