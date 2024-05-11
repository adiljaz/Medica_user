import 'package:fire_login/blocs/edit_user/edit_user_bloc.dart';
import 'package:fire_login/screens/profile/widget/editimageclic.dart';
import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:fire_login/widgets/profiletexfield/profiletetfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      {Key? key,
      required this.name,
      required this.age,
      required this.dob,
      required this.gender,
      required this.location,
      required this.image,
      required this.uid,
      required this.mobile})
      : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late String updateImagePath;

  @override
  void initState() {
    _nameController.text = widget.name;
    _ageController.text = widget.age.toString();
    _dateOfBirthController.text = widget.dob.toString();
    _genderController.text = widget.gender;
    _mobileController.text = widget.mobile.toString();
    _locationController.text = widget.location;

    updateImagePath = widget.image;

    super.initState();
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

      

    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colormanager.scaffold,
      appBar: AppBar(
        backgroundColor: Colormanager.scaffold,
        title: const Text('Edit Profile'),
        centerTitle: true,
      ),
      body: BlocListener<EditUserBloc, EditUserState>(
        listener: (context, state) {
          if (state is EditUserSucces) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Profile edit saved')),
            );
          }
        },
        child: Form(
          key: _formKey,
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
                            updateImagePath = changeimage;
                          });
                        },
                      ),
                      Positioned(
                        top: 120,
                        left: 145,
                        child: Icon(
                          Icons.add_to_photos,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: mediaQuery.size.height * 0.02,
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
                  },
                ),
                SizedBox(
                  height: mediaQuery.size.height * 0.02,
                ),
                ProfileTextFormField(
                  keyboardtype: TextInputType.number,
                  fonrmtype: 'Age ',
                  formColor: Colormanager.wittextformfield,
                  textcolor: Colormanager.grayText,
                  controller: _ageController,
                  value: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Add Age ';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: mediaQuery.size.height * 0.02,
                ),
                ProfileTextFormField(
                  keyboardtype: TextInputType.number,
                  fonrmtype: 'Date of Birth',
                  formColor: Colormanager.wittextformfield,
                  textcolor: Colormanager.grayText,
                  controller: _dateOfBirthController,
                  value: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Add Date of Birth ';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: mediaQuery.size.height * 0.02,
                ),
                ProfileTextFormField(
                  keyboardtype: TextInputType.text,
                  fonrmtype: 'Gender ',
                  formColor: Colormanager.wittextformfield,
                  textcolor: Colormanager.grayText,
                  controller: _genderController,
                  value: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Add Gender ';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: mediaQuery.size.height * 0.02,
                ),
                ProfileTextFormField(
                  keyboardtype: TextInputType.number,
                  fonrmtype: 'Mobile ',
                  formColor: Colormanager.wittextformfield,
                  textcolor: Colormanager.grayText,
                  controller: _mobileController,
                  value: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Add Mobile ';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: mediaQuery.size.height * 0.02,
                ),
                ProfileTextFormField(
                  keyboardtype: TextInputType.text,
                  fonrmtype: 'Location',
                  formColor: Colormanager.wittextformfield,
                  textcolor: Colormanager.grayText,
                  controller: _locationController,
                  suficon: const Icon(
                    Icons.location_on,
                    color: Color.fromARGB(255, 211, 14, 0),
                  ),
                  value: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Add Location ';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: mediaQuery.size.height * 0.03,
                ),
                GestureDetector(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      FocusScope.of(context).unfocus();
                      final name = _nameController.text;
                      final age = int.parse(_ageController.text);
                      final dob = int.parse(_dateOfBirthController.text);
                      final gender = _genderController.text;
                      final mobile = int.parse(_mobileController.text);
                      final location = _locationController.text;

                      if (updateImagePath.isNotEmpty) {
                        final data = {
                          'name': name,
                          'age': age,
                          'dob': dob,
                          'gender': gender,
                          'mobile': mobile,
                          'location': location,
                          'imageUrl': updateImagePath,
                       
                        };

                        BlocProvider.of<EditUserBloc>(context).add(
                          EditUserClick(
                            name: name,
                            age: age,
                            location: location,
                            dob: dob,
                            mobile: mobile,
                            gender: gender,
                            imaage: updateImagePath,
                            uid: widget.uid,
                            data: data,
                          ),
                        );
                      }
                    }
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colormanager.blueContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: mediaQuery.size.width * 0.14,
                    width: mediaQuery.size.height * 0.4,
                    child: Center(
                      child: Text(
                        'Save',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colormanager.whiteText,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
