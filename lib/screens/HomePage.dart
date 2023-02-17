
import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'add_contact.dart';
import 'edit_contact.dart';
import 'view_contact.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
class HomePage extends StatefulWidget {


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseReference _databaseReference= FirebaseDatabase.instance.ref();


  navigateToAddScreen()
  {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return AddContact();
    },));
  }
  getProfileImage( newsnapshot)
  {
    return newsnapshot.value["photoUrl"]=="empty" ? AssetImage("images/logo.png") : NetworkImage(newsnapshot.value["photoUrl"]);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text("Contact List"),
      ),
      body: Container(
        child: FirebaseAnimatedList(
          query: _databaseReference,
          itemBuilder: (context,snapshot,Animation<double> animation,int index)
          {
            var data=snapshot.value as Map;
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ViewContact(snapshot.key.toString());
                },));
              },
              child: Card(
                color: Colors.white,
                elevation: 2.0,
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: getProfileImage(snapshot),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${data['firstName']} ${data['lastName']}",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,

                              ),
                            ),
                            Padding(padding: EdgeInsets.all(3.0)),
                            Text("${data["phone"]}")
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),

            );
          },
        ),

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToAddScreen();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
