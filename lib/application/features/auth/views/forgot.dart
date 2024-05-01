import 'package:fire_login/application/features/auth/views/widgets/textformfield.dart';
import 'package:fire_login/colors/colormanager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    TextEditingController _emailController =TextEditingController();
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: SizedBox(
           height: mediaQuery.size.height,
        width: mediaQuery.size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Spacer(), 
              Text('Forgot Password',style: GoogleFonts.poppins(textStyle:TextStyle(fontWeight: FontWeight.bold,fontSize: 32)  ),),
             SizedBox(height: mediaQuery.size.height*0.03),   
              Text('''Enter your Email and we will send you a 
                   password reset link !''',style: GoogleFonts.poppins(textStyle:TextStyle(fontWeight: FontWeight.w400,color: Colormanager.grayText )),),
          
                    SizedBox(height: mediaQuery.size.height*0.03),
             
              CutomTextFormField(
                // ignore: body_might_complete_normally_nullable
                value: (value){
                  if(value==null|| value.isEmpty){
                    return 'Enter your email';
                  }
                },
                controller:_emailController ,
                icons: Icon(Icons.email,color: Colormanager.iconscolor,),
                Textcolor: Colormanager.grayText,
                fonrmtype: 'Enter email',
                formColor: Colormanager.whiteContainer,
              ),
               Spacer(), 
              Image.asset('assets/images/forgot.png'),
              Spacer(),
              
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: GestureDetector(
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: mediaQuery.size.height * 0.06,
                    width: mediaQuery.size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colormanager.blueContainer),
                    child: Center(
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
             SizedBox(height: mediaQuery.size.height*0.03,)
            ],
          ),
        ),
      ),
    );
  }
}
