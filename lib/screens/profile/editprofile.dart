import 'package:fire_login/blocs/profile/ImageAdding/image_adding_bloc.dart';
import 'package:fire_login/screens/profile/firebase.dart';
import 'package:fire_login/screens/profile/widget/editimageclic.dart';
import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:fire_login/widgets/profiletexfield/profiletetfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class EditProfile extends StatefulWidget {
  final String name;
  final int age;
  final int dob;
  final String gender;
  final String location;
  final String image;
  final String uid;
  final int mobile;

  EditProfile(
      {super.key,
      required this.name,
      required this.age,
      required this.dob,
      required this.gender,
      required this.location,
      required this.image,
      required this.uid,
      required this.mobile});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late String updateimagepath;

  @override
  void initState() {
    _nameController.text = widget.name;
    _ageController.text = widget.age.toString();
    _datofbirthController.text = widget.dob.toString();
    _gendercontroller.text = widget.gender;
    _mobilecontroler.text = widget.mobile.toString();
    _locationcontroler.text = widget.location;

    updateimagepath = widget.image;

    super.initState();
  }

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _ageController = TextEditingController();

  final TextEditingController _datofbirthController = TextEditingController();

  final TextEditingController _gendercontroller = TextEditingController();

  final TextEditingController _locationcontroler = TextEditingController();

  final TextEditingController _mobilecontroler = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaquery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colormanager.scaffold,
      appBar: AppBar(
        backgroundColor: Colormanager.scaffold,
        title: const Text(
          'Edit Profile',
          style: TextStyle(),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formkey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Stack(
                  children: [
                    EditUserimage(
                      networkImageUrl: widget.image,
                      onFileChange: (changeimage) {
                        setState(() {
                          updateimagepath = changeimage;
                        });
                      },
                    ),
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
                      return 'Add Name ';
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
                      return 'Add Name ';
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
                  controller: _mobilecontroler,
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
                  fonrmtype: 'Mobile ',
                  formColor: Colormanager.wittextformfield,
                  textcolor: Colormanager.grayText,
                  controller: _gendercontroller,
                  value: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Add Mobile number';
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
                      return 'Add Name ';
                    }

                    return null;
                  }),
              SizedBox(
                height: mediaquery.size.height * 0.03,
              ),
              GestureDetector(
                onTap: () async {
                  if (_formkey.currentState!.validate()) {
                    FocusScope.of(context).unfocus();
                    final name = _nameController.text;
                    final age = int.parse(_ageController.text);
                    final dob = int.parse(_datofbirthController.text);
                    final gender = _gendercontroller.text;
                    final mobile = int.parse(_mobilecontroler.text);
                    final location = _locationcontroler.text;

                    final data = {
                      'name': name,
                      'age': age,
                      'dob': dob,
                      'gender': gender,
                      'mobile': mobile,
                      'location': location,
                      'imageUrl': updateimagepath,
                      'uid':widget.uid,
                    };

                    editStudentClicked(widget.uid, data);
                  }
                  Navigator.of(context).pop();
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
      ),
    );
  }
}
