
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'edit_contact.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/contact.dart';
class ViewContact extends StatefulWidget {
  String id;
  ViewContact(this.id);

  @override
  State<ViewContact> createState() => _ViewContactState(id);
}

class _ViewContactState extends State<ViewContact> {
  DatabaseReference _databaseReference=FirebaseDatabase.instance.ref();
  String id;
  Contact _contact=Contact('', '', '', '', '', '');
  bool isLoading=true;
  _ViewContactState(this.id);
  getContact(id)
  async{
    _databaseReference.child(id).onValue.listen((event) { 
      setState(() {
        _contact=Contact.fromSnapShot(event.snapshot);
        isLoading=false;
        print(isLoading);
      });
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(id);
    this.getContact(id);
  }
  callAction(String number)
  async{
    String url="tel:$number";
    await launchUrlString(url);
  }

  smsAction(String number)
  async{
    String url="sms:$number";
    await launchUrlString(url);
  }
  
  deleteContact()
  {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text("Delete"),
        content: Text("Delete Contact"),
        actions: [
          TextButton(onPressed: () {
            Navigator.of(context).pop();
          }, child: Text("Cancel")),
          TextButton(onPressed:  () async{
            Navigator.of(context).pop();
            await _databaseReference.child(id).remove();
            navigateToLastScreen();
          }, child: Text("Delete"))
        ],
      );
    },);
  }
  navigateToEditScreen(id)
  {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return EditContact(id);
      },));
  }
  navigateToLastScreen()
  {
    Navigator.of(context).pop();
  }
  getPicture()
  {
    return _contact.photoUrl == "empty"
        ? AssetImage("images/logo.png")
        : NetworkImage(_contact.photoUrl);
  }
  @override
  Widget build(BuildContext context) {
    // wrap screen in WillPopScreen widget
    return Scaffold(
      appBar: AppBar(
        title: Text("View Contact"),
      ),
      body: Container(
        child: isLoading
            ? Center(
          child: CircularProgressIndicator(),
        )
            : ListView(
          children: <Widget>[
            // header text container
            Container(
                height: 200.0,
                child: Image(
                  //
                  image: getPicture(),
                  fit: BoxFit.contain,
                )),
            //name
            Card(
              elevation: 2.0,
              child: Container(
                  margin: EdgeInsets.all(20.0),
                  width: double.maxFinite,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.perm_identity),
                      Container(
                        width: 10.0,
                      ),
                      Text(
                        "${_contact.firstName} ${_contact.lastName}",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ],
                  )),
            ),
            // phone
            Card(
              elevation: 2.0,
              child: Container(
                  margin: EdgeInsets.all(20.0),
                  width: double.maxFinite,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.phone),
                      Container(
                        width: 10.0,
                      ),
                      Text(
                        _contact.phone,
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ],
                  )),
            ),
            // email
            Card(
              elevation: 2.0,
              child: Container(
                  margin: EdgeInsets.all(20.0),
                  width: double.maxFinite,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.email),
                      Container(
                        width: 10.0,
                      ),
                      Text(
                        _contact.email,
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ],
                  )),
            ),
            // address
            Card(
              elevation: 2.0,
              child: Container(
                  margin: EdgeInsets.all(20.0),
                  width: double.maxFinite,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.home),
                      Container(
                        width: 10.0,
                      ),
                      Text(
                        _contact.address,
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ],
                  )),
            ),
            // call and sms
            Card(
              elevation: 2.0,
              child: Container(
                  margin: EdgeInsets.all(20.0),
                  width: double.maxFinite,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      IconButton(
                        iconSize: 30.0,
                        icon: Icon(Icons.phone),
                        color: Colors.red,
                        onPressed: () {
                          callAction(_contact.phone);
                        },
                      ),
                      IconButton(
                        iconSize: 30.0,
                        icon: Icon(Icons.message),
                        color: Colors.red,
                        onPressed: () {
                          smsAction(_contact.phone);
                        },
                      )
                    ],
                  )),
            ),
            // edit and delete
            Card(
              elevation: 2.0,
              child: Container(
                  margin: EdgeInsets.all(20.0),
                  width: double.maxFinite,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      IconButton(
                        iconSize: 30.0,
                        icon: Icon(Icons.edit),
                        color: Colors.red,
                        onPressed: () {
                          navigateToEditScreen(id);
                        },
                      ),
                      IconButton(
                        iconSize: 30.0,
                        icon: Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () {
                          deleteContact();
                        },
                      )
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}

