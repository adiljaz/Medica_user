import 'package:fire_login/blocs/profile/AddUser/add_user_bloc.dart';
import 'package:fire_login/blocs/profile/ImageAdding/image_adding_bloc.dart';
import 'package:fire_login/screens/bottomnav/home.dart';
import 'package:fire_login/screens/profile/widget/userimage.dart';
import 'package:fire_login/utils/colors/colormanager.dart';
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
              } else if (state is AddUserSuccesState) {
                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('User added successfully!')),
                );
                // Clear form and navigate away after success
                _clearForm();
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
                      ProfileTextFormField(
                             keyboardtype: TextInputType.number,
                          fonrmtype: 'Date of Birth',
                          formColor: Colormanager.wittextformfield,
                          textcolor: Colormanager.grayText,
                          controller: _datofbirthController,
                          value: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Add Date of Birth ';
                            }

                            return null;
                          }),
                      SizedBox(
                        height: mediaquery.size.height * 0.02,
                      ),
                      ProfileTextFormField(
                             keyboardtype: TextInputType.text,
                          fonrmtype: 'Gender ',
                          formColor: Colormanager.wittextformfield,
                          textcolor: Colormanager.grayText,
                          controller: _gendercontroller,
                          value: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Add Gender';
                            }

                            return null;
                          }),
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
                      ProfileTextFormField(
                              keyboardtype: TextInputType.text,
                          fonrmtype: 'Location',
                          formColor: Colormanager.wittextformfield,
                          textcolor: Colormanager.grayText,
                          controller: _locationcontroler,
                          suficon: const Icon(
                            Icons.location_on,
                            color: Color.fromARGB(255, 211, 14, 0),
                          ),
                          value: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Add Location';
                            }

                            return null;
                          }),
                      SizedBox(
                        height: mediaquery.size.height * 0.1,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_formkey.currentState!.validate()) {
                            Navigator.of(context).pop();
                            FocusScope.of(context).unfocus();
                            final name = _nameController.text;
                            final dob = int.parse(_datofbirthController.text);
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
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => Bottomnav()),
                                  (route) => false);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Failed to upload image. Please try again.'),
                                ),
                              );
                            }
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
}
