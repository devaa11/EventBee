import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaypalPayment extends StatefulWidget {
  const PaypalPayment({super.key});

  @override
  State<PaypalPayment> createState() => _PaypalPaymentState();
}

class _PaypalPaymentState extends State<PaypalPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PaypalPayment"),
        leading: GestureDetector(
          onTap: (){
            Get.back();
          },
          child: Icon(Icons.keyboard_backspace),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            
          ],
        ),
      ),
    );
  }
}
