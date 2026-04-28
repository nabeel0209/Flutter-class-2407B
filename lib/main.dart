import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  List<Map<String, dynamic>> users = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Form', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),

      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('User Name'),
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: TextField(
                          controller: userNameController,
                          decoration: InputDecoration(
                            hintText: 'Enter your username',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('User Age'),
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: TextField(
                          controller: ageController,
                          decoration: InputDecoration(
                            hintText: 'Enter your age',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    onPressed: () => print('Hello World'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                    child: Text('Add', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}