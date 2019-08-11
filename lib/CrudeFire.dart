
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CrudFire{
  bool auth(){
    return FirebaseAuth.instance.currentUser()!=null? true :false;

  }
  Future<void> create(dat)async{
    if(auth()){
      Firestore.instance.collection('contact').add(dat);
  }
  }

  getData()async{
    FirebaseUser userData = await FirebaseAuth.instance.currentUser();
    return await Firestore.instance.collection('contact')

        .where('userId',isEqualTo: userData.uid)
        .getDocuments();
  }
  Update(data,docId)async{
    return await Firestore.instance.collection('contact').document(docId).setData(data);

  }
  delete(docId)async{
    return await Firestore.instance.collection('contact').document(docId).delete();

  }


}