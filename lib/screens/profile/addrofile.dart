import 'package:fire_login/blocs/dateofbirth/bloc/date_of_birth_bloc.dart';
import 'package:fire_login/blocs/dateofbirth/bloc/date_of_birth_event.dart';
import 'package:fire_login/blocs/dateofbirth/bloc/date_of_birth_state.dart';
import 'package:fire_login/blocs/gender/bloc/gender_bloc.dart';
import 'package:fire_login/blocs/gender/bloc/gender_event.dart';
import 'package:fire_login/blocs/gender/bloc/gender_state.dart';
import 'package:fire_login/blocs/profile/AddUser/add_user_bloc.dart';
import 'package:fire_login/blocs/profile/ImageAdding/image_adding_bloc.dart';
import 'package:fire_login/screens/bottomnav/home.dart';
import 'package:fire_login/screens/profile/location/location.dart';
import 'package:fire_login/screens/profile/widget/dob.dart';
import 'package:fire_login/screens/profile/widget/userimage.dart';
import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:fire_login/widgets/dropdown/dropdown.dart';
import 'package:fire_login/widgets/profiletexfield/profiletetfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class AddProfile extends StatelessWidget {
  AddProfile({super.key});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _datofbirthController = TextEditingController();
  final TextEditingController _gendercontroller = TextEditingController();
  final TextEditingController _locationcontroler = TextEditingController();

  final TextEditingController _mbobilecontroller = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String imageUrl = '';
    FocusNode myFocusNode = FocusNode();

    String? genderselectedvalue;
  
  final List<String> genderItems = [
    'Male',
    'Female',
  ];

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaquery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colormanager.scaffold,
      appBar: AppBar(
        backgroundColor: Colormanager.scaffold,
        title: const Text(
          'Add Profile',
          style: TextStyle(),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<ImageAddingBloc, ImageAddingState>(
        builder: (context, state) {
          if (state is ImageSelectedState) {
            imageUrl = state.imageUrl; // Update imageUrl when state changes
          }

          return BlocConsumer<AddUserBloc, AddUserState>( 
            listener: (context, state) {
              if (state is AddUserLOadingState) {
                // Show loading indicator
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Loading...')),
                  
                );
                 _clearForm();
              } else if (state is AddUserSuccesState) {
                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('User added successfully!')),
                );
                _clearForm();

         
                // Clear form and navigate away after success
                
                Navigator.of(context).pop();
              } else if (state is AddUserErrorState) {
                // Show error message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${state.errorMessage}')),
                );
              }
            },
            builder: (context, state) {
              return Form(
                key: _formkey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            Userimage(onFileChange: (changingImage) {
                              BlocProvider.of<ImageAddingBloc>(context)
                                  .add(ImageChangedEvent(changingImage));
                            }),
                            Positioned(
                                top: 120,
                                left: 145,
                                child: Icon(
                                  Icons.add_to_photos,
                                  size: 40,
                                ))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: mediaquery.size.height * 0.02,
                      ),
                      ProfileTextFormField(
                          keyboardtype: TextInputType.name,
                          fonrmtype: 'Name ',
                          formColor: Colormanager.wittextformfield,
                          textcolor: Colormanager.grayText,
                          controller: _nameController,
                          value: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Add Name ';
                            }

                            return null;
                          }),
                      SizedBox(
                        height: mediaquery.size.height * 0.02,
                      ),
                      ProfileTextFormField(
                          keyboardtype: TextInputType.number,
                          fonrmtype: 'Age ',
                          formColor: Colormanager.wittextformfield,
                          textcolor: Colormanager.grayText,
                          controller: _ageController,
                          value: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Add age ';
                            }

                            return null;
                          }),
                      SizedBox(
                        height: mediaquery.size.height * 0.02,
                      ),
                      SizedBox(
                            height: mediaquery.size.height * 0.07,
                            child:
                                BlocBuilder<DateOfBirthBloc, DateOfBirthState>(
                              builder: (context, state) {
                                if (state is DateOfBirthSelectedState) {
                                  _datofbirthController.text =
                                      state.dateOfBirth;
                                }

                                return DateofBirth(
                                    value: (value) {
                                      if (value!.isEmpty) {
                                        return 'Add Date of Birth';
                                      }
                                      return null;
                                    },
                                    controller: _datofbirthController,
                                    labeltext: 'Date of birth',
                                    onTap: () {
                                      _selectDate(context);

                                      FocusScope.of(context)
                                          .requestFocus(myFocusNode);
                                    });
                              },
                            ),
                          ), 
                      SizedBox(
                        height: mediaquery.size.height * 0.02,
                      ),

                           Padding(
                            padding:
                                const EdgeInsets.only(left: 20, right: 20),
                            child: BlocBuilder<GenderBloc, GenderState>(
                              builder: (context, state) {
                                if (state is GenderSelectedState) {
                                  genderselectedvalue = state.selectedGender;
                                }
                                return Drobdown( 
                                  onChange: (value) {
                                    if (value != null) {
                                      BlocProvider.of<GenderBloc>(context)
                                          .add(GenderSelected( genderselectedvalue.toString()));
                                    }
                                  },
                                  genderItems: genderItems,
                                  typeText: 'Select Your Gender',
                                );
                              },
                            )),




                      SizedBox(
                        height: mediaquery.size.height * 0.02,
                      ),
                      ProfileTextFormField(
                          keyboardtype: TextInputType.number,
                          fonrmtype: 'Mobile Number ',
                          formColor: Colormanager.wittextformfield,
                          textcolor: Colormanager.grayText,
                          controller: _mbobilecontroller,
                          value: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Mobile Number ';
                            }

                            return null;
                          }),
                      SizedBox(
                        height: mediaquery.size.height * 0.02,
                      ),
                        Location(locationcontroler: _locationcontroler),
                      SizedBox(
                        height: mediaquery.size.height * 0.02,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (imageUrl.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Failed to upload image. Please try again.'),
                              ),
                            );
                          }

                          if (_formkey.currentState!.validate() &&
                              imageUrl.isNotEmpty) {
                            Navigator.of(context).pop();
                            FocusScope.of(context).unfocus();
                            final name = _nameController.text;
                            final dob = _datofbirthController.text;
                            final age = int.parse(_ageController.text);
                            final gender = _gendercontroller.text;
                            final location = _locationcontroler.text;
                            final mbobilecontroller =
                                int.parse(_mbobilecontroller.text);
                            if (imageUrl.isNotEmpty) {
                              BlocProvider.of<AddUserBloc>(context)
                                  .add(AddUserClick(
                                name: name,
                                age: age,
                                dob: dob,
                                imageUrl: imageUrl,
                                gender: gender,
                                location: location,
                                mobile: mbobilecontroller,
                                
                              ));
                            }
                              _clearForm(); 
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => Bottomnav()),
                                (route) => false);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colormanager.blueContainer,
                              borderRadius: BorderRadius.circular(10)),
                          height: mediaquery.size.width * 0.14,
                          width: mediaquery.size.height * 0.4,
                          child: Center(
                            child: Text(
                              'Save',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colormanager.whiteText),
                            ),
                          ),
                        ),
                        
                      ),

                      SizedBox(
                        height: mediaquery.size.height*0.02,
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _clearForm() {
    
    _nameController.clear();
    _ageController.clear();
    _datofbirthController.clear();
    _gendercontroller.clear();
    _locationcontroler.clear();
    imageUrl = '';
  }

 Future<void> _selectDate(BuildContext context) async {
  DateTime? _picked = await showDatePicker(
    initialDate: DateTime.now(),
    context: context,
    firstDate: DateTime(2000),
    lastDate: DateTime.now(),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          primaryColor: Colormanager.blueContainer,
          colorScheme: ColorScheme.light(
            primary: Colormanager.blueContainer,
            onPrimary: Colors.white,
            onSurface: const Color.fromARGB(255, 223, 223, 223),
          ),
          dialogBackgroundColor: const Color.fromARGB(255, 174, 174, 174),
          textTheme: TextTheme(),
          datePickerTheme: DatePickerThemeData(
            backgroundColor: Colors.black,
            headerBackgroundColor: Colors.grey,
            headerForegroundColor: Colors.white,
          ),
        ),
        child: child!,
      );
    },
  );
  if (_picked != null) {
    // Accessing the DateOfBirthBloc using BlocProvider.of
    BlocProvider.of<DateOfBirthBloc>(context).add(DateOfBirthSelected(_picked));
  }
}  
} 
