import 'package:event_application1/screens/trendingViewAll.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controllers/trendingeventController.dart';
import '../screens/event_details_page.dart';

class CategorySliderViewAll extends StatefulWidget {
  const CategorySliderViewAll({Key? key}) : super(key: key);

  @override
  State<CategorySliderViewAll> createState() => _CategorySliderViewAllState();
}

class _CategorySliderViewAllState extends State<CategorySliderViewAll> {
  int selectedCategoryIndex = 0; // Track the selected category index

  List<Map<String, dynamic>> categories = [
    {"name": "All", "icon": Icons.star}, // Associate "All" with a star icon
    {"name": "Sports", "icon": Icons.sports_baseball},
    {"name": "Music", "icon": Icons.music_note},
    {"name": "Food", "icon": Icons.fastfood},
    {"name": "Party", "icon": Icons.fastfood},
    // Add more categories here
  ];

  double categoryWidth = 100.0; // Define the default category width

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Trending Events"),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(left: 20,top: 20),
              child: Row(
                children: List.generate(
                  categories.length,
                      (index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategoryIndex = index; // Update the selected index
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      height: 45,
                      width: categories[index]["name"] == "All"
                          ? 61
                          : categoryWidth, // Use the dynamic width here
                      decoration: BoxDecoration(
                        color: selectedCategoryIndex == index
                            ? Colors.orange
                            : Colors.grey[300],
                        border: Border.all(width: 1, color: Color(0xE0E0E0FF)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if (index != 0) // Conditionally render the icon container
                            Container(
                              height: 35,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(width: 1, color: Colors.white),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Icon(
                                categories[index]["icon"],
                                color: Colors.orange,
                              ),
                            ),
                          Center(
                            child: Text(
                              categories[index]["name"],
                              style: TextStyle(
                                fontSize: 16,
                                color: selectedCategoryIndex == index
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: TrendingViewAll(
              selectedCategoryIndex: selectedCategoryIndex,
              categories: categories,
            ),
          ),
        ],
      ),
    );
  }
}