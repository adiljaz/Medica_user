
import 'package:fire_login/blocs/location/location_bloc.dart';
import 'package:fire_login/blocs/location/location_event.dart';
import 'package:fire_login/blocs/location/location_state.dart';
import 'package:fire_login/screens/profile/location/widget/profiletextformfield.dart';
import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class Location extends StatelessWidget {
  const Location({
    super.key,
    required TextEditingController locationcontroler,
  }) : _locationcontroler = locationcontroler;

  final TextEditingController _locationcontroler;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationBlocBloc, LocationBlocState>(
      builder: (context, state) {
        if (state is LocationLoading) {
          return Center(
              child: CircularProgressIndicator());
        }
    
        if (state is LocationLoaded) {
          _locationcontroler.text = state.address;
    
          return ProfileTextFormField(
              keyboardtype: TextInputType.text,
              fonrmtype: 'Location',
              formColor: Colormanager.whiteContainer,
              textcolor: Colormanager.grayText,
              controller: _locationcontroler,
              suficon: GestureDetector(
                onTap: () {
                  BlocProvider.of<LocationBlocBloc>(
                          context)
                      .add(RequestCurrentPosition());
                },
                child: Icon(
                  Icons.location_on,
                  color: Color.fromARGB(255, 211, 14, 0),
                ),
              ),
              value: (value) {
                if (value == null || value.isEmpty) {
                  return 'Add Location';
                }
    
                return null;
              });
        } else if (state is LocationError) {
          print(state.message);
          return Center(child: Text(state.message));
        }
    
        return ProfileTextFormField(
            keyboardtype: TextInputType.text,
            fonrmtype: 'Location',
            formColor: Colormanager.whiteContainer,
            textcolor: Colormanager.grayText,
            controller: _locationcontroler,
            suficon: GestureDetector(
              onTap: () {
                BlocProvider.of<LocationBlocBloc>(context)
                    .add(RequestCurrentPosition());
              },
              child: Icon(
                Icons.location_on,
                color: Color.fromARGB(255, 211, 14, 0),
              ),
            ),
            value: (value) {
              if (value == null || value.isEmpty) {
                return 'Add Location';
              }
    
              return null;
            });
      },
    );
  }
}





