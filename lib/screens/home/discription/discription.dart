import 'package:fire_login/blocs/department/bloc/department_bloc.dart';
import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:fire_login/widgets/dropdown/dropdown.dart';
import 'package:fire_login/widgets/textformfield/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class Description extends StatelessWidget {
  Description({super.key});

  TextEditingController _fullnameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _problemController = TextEditingController();

  List<String> genderItems = ['Male', 'female'];

  Object? get departmenetselectedvalue => null;
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery =MediaQuery.of(context); 
    return Scaffold(
      backgroundColor: Colormanager.scaffold,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios_sharp)),
        elevation: 0,
        backgroundColor: Colormanager.scaffold,
        centerTitle: true,
        title: Text(
          'Book Appointment',
          style: GoogleFonts.dongle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                'Full Name',
                style: GoogleFonts.dongle(
                    fontWeight: FontWeight.bold, fontSize: 28),
              ),
            ),
            CustomTextFormField(
                fonrmtype: 'full name',
                formColor: Colormanager.wittextformfield,
                Textcolor: Colormanager.grayText,
                controller: _fullnameController,
                value: (value) {}),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                'Gender',
                style: GoogleFonts.dongle(
                    fontWeight: FontWeight.bold, fontSize: 28),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: BlocBuilder<GenderBloc, GenderState>(
                builder: (context, state) {
                  if (state is GenderSelectedState) {
                    var departmenetselectedvalue = state.selectedGender;
                  }

                  return Drobdown(
                    onChange: (value) {
                      if (value != null) {
                        BlocProvider.of<GenderBloc>(context)
                            .add(GenderSelected(selecteGender: value));
                      }
                      print(departmenetselectedvalue);
                    },
                    genderItems: genderItems,
                    typeText: 'Select your Department',
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                'Your Age ',
                style: GoogleFonts.dongle(
                    fontWeight: FontWeight.bold, fontSize: 28),
              ),
            ),
            CustomTextFormField(
                fonrmtype: 'your age',
                formColor: Colormanager.wittextformfield,
                Textcolor: Colormanager.grayText,
                controller: _ageController,
                value: (value) {}),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                'Write Your Problem',
                style: GoogleFonts.dongle(
                    fontWeight: FontWeight.bold, fontSize: 28),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: TextFormField(
                maxLines: 5,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {},
                controller: _problemController,
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                    color: Colormanager.grayText,
                    fontWeight: FontWeight.w400,
                  ),
                  fillColor: Colormanager.wittextformfield,
                  filled: true,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 14.0, horizontal: 10.0),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Theme.of(context)
                          .primaryColor, // Use theme color for focused border
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 220, 219, 219),
                      width: 1,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    // Define border style for validation error
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.red, // Red border for validation error
                      width: 1,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    // Define border style for focused validation error
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color:
                          Colors.red, // Red border for focused validation error
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: mediaQuery.size.width*0.4,),
            Center(
                child: Container(
                
                  height: mediaQuery.size.height*0.07  ,
                  decoration: BoxDecoration(color: Colormanager.blueContainer,borderRadius: BorderRadius.circular(50)),
                  width: mediaQuery.size.width*0.9,
                  child: Center(child: Text('Next',style:GoogleFonts.dongle(fontWeight: FontWeight.bold ,fontSize: 25,color: Colormanager.whiteText),)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
