import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_login/blocs/bottomnav/landing_state_bloc.dart';
import 'package:fire_login/blocs/calendar/bloc/calendar_bloc.dart';
import 'package:fire_login/blocs/calendar/bloc/calendar_event.dart';
import 'package:fire_login/blocs/calendar/bloc/calendar_state.dart';
import 'package:fire_login/blocs/department/bloc/department_bloc.dart';
import 'package:fire_login/screens/appoinement/appoinement.dart';
import 'package:fire_login/screens/bottomnav/home.dart';
import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:fire_login/widgets/dropdown/dropdown.dart';
import 'package:fire_login/widgets/textformfield/textformfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:slide_to_act/slide_to_act.dart';

// ignore: must_be_immutable
class PayNow extends StatefulWidget {
  PayNow(
      {super.key,
      required this.fees,
      required this.selectedDay,
      required this.selectedTimeSlot,
      required this.formtime,
      required this.totime,
      required this.uid});

  int fees;

  final DateTime selectedDay;
  final DateTime selectedTimeSlot;
  final String formtime;
  final String totime;
  final String uid;

  @override
  State<PayNow> createState() => _PayNowState();
}

class _PayNowState extends State<PayNow> {
  TextEditingController _fullnameController = TextEditingController();

  TextEditingController _ageController = TextEditingController();

  TextEditingController _problemController = TextEditingController();

  List<String> genderItems = ['Male', 'female'];

  Object? get departmenetselectedvalue => null;

  final Razorpay _razorpay = Razorpay();

  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void openCheckout(int amount) async {
    int fees = widget.fees * 100;

    var options = {
      'key': 'rzp_test_5CIkvFaK1dDgsG', // Replace with your actual Razorpay key
      'amount': fees,
      'name': 'Your Company Name',
      'prefill': {
        'contact': '1234567891',
        'email': 'example@example.com',
      },
      'external': {
        'wallets': ['paytm'],
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error opening Razorpay checkout: $e');
      Fluttertoast.showToast(
          msg: 'Failed to open payment gateway',
          toastLength: Toast.LENGTH_LONG);
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    context.read<CalendarBloc>().add(
          SaveBooking(
            selectedDay: widget.selectedDay,
            selectedTimeSlot: widget.selectedTimeSlot,
            fromTime: widget.formtime,
            toTime: widget.totime,
            uid: widget.uid,
          ),
        );

    Navigator.of(context).push(
        PageTransition(child: Bottomnav(), type: PageTransitionType.fade));
    context.read<LandingStateBloc>().add(TabChangeEvent(tabindex: 1));

    Fluttertoast.showToast(
        backgroundColor: Colors.green,
        msg: 'Payment successful with ID: ${response.paymentId}',
        toastLength: Toast.LENGTH_LONG);
  }

  void handlePaymentError(PaymentFailureResponse response) {
    Navigator.of(context).pop();
    try {
      Fluttertoast.showToast(
          msg: 'Payment failed with message: ${response.message}',
          toastLength: Toast.LENGTH_LONG);
    } catch (e) {
      debugPrint('Error handling payment failure: $e');
      Fluttertoast.showToast(
          backgroundColor: Colors.red,
          msg: 'Failed to display payment error message',
          toastLength: Toast.LENGTH_LONG);
    }
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: 'Payment failed with wallet name: ${response.walletName}',
        toastLength: Toast.LENGTH_LONG);
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    final user = FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: _auth.currentUser!.uid);

    MediaQueryData mediaQuery = MediaQuery.of(context);
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
        body: StreamBuilder<QuerySnapshot>(
          stream: user.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.data!.docs.isNotEmpty) {
              print('hrelloooooooooooooooooo');

                 var userData = snapshot.data!.docs.first; 
              // var userData = snapshot.data!.docs.first;

              return SingleChildScrollView(
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
                        'Disease',
                        style: GoogleFonts.dongle(
                            fontWeight: FontWeight.bold, fontSize: 28),
                      ),
                    ),
                    CustomTextFormField(
                        fonrmtype: 'Disease',
                        formColor: Colormanager.wittextformfield,
                        Textcolor: Colormanager.grayText,
                        controller: _fullnameController,
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
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 14.0, horizontal: 10.0),
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
                              color:
                                  Colors.red, // Red border for validation error
                              width: 1,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            // Define border style for focused validation error
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors
                                  .red, // Red border for focused validation error
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.size.width * 0.1,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: SlideAction(
                        onSubmit: () {
                          
                          int fees = widget.fees;
                          openCheckout(fees);
                        },
                        sliderButtonIcon: Icon(
                          Icons.arrow_forward_ios,
                          size: 30,
                          color: Colormanager.blueicon,
                        ),
                        sliderButtonIconPadding: 10,
                        textStyle: GoogleFonts.dongle(
                          fontWeight: FontWeight.bold,
                          fontSize: 33,
                          color: Colors.white,
                        ),
                        text: 'Swipe to Pay',
                        borderRadius: 25,
                        elevation: 5,
                        outerColor: Colormanager
                            .blueContainer, // A professional blue color
                        innerColor: Colormanager
                            .whiteContainer, // A lighter shade of the outer color
                      ),
                    ),
                  ],
                ),
              );
            }

            return Container();
          },
        ));
  }
}
