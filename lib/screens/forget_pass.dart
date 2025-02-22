import 'package:flutter/material.dart';

import '../widget/customized_button.dart';
import '../widget/customized_textfield.dart';

class forgotpass extends StatefulWidget {
  const forgotpass({Key? key}) : super(key: key);

  @override
  State<forgotpass> createState() => _forgotpassState();
}

class _forgotpassState extends State<forgotpass> {
  final TextEditingController _emailcontroller=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          toolbarHeight: 80,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Image.asset('assets/logo.png',
            height: 50,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50,),
              const Center(
                child:
                Text("Log In",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold),),
              ),
              const Text("Use your credential and login to your account",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 30,),
              Container(
                height: MediaQuery.of(context).size.height*0.67,
                width: double.infinity,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40.0),
                        topLeft: Radius.circular(40.0)),
                    color: Colors.white70),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text("Email",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w900),
                        ),
                      ),
                      mytextfield(mycontroller: _emailcontroller,hinttext: "Enter email",ispassword: false,
                        validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        return null; // Return null if the input is valid
                      },),

                      const SizedBox(height: 30,),

                      customizedbtn(buttonText: "Submit",
                        onPressed: (){},
                        textColor: Colors.white,
                      ),
                    ],
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
