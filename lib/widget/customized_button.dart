  import 'package:flutter/material.dart';

  class customizedbtn extends StatelessWidget {
    final String? buttonText;
    final Color? textColor;
    final VoidCallback? onPressed;
    const customizedbtn(
        {Key? key,
          this.buttonText,
          this.onPressed,
          this.textColor})
        : super(key: key);

    @override
    Widget build(BuildContext context) {
      return InkWell(
          onTap: onPressed,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: const Color(0xff02cad0),
                  border: Border.all(width: 1, color: const Color(0xff02cad0)),
                  borderRadius: BorderRadius.circular(20)),
              child: Center(
                  child: Text(
                    buttonText!,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 20,
                    ),
                  )
              )
          ),
      );
    }
  }
