import 'package:fire_login/blocs/dateofbirth/bloc/date_of_birth_bloc.dart';
import 'package:fire_login/blocs/dateofbirth/bloc/date_of_birth_event.dart';
import 'package:fire_login/blocs/dateofbirth/bloc/date_of_birth_state.dart';
import 'package:fire_login/blocs/edit_user/edit_user_bloc.dart';
import 'package:fire_login/blocs/gender/bloc/gender_bloc.dart';
import 'package:fire_login/blocs/gender/bloc/gender_event.dart';
import 'package:fire_login/blocs/gender/bloc/gender_state.dart';
import 'package:fire_login/screens/profile/location/location.dart';
import 'package:fire_login/screens/profile/widget/dob.dart';
import 'package:fire_login/screens/profile/widget/editimageclic.dart';
import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:fire_login/widgets/dropdown/dropdown.dart';
import 'package:fire_login/widgets/profiletexfield/profiletetfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfile extends StatefulWidget {
  final String name;
  final int age;
  final String dob;
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
 final List<String> genderItems = [
    'Male',
    'Female',
  ];  

    String? genderselectedvalue;

  @override
  void initState() {
    _nameController.text = widget.name;
    _ageController.text = widget.age.toString();
    _dateOfBirthController.text = widget.dob.toString();
    _mobileController.text = widget.mobile.toString();
    _locationController.text = widget.location;

    updateImagePath = widget.image;
    genderselectedvalue = widget.gender;

    super.initState();
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();

  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  

  FocusNode myFocusNode = FocusNode();

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
                SizedBox(
                  height: mediaQuery.size.height * 0.07,
                  child: BlocBuilder<DateOfBirthBloc, DateOfBirthState>(
                    builder: (context, state) {
                      if (state is DateOfBirthSelectedState) {
                        _dateOfBirthController.text = state.dateOfBirth;
                      }

                      return DateofBirth(
                          value: (value) {
                            if (value!.isEmpty) {
                              return 'Add Date of Birth';
                            }
                            return null;
                          },
                          controller: _dateOfBirthController,
                          labeltext: 'Date of birth',
                          onTap: () {
                            _selectDate();

                            FocusScope.of(context).requestFocus(myFocusNode);
                          });
                    },
                  ),
                ),
                SizedBox(
                  height: mediaQuery.size.height * 0.02,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: BlocBuilder<GenderBloc, GenderState>(
                    builder: (context, state) {
                      if (state is GenderSelectedState) {
                        genderselectedvalue = state.selectedGender;
                      }
                      return Drobdown( 
                        initialvalue: genderselectedvalue,
                        
                        onChange: (value) {
                          if (value != null) {
                            BlocProvider.of<GenderBloc>(context)
                                .add(GenderSelected(value));
                          }
                        },
                        genderItems: genderItems,
                        typeText: 'Select Your Gender',
                      );
                    },
                  ),
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
                Location(locationcontroler: _locationController),
                SizedBox(
                  height: mediaQuery.size.height * 0.03,
                ),
                GestureDetector(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      FocusScope.of(context).unfocus();
                      final name = _nameController.text;
                      final age = int.parse(_ageController.text);
                      final dob = _dateOfBirthController.text;

                      final mobile = int.parse(_mobileController.text);
                      final location = _locationController.text;

                      if (updateImagePath.isNotEmpty) {
                        final data = {
                          'name': name,
                          'age': age,
                          'dob': dob,
                          'gender': genderselectedvalue,
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
                            gender: genderselectedvalue!,
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

  Future<void> _selectDate() async {
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
      context.read<DateOfBirthBloc>().add(DateOfBirthSelected(_picked));
    }
  }
}
