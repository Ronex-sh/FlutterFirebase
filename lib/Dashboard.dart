import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './Home.dart';
import 'UpdateContact.dart';
import 'addcontact.dart';
import 'CrudeFire.dart';
class Dashboard extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return DashboardState();
  }

}

class DashboardState extends State<Dashboard>{



  CrudFire crud = new CrudFire();
  QuerySnapshot contacts;
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

  @override
  void initState() {
    super.initState();
    getUserData();

      crud.getData().then((data){
        setState(() {
        contacts=data;
      });
    });


  }
  Widget showdata(){
    if(contacts!=null && contacts.documents!=null){
      return ListView.builder(
        itemBuilder: (_,index){
          return Container(
            child: Column(
              children: <Widget>[

                ListTile(
                  trailing: IconButton(icon: Icon(Icons.delete), onPressed: (){
                   crud.delete(contacts.documents[index].documentID);
                   Navigator.of(context).pushAndRemoveUntil(
                       MaterialPageRoute(builder: (context) => Dashboard()),
                           (Route<dynamic> route) => false);
                   // contacts.documents[index].reference.delete();
                  }),
                  leading: IconButton(icon: Icon(Icons.edit), onPressed: (){
                    print(contacts.documents[index].documentID);
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context)=>UpdateContact(

                            contacts.documents[index]
                          )));
                  }),
                  title: Text('${contacts.documents[index].data['emaill']}'),

                  subtitle: Text('${contacts.documents[index].data['emaill']}'),
                ),

              ],
            ),
          );
        },
        itemCount: contacts.documents.length,


      );
    }else if(contacts!=null && contacts.documents.length==0){
      return Text('please wait loead your data');

    }else {

      return Text('no data right now !! please add new data ');
  }

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('My Contacts App'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add), onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (_){
              return AddContact();
            }));


    }),
          FlatButton(
          //  color: Colors.white,
            child: Text('SignOut'),
            onPressed: _signout,
          )
        ],
      ),
        body: showdata(),



//      body:
//
//      StreamBuilder(
//          stream:Firestore.instance.collection('contact').snapshots() ,
//
//
//          builder: (_,snapshot){
//            if(!snapshot.hasData) return Text('lodaing data');
//            return Column(
//              children: <Widget>[
//                Text(snapshot.data.documents[1]['namee'])
//              ],
//            );
//
//          })
    );
  }

}