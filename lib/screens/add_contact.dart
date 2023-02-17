import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import '../model/contact.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class AddContact extends StatefulWidget {
  const AddContact({Key? key}) : super(key: key);

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
  String _firstName = '';
  String _lastName = '';
  String _phone = '';
  String _email = '';
  String _address = '';
  String _photoUrl = 'empty';
  ImagePicker opengallery = ImagePicker();

  saveContact(BuildContext context) async {
    if (_firstName.isNotEmpty &&
        _lastName.isNotEmpty &&
        _phone.isNotEmpty &&
        _email.isNotEmpty &&
        _address.isNotEmpty) {
      Contact contact =
          Contact(_firstName, _lastName, _phone, _email, _address, _photoUrl);

      await databaseReference.push().set(contact.toJson());
      navigateToLastScreen(context);
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Field Required'),
            content: Text("Please Enter all the parameters"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Close"))
            ],
          );
        },
      );
    }
  }

  Future pickImage() async {
    XFile? file = await opengallery.pickImage(
        source: ImageSource.gallery, maxHeight: 200, maxWidth: 200);
    File img=File(file!.path);
    String filename = basename(img!.path);
    uploadImage(img, filename);
  }

  void uploadImage(File file, String filename) async {
    Reference storageReference = FirebaseStorage.instance.ref().child(filename);
    storageReference.putFile(file).then((firebaseFile) async {
      var downloadUrl = await firebaseFile.ref.getDownloadURL();
      setState(() {
        _photoUrl = downloadUrl;
      });
    });
  }
  setProfileImage()
  {
    return _photoUrl=="empty" ? AssetImage("images/logo.png"):NetworkImage(_photoUrl);

  }

  navigateToLastScreen(context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Contact"),
      ),
      body: Container(
        child: Padding(
            padding: EdgeInsets.all(20),
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      pickImage();
                    },
                    child: Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: setProfileImage()
                            )),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: TextField(
                    onChanged: (value) {
                      _firstName=value;
                    },
                    decoration: InputDecoration(labelText: "First Name",border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: TextField(
                    onChanged: (value) {
                      _lastName=value;
                    },
                    decoration: InputDecoration(labelText: "Last Name",border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: TextField(
                    onChanged: (value) {
                      _phone=value;
                    },
                    decoration: InputDecoration(labelText: "Enter Phone number",border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: TextField(
                    onChanged: (value) {
                      _email=value;
                    },
                    decoration: InputDecoration(labelText: "Enter Email",border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: TextField(
                    onChanged: (value) {
                      _address=value;
                    },
                    decoration: InputDecoration(labelText: "Enter address",border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      saveContact(context);
                    },
                    child: Text(
                      "Save",
                      style: TextStyle(
                        fontSize: 20.0,
                        color:Colors.white
                      ),
                    )
                  ),
                )
              ],
            )),
      ),
    );
  }
}
