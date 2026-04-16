import 'package:flutter/material.dart';

//
// void main() {
//   runApp(
//     const MaterialApp(
//       home: Scaffold(
//         body: Center(child: MyCustomWidget(title: 'My App')),
//       ),
//     ),
//   );
// }
//
// class MyCustomWidget extends StatefulWidget {
//   const MyCustomWidget({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<MyCustomWidget> createState() => _MyCustomWidgetState();
// }
//
// class _MyCustomWidgetState extends State<MyCustomWidget> {
//   String _text = 'Hello World';
//
//   void changeText() {
//     setState(() {
//       _text = 'ahmed is a bad dude';
//     });
//   }
//
//   void changeTextBackToOriginal() {
//     setState(() {
//       _text = 'Hello World';
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(widget.title), // Access widget configuration via 'widget'
//         Text('New Text: $_text'),
//         ElevatedButton(
//           onPressed: changeText,
//           child: const Text(
//             'Change Text',
//             style: TextStyle(
//               fontSize: 20,
//               fontFamily: 'Poppins',
//               color: Colors.deepPurpleAccent,
//             ),
//           ),
//         ),
//         ElevatedButton(
//           onPressed: changeTextBackToOriginal,
//           child: Text(
//             'Revert Changes',
//             style: TextStyle(
//               fontSize: 20,
//               fontFamily: 'Poppins',
//               color: Color.fromARGB(255, 74, 20, 140),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        body: Center(child: ChangingText(title: 'MyApp')),
      ),
    ),
  );
}

class ChangingText extends StatefulWidget {
  const ChangingText({super.key, required this.title});

  final String title;

  @override
  State<ChangingText> createState() => ChangingTextState();
}

class ChangingTextState extends State<ChangingText> {
  String _text = 'Hello World';

  void changeText() {
    setState(() {
      _text = 'ahmed is a bad dude';
    });
  }

  void changeTextBackToOriginal() {
    setState(() {
      _text = 'Hello World';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Text(widget.title), // Access widget configuration via 'widget'
        // Container(margin: EdgeInsets.all(50), child: Text('New Text: $_text')),
        // Container(
        //   margin: EdgeInsets.only(),
        //   child: ElevatedButton(
        //     onPressed: changeText,
        //     child: const Text(
        //       'Change Text',
        //       style: TextStyle(
        //         fontSize: 20,
        //         fontFamily: 'Poppins',
        //         color: Colors.deepPurpleAccent,
        //       ),
        //     ),
        //   ),
        // ),
        // ElevatedButton(
        //   onPressed: changeTextBackToOriginal,
        //   child: Text(
        //     'Revert Changes',
        //     style: TextStyle(
        //       fontSize: 20,
        //       fontFamily: 'Poppins',
        //       color: Color.fromARGB(255, 74, 20, 140),
        //     ),
        //   ),
        // ),
        Container(
          width: 800,
          height: 400,
          decoration: BoxDecoration(
            color: Colors.pink,
            border: Border.all(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Text('Hello World'),
              Container(
                child: Row(
                  children: [
                    Image.asset('youtube.png', width: 150, height: 150),
                    Image.network(
                      'https://as2.ftcdn.net/v2/jpg/17/65/88/21/1000_F_1765882144_LIGjRITDUSaBTelN8vQ2WCsaL1qP3eCv.webp',
                      width: 400,
                      height: 400,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
