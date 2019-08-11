
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './Home.dart';
import 'CrudeFire.dart';
import 'Dashboard.dart';


class UpdateContact extends StatefulWidget{
  DocumentSnapshot document;

  UpdateContact(this.document);

  @override
  State<StatefulWidget> createState() {
    return  UpdateContactState();
  }

}

class UpdateContactState extends State<UpdateContact>{
  CrudFire crud = new CrudFire();

  final GlobalKey<FormState> formState = GlobalKey<FormState>();
  String _email,_mobile,_name;

  FirebaseUser user;
  final auth = FirebaseAuth.instance;
  Future<void> getUserData() async{
    FirebaseUser userData = await FirebaseAuth.instance.currentUser();

    setState(() {
      user = userData;



    });
  }

  Future<void> _signout() async{
    auth.signOut();
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => Home()));
  }

  updateContact(){
    if(formState.currentState.validate()){
      formState.currentState.save();
      crud.Update({
        'namee':_name,
        'emaill':_email,
        'passwordd':_mobile,
        'userId':user.uid
      } ,widget.document.documentID);
      print(widget.document.documentID);
      showDialog(

        context: context,
        barrierDismissible: false,
        child: new Dialog(
          backgroundColor: Colors.amber,
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              new CircularProgressIndicator(),
              new Text("Loading"),
            ],
          ),
        ),
      );

      Navigator.push(context, MaterialPageRoute(builder: (_)=>Dashboard()));

    }
  }



  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Contact'),
        actions: <Widget>[
          FlatButton(
            //  color: Colors.white,
            child: Text('SignOut'),
            onPressed: _signout,
          )
        ],
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Form(
              key: formState,
              child: Container(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                          icon: Icon(Icons.person),
                          hintText: 'Name'),
                      // ignore: missing_return
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Enter Name Of Contact';
                        }
                      },
                      onSaved: (val) => _name = val,
                      initialValue: widget.document.data['namee'],
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          icon: Icon(Icons.email),
                          hintText: 'Email Address'),
                      // ignore: missing_return
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Please Enter Email Of Contact';
                        }
                      },
                      onSaved: (val) => _email = val,
                      initialValue: widget.document.data['emaill'],
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          icon: Icon(Icons.phone),
                          hintText: 'Mobile'),
                      // ignore: missing_return
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Enter Mobile Of Contact';
                        } else if (val.length < 14) {
                          return 'your Mobile need to be atleast 14 Number';
                        }
                      },
                      onSaved: (val) => _mobile = val,
                      initialValue: widget.document.data['passwordd'],
                    ),
                    RaisedButton(
                      color: Colors.lightBlueAccent,
                      textColor: Colors.white,
                      onPressed: updateContact,
                      child: Text('Update Contact'),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}