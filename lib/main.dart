import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';

void main() {
  runApp(
      DevicePreview(
          enabled: true,
          builder: (context) =>
              MaterialApp(
                useInheritedMediaQuery: true,
                debugShowCheckedModeBanner: false,
                home: Scaffold(
                  appBar: AppBar(title: Text('My Application')),
                  body: ListView(
                    children: [
                      ListTile(leading: Image.network('https://upload.wikimedia.org/wikipedia/commons/thumb/e/e7/Instagram_logo_2016.svg/3840px-Instagram_logo_2016.svg.png', width: 50, height: 50,), title: Text('Muhammad Nabeel'), trailing: Icon(Icons.person_add_alt_1, color: Colors.black, size: 30,),),
                    ],
                  ),
                ),
              ),
      )
  );
}
