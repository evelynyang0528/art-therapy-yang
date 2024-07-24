import 'package:flutter/material.dart';
import 'package:scrollable_list_tab_scroller/scrollable_list_tab_scroller.dart';
class logscreen extends StatefulWidget {
  const logscreen({super.key});

  @override
  State<logscreen> createState() => _logscreenState();
}

class _logscreenState extends State<logscreen> {
  final data = {
    "Category A": [
      "Item 1 (A)",
      "Item 2 (A)",
      "Item 3 (A)",
      "Item 4 (A)",
    ],
    "Category B": [
      "Item 1 (B)",
      "Item 2 (B)",
    ],
    "Category C": [
      "Item 1 (C)",
      "Item 2 (C)",
      "Item 3 (C)",
      "Item 4 (C)",
      "Item 5 (C)",
    ],
    "Category D": [
      "Item 1 (D)",
      "Item 2 (D)",
      "Item 3 (D)",
      "Item 4 (D)",
      "Item 5 (D)",
      "Item 6 (D)",
      "Item 7 (D)",
      "Item 8 (D)",
      "Item 9 (D)",
    ],
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("past entries"),
      ),
      body: ScrollableListTabScroller(
        itemCount: data.length,
        tabBuilder: (BuildContext context, int index, bool active) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            data.keys.elementAt(index),
            style: !active
                ? null
                : TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
          ),
        ),
        itemBuilder: (BuildContext context, int index) => Column(
          children: [
            Text(
              data.keys.elementAt(index),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            ...data.values
                .elementAt(index)
                .asMap()
                .map(
                  (index, value) => MapEntry(
                index,
                ListTile(
                  leading: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.grey),
                    alignment: Alignment.center,
                    child: Text(index.toString()),
                  ),
                  title: Text(value),
                ),
              ),
            )
                .values
          ],
        ),
      ),
    );
  }
}