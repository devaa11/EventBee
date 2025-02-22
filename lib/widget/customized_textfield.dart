import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class mytextfield extends StatelessWidget {
  const mytextfield({
    Key? key,
    required this.mycontroller,
    required this.hinttext,
    required this.ispassword,
    this.errortext,
    required this.validator,
    this.keyboardType = TextInputType.text,
    this.suffixIcon, // Add suffixIcon parameter
  }) : super(key: key);

  final TextInputType keyboardType;
  final mycontroller;
  final hinttext;
  final bool ispassword;
  final errortext;
  final String? Function(String?) validator;
  final Widget? suffixIcon; // Add suffixIcon property

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: mycontroller,
      obscureText: ispassword,
      keyboardType: keyboardType,
      cursorColor: Color(0xff02cad0),
      decoration: InputDecoration(
        suffixIcon: suffixIcon, // Use the provided suffixIcon
        contentPadding: EdgeInsets.symmetric(vertical: 13, horizontal: 13),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xff02cad0), width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        hintText: hinttext,
        errorText: errortext, // Display error text when validation fails
      ),
      validator: (value) => validator(value), // Use the custom validator function
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}

class phonetextfield extends StatelessWidget {
  const phonetextfield({Key? key,required this.mycontroller,required this.hinttext}) : super(key: key);
final mycontroller;
final hinttext;
  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      controller: mycontroller,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 13,horizontal: 13),
        hintText: hinttext,
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(20)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xff02cad0), width: 1),
            borderRadius: BorderRadius.circular(20)),

      ),

      cursorColor: Color(0xff02cad0),
    );
  }
}
class EventCategorySelector extends StatefulWidget {
  final List<String> categories;
  final String selectedCategory;
  final void Function(String) onCategoryChanged;

  EventCategorySelector({
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  _EventCategorySelectorState createState() => _EventCategorySelectorState();
}

class _EventCategorySelectorState extends State<EventCategorySelector> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: widget.selectedCategory,
      onChanged: (value) {
        widget.onCategoryChanged(value!);
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 13,
          horizontal: 13,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xff02cad0), width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      items: widget.categories.map((category) {
        return DropdownMenuItem<String>(
          value: category,
          child: Text(category),
        );
      }).toList(),
    );
  }
}
