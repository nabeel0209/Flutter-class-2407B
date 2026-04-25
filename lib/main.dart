// import 'package:flutter/material.dart';
// import 'package:device_preview/device_preview.dart';
//
// void main() {
//   runApp(
//     DevicePreview(
//       enabled: true,
//       builder: (context) => MaterialApp(
//         useInheritedMediaQuery: true,
//         debugShowCheckedModeBanner: false,
//         home: Scaffold(
//           appBar: AppBar(title: Text('My Application')),
//           body: ListView(
//             children: [
//               ListTile(
//                 leading: Image.asset('youtube.png', width: 50,height: 50),
//                 title: Text(
//                   'Another iteration of mind.png',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                     color: Color(0xFF2D3A4A),
//                   ),
//                 ),
//                 subtitle: Text(
//                   '1.3 MB • Received',
//                   style: TextStyle(color: Colors.grey, fontSize: 13),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
// }
//
//
//
//

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Controllers

  TextEditingController userNameController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  List<Map<String, dynamic>> users = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Form', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Container(
        width: 500,
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
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
                children: [
                  Text('User Age'),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: TextField(
                      controller: userNameController,
                      decoration: InputDecoration(
                        hintText: 'Enter your age',
                        border: OutlineInputBorder(),
                      ),
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
