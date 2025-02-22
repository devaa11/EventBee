import 'package:event_application1/Firebase/Upi_Payment.dart';
import 'package:event_application1/screens/TicketHomePage.dart';
import 'package:event_application1/screens/pages/ticket_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../Controllers/selectedeventController.dart';
import '../Firebase/event_data.dart';
import 'paypal_payment.dart';

class CheckOutView extends StatefulWidget {

  @override
  _CheckOutViewState createState() => _CheckOutViewState();
}

class _CheckOutViewState extends State<CheckOutView> {
  int selectedRadio = -1;
  int numberOfSeats = 1;
  double ticketPrice = 20.0; // Set your ticket price here
  TextEditingController expirationDateController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != DateTime.now()) {
      final formattedDate = "${picked.month}/${picked.year}";
      expirationDateController.text = formattedDate;
    }
  }

  @override
  void dispose() {
    expirationDateController.dispose();
    super.dispose();
  }

  final SelectedEventController selectedEventController =
  Get.put(SelectedEventController()); // Find the SelectedEventController

  @override
  Widget build(BuildContext context) {
    EventData? selectedEvent = selectedEventController.selectedEvent.value;

    if (selectedEvent == null) {
      // Handle the case where selectedEvent is null
      // You can show an error message or return a loading indicator
      return Center(
        child: CircularProgressIndicator(), // Show a loading indicator
      );
    }

    String totalAmount = (double.parse(selectedEvent.price) * numberOfSeats)
        .toStringAsFixed(2); // Convert price to double and format it

    final Duration _snackBarDisplayDuration = Duration(seconds: 1);

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    'Payment Method',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: maxWidth > 600 ? 28.0 : 20.0,
                    ),
                  ),
                  buildPaymentMethodCard(
                      0, 'UPI Apps', 'Pay securely with your Upi Apps', maxWidth),
                  SizedBox(height: 10),
                  buildPaymentMethodCard(
                      1, 'PayPal', 'Pay securely with your PayPal account', maxWidth),
                  SizedBox(height: 10),
                  buildPaymentMethodCard(2, 'Stripe', 'Pay securely with Stripe', maxWidth),
                  SizedBox(height: 20),
                  Text(
                    'Number of Seats:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: maxWidth > 600 ? 28.0 : 20.0,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (numberOfSeats > 1) {
                                numberOfSeats--;
                              }
                            });
                          },
                          icon: Icon(Icons.remove),
                          color: Colors.grey,
                        ),
                        Text('$numberOfSeats'),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (numberOfSeats < 5) {
                                numberOfSeats++;
                              }
                            });
                          },
                          icon: Icon(Icons.add),
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ticket Price:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: maxWidth > 600 ? 28.0 : 20.0,
                        ),
                      ),
                      Text(
                        '${selectedEvent.price}',
                        style: TextStyle(
                          fontSize: maxWidth > 600 ? 28.0 : 20.0,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Amount:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: maxWidth > 600 ? 28.0 : 20.0,
                        ),
                      ),
                      Text(
                        '₹$totalAmount',
                        style: TextStyle(
                          fontSize: maxWidth > 600 ? 28.0 : 20.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff02cad0), // Background color
                        onPrimary: Colors.white, // Text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        if (selectedRadio == -1) {
                          // Show a snackbar message if no payment method is selected
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: _snackBarDisplayDuration ,
                              content: Text('Please select a payment method.'),
                            ),
                          );
                        } else if (_formKey.currentState!.validate()) {
                          // Form is valid and payment method is selected, proceed with booking logic
                          if (selectedRadio == 0) {
                            // Get.to(TicketHomePage(selectedSeats: numberOfSeats, totalAmount: totalAmount,)); // Pass selectedSeats
                            Get.to(UpiPaymentScreen(totalamnt: totalAmount, totalseats: numberOfSeats,));
                            // Credit Card selected
                            // Implement credit card payment logic
                          } else if (selectedRadio == 1) {
                            Get.to(TicketHomePage(selectedSeats: numberOfSeats, totalAmount: totalAmount,)); // Pass selectedSeats

                            // PayPal selected
                            // Implement PayPal payment logic
                          } else if (selectedRadio == 2) {
                            Get.to(TicketHomePage(selectedSeats: numberOfSeats, totalAmount: totalAmount,)); // Pass selectedSeats

                            // Stripe selected
                            // Implement Stripe payment logic
                          }
                        }
                      },
                      // onPressed: (){
                      //
                      //   Get.to(UpiPaymentScreen(totalamnt: totalAmount, totalseats: numberOfSeats,));
                      // },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 20.0,
                        ),
                        child: Text(
                          'Book Now',
                          style: TextStyle(
                            fontSize: maxWidth > 600 ? 28.0 : 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // TextButton(
                  //     onPressed: () => {
                  //       Navigator.of(context).push(
                  //         MaterialPageRoute(
                  //           builder: (BuildContext context) => UsePaypal(
                  //               sandboxMode: true,
                  //               clientId:
                  //               "AW1TdvpSGbIM5iP4HJNI5TyTmwpY9Gv9dYw8_8yW5lYIbCqf326vrkrp0ce9TAqjEGMHiV3OqJM_aRT0",
                  //               secretKey:
                  //               "EHHtTDjnmTZATYBPiGzZC_AZUfMpMAzj2VZUeqlFUrRJA_C0pQNCxDccB5qoRQSEdcOnnKQhycuOWdP9",
                  //               returnURL: "https://samplesite.com/return",
                  //               cancelURL: "https://samplesite.com/cancel",
                  //               transactions: const [
                  //                 {
                  //                   "amount": {
                  //                     "total": '10.12',
                  //                     "currency": "USD",
                  //                     "details": {
                  //                       "subtotal": '10.12',
                  //                       "shipping": '0',
                  //                       "shipping_discount": 0
                  //                     }
                  //                   },
                  //                   "description":
                  //                   "The payment transaction description.",
                  //                   // "payment_options": {
                  //                   //   "allowed_payment_method":
                  //                   //       "INSTANT_FUNDING_SOURCE"
                  //                   // },
                  //                   "item_list": {
                  //                     "items": [
                  //                       {
                  //                         "name": "A demo product",
                  //                         "quantity": 1,
                  //                         "price": '10.12',
                  //                         "currency": "USD"
                  //                       }
                  //                     ],
                  //
                  //                     // shipping address is not required though
                  //                     "shipping_address": {
                  //                       "recipient_name": "Jane Foster",
                  //                       "line1": "Travis County",
                  //                       "line2": "",
                  //                       "city": "Austin",
                  //                       "country_code": "US",
                  //                       "postal_code": "73301",
                  //                       "phone": "+00000000",
                  //                       "state": "Texas"
                  //                     },
                  //                   }
                  //                 }
                  //               ],
                  //               note: "Contact us for any questions on your order.",
                  //               onSuccess: (Map params) async {
                  //                 print("onSuccess: $params");
                  //               },
                  //               onError: (error) {
                  //                 print("onError: $error");
                  //               },
                  //               onCancel: (params) {
                  //                 print('cancelled: $params');
                  //               }),
                  //         ),
                  //       )
                  //     },
                  //     child: const Text("Make Payment")),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildPaymentMethodCard(int index, String title, String description, double maxWidth) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedRadio = index;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: selectedRadio == index ? Color(0xff02cad0) : Colors.white,
          border: Border.all(
            color: selectedRadio == index ? Color(0xff02cad0) : Colors.grey,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Radio(
              value: index,
              groupValue: selectedRadio,
              onChanged: (int? val) {
                setSelectedRadio(val!);
              },
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: maxWidth > 600 ? 24 : 18,
                      color: selectedRadio == index ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: maxWidth > 600 ? 20 : 16,
                      color: selectedRadio == index ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
