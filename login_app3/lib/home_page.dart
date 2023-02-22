import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(children: [
          Text(
            'Signed in as',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          Text(
            user.email!,
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton.icon(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.arrow_back, size: 32),
            label: Text(
              'Sign Out',
              style: TextStyle(fontSize: 20),
            ),
          )
        ]),
      ),
    );
  }
}
