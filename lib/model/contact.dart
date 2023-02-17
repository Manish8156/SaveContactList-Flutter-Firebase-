import 'package:firebase_database/firebase_database.dart';

class Contact {
  String _id="";
  String _firstName='';
  String _lastName='';
  String _phone='';
  String _email='';
  String _address='';
  String _photoUrl='';


  //constructor for add
  Contact(this._firstName,this._lastName,this._phone,this._email,this._address,this._photoUrl);
  //constructor for edit
  Contact.withId(this._id,this._firstName,this._lastName,this._phone,this._email,this._address,this._photoUrl);

  //getter
  String get id=>_id;
  String get firstName=>_firstName;
  String get lastName=>_lastName;
  String get phone=>_phone;
  String get email=>_email;
  String get address=>_address;
  String get photoUrl=>_photoUrl;

  //Setters
  set firstName(String firstName)
    {
       _firstName=firstName;
    }

  set lastName(String lastName)
  {
    _lastName=lastName;
  }

  set phone(String phone)
  {
    _phone=phone;
  }

  set email(String email)
  {
    _email=email;
  }

  set address(String address)
  {
    _address=address;
  }

  set photoUrl(String photoUrl)
  {
    _photoUrl=photoUrl;
  }

  //coming the data from from firebase or in snapShort
  Contact.fromSnapShot(DataSnapshot snapshot)
  {
    var data=snapshot.value as Map;
    _id=snapshot.key!;
    _firstName=data['firstName'];
    _lastName=data['lastName'];
    _phone=data['phone'];
    _email=data['email'].toString();
    _address=data['address'];
    _photoUrl=data['photoUrl'];

  }
  Map<String,dynamic> toJson() {
    return {
      "firstName":_firstName,
      "lastName":_lastName,
      "phone":_phone,
      "email":_email,
      "address":_address,
      "photoUrl":_photoUrl
    };
  }
}