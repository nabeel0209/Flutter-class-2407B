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

  void addUser() {
    if (userNameController.text.isEmpty || ageController.text.isEmpty)
      return print('Please enter a user');

    setState(() {
      users.add({'name': userNameController.text, 'age': ageController.text});
    });

    userNameController.clear();
    ageController.clear();
  }

  void deleteUser(int index) {
    setState(() {
      users.removeAt(index);
      print('User deleted');
    });
  }

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
                    onPressed: addUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    child: Text('Add', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.person),
                  title: Text('${index +1 } - ${users[index]['name']}'),
                  subtitle: Text(users[index]['age']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () => print('Edit button pressed'),
                        child: Row(children: [Text('Edit'), Icon(Icons.edit)]),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => deleteUser(index),
                        child: Row(
                          children: [Text('Delete'), Icon(Icons.delete)],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
