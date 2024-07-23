import 'package:fire_login/blocs/drcount/doctor_details_bloc.dart';
import 'package:fire_login/blocs/drcount/doctor_details_event.dart';
import 'package:fire_login/blocs/drcount/doctor_details_state.dart';
import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:fire_login/widgets/drdetail/round.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class UserCount extends StatelessWidget {
  final String doctorUid;

  UserCount({required this.doctorUid});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PatientCountBloc()..add(LoadPatientCount(doctorUid)),
      child: Column(
        children: [
          BlocBuilder<PatientCountBloc, PatientCountState>(
            builder: (context, state) {
              return Column(
                children: [
                  DetailsRound(
                    icon: Icon(
                      Icons.groups,
                      size: 30,
                      color: Colormanager.blueicon,
                    ),
                  ),
                  Text('${state.count}+',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colormanager.blueText),
                      )),
                  Text(
                    'Patients',
                    style: GoogleFonts.poppins(
                        fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
} 