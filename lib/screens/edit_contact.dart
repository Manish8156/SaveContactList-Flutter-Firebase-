import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';
import '../model/contact.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
class EditContact extends StatefulWidget {
   String id;
  EditContact(this.id);
  @override
  State<EditContact> createState() => _EditContactState(id);
}

class _EditContactState extends State<EditContact> {
  String id;
   _EditContactState(this.id);
  String _firstName='';
  String _lastName='';
  String _phone='';
  String _email='';
  String _address='';
  String _photoUrl='';

  TextEditingController _fnController=TextEditingController();
  TextEditingController _lnController=TextEditingController();
  TextEditingController _poController=TextEditingController();
  TextEditingController _emController=TextEditingController();
  TextEditingController _adController=TextEditingController();

  bool isLoading =true;
  Contact _contact=Contact('', '', '', '','','');
  ImagePicker opengallery = ImagePicker();

  DatabaseReference _databaseReference=FirebaseDatabase.instance.ref();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getContact(id);
  }
  getContact(String id)
  async{
    _databaseReference.child(id).onValue.listen((event) {
        _contact=Contact.fromSnapShot(event.snapshot);
        _fnController.text=_contact.firstName;
        _lnController.text=_contact.lastName;
        _poController.text=_contact.phone;
        _adController.text=_contact.address;
        _emController.text=_contact.email;
     setState(() {
       _firstName=_contact.firstName;
       _lastName=_contact.lastName;
       _phone=_contact.phone;
       _email=_contact.email;
       _address=_contact.address;
       _photoUrl=_contact.photoUrl;
       isLoading = false;
     });

    });
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
  getimage()
  {
    return _photoUrl == "empty"
        ? AssetImage("images/logo.png")
        : NetworkImage(_photoUrl);
  }
  navigateToLastScreen(BuildContext context)
  {
    Navigator.pop(context);
    
  }
  upDateContact(BuildContext context)
  async{
    if(_firstName.isNotEmpty &&
        _lastName.isNotEmpty &&
        _email.isNotEmpty &&
        _phone.isNotEmpty &&
        _address.isNotEmpty 
    )
      {
        Contact contact =Contact.withId(id, _firstName, _lastName, _phone, _email, _address,_photoUrl);
        await _databaseReference.child(id).set(contact.toJson())
;        navigateToLastScreen(context);
      }
    else
      {
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



  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Contact"),
      ),
      body: Container(
        child: isLoading
            ? Center(
          child: CircularProgressIndicator(),
        )
            : Padding(
          padding: EdgeInsets.all(20.0),
          child: ListView(
            children: <Widget>[
              //image view
              Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      pickImage();
                    },
                    child: Center(
                      child: Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                fit: BoxFit.cover,
                                image: getimage(),
                              ))),
                    ),
                  )),
              //
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _firstName = value;
                    });
                  },
                  controller: _fnController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                ),
              ),
              //
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _lastName = value;
                    });
                  },
                  controller: _lnController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                ),
              ),
              //
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _phone = value;
                    });
                  },
                  controller: _poController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                ),
              ),
              //
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                  controller: _emController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                ),
              ),
              //
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _address = value;
                    });
                  },
                  controller: _adController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                ),
              ),
              // update button
              Container(
                padding: EdgeInsets.only(top: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    upDateContact(context);
                  },
                  child: Text(
                    "Update",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
