

  import 'package:dotted_border/dotted_border.dart';
  import 'package:event_application1/Controllers/createEventController.dart';
  import 'package:flutter/cupertino.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter/services.dart';
  import 'package:get/get.dart';
  import 'package:intl/intl.dart';

  import '../../widget/customized_button.dart';
  import '../../widget/customized_textfield.dart';

  class CreateEventPage extends StatefulWidget {
    const CreateEventPage({super.key});

    @override
    State<CreateEventPage> createState() => _CreateEventPageState();
  }

  class _CreateEventPageState extends State<CreateEventPage> {
    final CreateEventController createEventController=Get.put(CreateEventController());

    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


    @override
    void initState() {
      super.initState();
    }

    @override
    Widget build(BuildContext context) {
      return Obx(() => Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text("Create Event"),

        ),
        body: SingleChildScrollView(
          child:Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DottedBorder(
                          color: const Color(0xff02cad0),
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(12),
                          child: GestureDetector(
                              onTap: () {
                                createEventController.pickCoverImage();
                              },
                              child:Obx(() =>  Container(
                                height: 180,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color(0xffeef7f8),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Stack(
                                  children: [
                                    if (createEventController.coverImage.value != null)
                                      Positioned.fill(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Image.file(
                                            createEventController.coverImage.value!,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    if (createEventController.coverImage.value == null)
                                      Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: const Color(0xff02cad0)),
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Icon(Icons.add, color: Color(0xff02cad0)),
                                        ),
                                      ),
                                  ],
                                ),
                              ),)
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          for (int i = 0; i < createEventController.mediaFiles.length; i++)
                            GestureDetector(
                                onTap: () {
                                  createEventController.pickMediaImage(i);
                                },
                                child: Obx(() => Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: DottedBorder(
                                        color: const Color(0xff02cad0),
                                        borderType: BorderType.RRect,
                                        radius: const Radius.circular(12),
                                        child: Container(
                                          height: 60,
                                          width: 60,
                                          decoration: BoxDecoration(
                                            color: const Color(0xffeef7f8),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: createEventController.mediaFiles[i] == null
                                              ? Icon(Icons.add, color: Color(0xff02cad0))
                                              : null,
                                        ),
                                      ),
                                    ),
                                    if (createEventController.mediaFiles[i] != null)
                                      Positioned.fill(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Image.file(
                                            createEventController.mediaFiles[i]!,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    if (createEventController.mediaFiles[i] != null)
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: IconButton(
                                          icon: Icon(Icons.close),
                                          onPressed: () {
                                            createEventController.discardMediaImage(i);
                                          },
                                        ),
                                      ),
                                  ],
                                ),)
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text("Full Name", style: TextStyle(fontSize: 15,
                            fontWeight: FontWeight.w900),
                        ),
                      ),
                      mytextfield(
                        mycontroller: createEventController.eventname,
                        hinttext: "Enter Event name",
                        ispassword: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Event name is required';
                          }
                          return null; // Return null if the input is valid
                        },),
                      const SizedBox(height: 20,),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text("Category", style: TextStyle(fontSize: 15,
                            fontWeight: FontWeight.w900),
                        ),
                      ),
                      // Inside the EventForm widget...
                      EventCategorySelector(
                        categories: createEventController.categories,
                        selectedCategory: createEventController.selectedCategory,
                        onCategoryChanged: (value) {
                          setState(() {
                            createEventController.selectedCategory = value;
                          });
                        },
                      ),

                      const SizedBox(height: 20,),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text("Venue Address", style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w900),
                        ),
                      ),
                      mytextfield(mycontroller: createEventController.eventaddress,
                        hinttext: "Enter Address",
                        ispassword: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Address should not be empty';
                          }
                          return null; // Return null if the input is valid
                        },),

                      const SizedBox(height: 20,),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Location",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      mytextfield(
                        mycontroller: createEventController.locationController,
                        hinttext: "Enter Location of city",
                        ispassword: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Location is required';
                          }
                          return null; // Return null if the input is valid
                        },
                      ),
                      const SizedBox(height: 20,),

                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text("Price", style: TextStyle(fontSize: 15,
                            fontWeight: FontWeight.w900),
                        ),
                      ),
                      TextField(
                        controller: createEventController.pricecontroller,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(
                          prefixText: '₹',
                          contentPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 13),
                          hintText: "Enter price",
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Color(0xff02cad0), width: 1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),


                      const SizedBox(height: 20,),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text("Date ", style: TextStyle(fontSize: 15,
                            fontWeight: FontWeight.w900),
                        ),
                      ),


                      TextFormField(
                        readOnly: true,
                        controller: createEventController.datecontroller,
                        decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.calendar_today),
                          contentPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 13),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Color(0xff02cad0), width: 1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          hintText: "Select date",
                        ),
                        onTap: () async {
                          DateTime now = DateTime.now();

                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: now,
                            firstDate: now,
                            lastDate: DateTime(2100),
                            builder: (BuildContext context, Widget? child) {
                              return Theme(
                                data: ThemeData(
                                  primarySwatch: Colors.teal, // Set your primary color
                                  textTheme: TextTheme(
                                    headline1: TextStyle(fontSize: 24), // Adjust the font size as needed
                                    button: TextStyle(fontSize: 18), // Adjust the font size as needed
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );

                          if (pickedDate != null) {
                            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                            setState(() {
                              createEventController.datecontroller.text = formattedDate;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 20,),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text("Time ", style: TextStyle(fontSize: 15,
                            fontWeight: FontWeight.w900),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: TextField(
                              readOnly: true,
                              controller: createEventController.starttime,
                              style: TextStyle(fontSize: 16.0),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 13, horizontal: 13),
                                hintText: "Start Time",
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.black, width: 1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xff02cad0), width: 1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onTap: () async {
                                TimeOfDay? pickedtime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                  builder: (BuildContext context, Widget? child) {
                                    return Theme(
                                      data: ThemeData(
                                        primarySwatch: Colors.teal, // Set your primary color
                                        textTheme: TextTheme(
                                          headline1: TextStyle(fontSize: 24), // Adjust the font size as needed
                                          button: TextStyle(fontSize: 18), // Adjust the font size as needed
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );

                                if (pickedtime != null) {
                                  setState(() {
                                    createEventController.starttime.text = pickedtime.format(context);
                                  });
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 20.0,),
                          Flexible(
                            child: TextField(
                              readOnly: true,
                              controller: createEventController.endtime,
                              style: TextStyle(fontSize: 16.0),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 13, horizontal: 13),
                                hintText: "End Time",
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.black, width: 1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xff02cad0), width: 1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onTap: () async {
                                TimeOfDay? pickedtime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                  builder: (BuildContext context, Widget? child) {
                                    return Theme(
                                      data: ThemeData(
                                        primarySwatch: Colors.teal, // Set your primary color
                                        textTheme: TextTheme(
                                          headline1: TextStyle(fontSize: 24), // Adjust the font size as needed
                                          button: TextStyle(fontSize: 18), // Adjust the font size as needed
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );

                                if (pickedtime != null) {
                                  setState(() {
                                    createEventController.endtime.text = pickedtime.format(context); // Corrected here
                                  });
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 20.0,),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text("Reciever UpiID", style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w900),
                        ),
                      ),
                      mytextfield(
                        mycontroller: createEventController.UpiIdController,
                        hinttext: "788XXXX651@ybl",
                        ispassword: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'UpiID is required';
                          }
                          return null; // Return null if the input is valid
                        },
                      ),
                      const SizedBox(height: 20,),

                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text("Event Decription", style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w900),
                        ),
                      ),

                      TextFormField(
                        controller: createEventController.eventDescriptionController,
                        maxLines: 5, // Allow multiple lines for description
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 13),
                          hintText: "Enter event description",
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Color(0xff02cad0), width: 1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      if (createEventController.isSubmitting) CircularProgressIndicator(),

                      Text(
                        // Conditionally display error message
                        createEventController.isSubmitting ? '' : createEventController.publishErrorMessage,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      ),

                      Stack(
                        alignment: Alignment.center,
                        children: [
                          customizedbtn(
                            buttonText: createEventController.isSubmitting ? 'Submitting...' : 'Publish',
                            onPressed: () {
                              if (!createEventController.isSubmitting) {
                                setState(() {
                                  createEventController.isSubmitting = true;
                                });
                                createEventController.SubmitForm(); // Simulate the publishing process
                              }
                            },
                            textColor: Colors.white,
                          ),
                          // Visibility(
                          //   visible: createEventController.isSubmitting,
                          //   child: CircularProgressIndicator(
                          //     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          //   ),
                          // ),
                        ],
                      ),



                      const SizedBox(height: 30,),
                    ],
                  ),
                )

              ],
            ),
          ),
        ),
      ));
    }
  }
