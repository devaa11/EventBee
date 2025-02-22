// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
//
// import '../../Controllers/userdataController.dart';
// import '../../widget/EventForm.dart';
// import '../../widget/MediaSelector.dart';
//
// class CreateEventPage extends StatefulWidget {
//   const CreateEventPage({Key? key}) : super(key: key);
//
//   @override
//   State<CreateEventPage> createState() => _CreateEventPageState();
// }
//
// class _CreateEventPageState extends State<CreateEventPage> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//   List<File?> _selectedMediaFiles = [];
//
//   void _handleMediaUploaded(File? image) {
//     setState(() {
//       _selectedMediaFiles.add(image);
//     });
//   }
//
//   void _handleEventPublished() {
//     setState(() {
//       _selectedMediaFiles.clear(); // Clear selected media files
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         key: _scaffoldKey,
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           toolbarHeight: 80,
//           backgroundColor: Colors.grey[100],
//           centerTitle: true,
//           title: const Text(
//             "Create Event",
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 25,
//             ),
//           ),
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               MediaSelector(
//                 onMediaUploaded: _handleMediaUploaded,
//               ),
//               EventForm(
//                 selectedMediaFiles: _selectedMediaFiles,
//
//                 onPublish: () {
//                   _handleEventPublished;
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
