import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:fire_login/widgets/textformfield/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final Razorpay _razorpay = Razorpay();
  TextEditingController _amount = TextEditingController();

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
    amount = amount * 100;

    var options = {
      'key': 'rzp_test_5CIkvFaK1dDgsG', // Replace with your actual Razorpay key
      'amount': amount,
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
      Fluttertoast.showToast(msg: 'Failed to open payment gateway', toastLength: Toast.LENGTH_LONG);
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: 'Payment successful with ID: ${response.paymentId}', toastLength: Toast.LENGTH_LONG);
  }

void handlePaymentError(PaymentFailureResponse response) {
  try {
    Fluttertoast.showToast(msg: 'Payment failed with message: ${response.message}', toastLength: Toast.LENGTH_LONG);
  } catch (e) {
    debugPrint('Error handling payment failure: $e');
    Fluttertoast.showToast(msg: 'Failed to display payment error message', toastLength: Toast.LENGTH_LONG);
  }
}


  void handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: 'Payment failed with wallet name: ${response.walletName}', toastLength: Toast.LENGTH_LONG);
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: Colormanager.scaffold,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: mediaQuery.size.height * 0.2),
            Center(
              child: CustomTextFormField(
                  fonrmtype: 'Enter Amount',
                  formColor: Colors.white,
                  Textcolor: Colormanager.grayText,
                  controller: _amount,
                  value: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter amount';
                    }
                    return null;
                  }),
            ),
            TextButton(
                onPressed: () {
                  if (_amount.text.isNotEmpty) {
                    int amount = int.parse(_amount.text);
                    openCheckout(amount);
                  }
                },
                child: Text('Proceed to Payment')),
          ],
        ),
      ),
    );
  }
}
