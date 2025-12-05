import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


// this file serces as a centerlized wrapper for fire base



class ApiClient{
  //singelton instance
  ApiClient._privateConstructor();
  static final ApiClient instance = ApiClient._privateConstructor();


  //fire base instance

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  FirebaseFirestore get db => _db;
  FirebaseAuth get auth => _auth;

  //get document
  Future<Map<String, dynamic>?> getDocument(String path) async{
    try{
      DocumentSnapshot doc = await _db.doc(path).get();
      return doc.data() as Map<String, dynamic>?;

    }catch(e){
      print("Firestrore GET error at $path: $e");
      return null;
    }
  }


//set document
  Future<bool> setDocument(String path, Map<String, dynamic> data)async{
  try{
    await _db.doc(path).set(data);
    return true;

  }catch(e){ 
    print("Firestore SET error at $path: $e");
    return false;
  }

}
//update document(merge)
  Future<bool> updateDocument(String path, Map<String, dynamic> data) async{
  try{
    await _db.doc(path).update(data);
    return true;

  }catch(e){
    print("Firestore UPDATE error at $path: $e");
    return false;
  }
}
//delete document
  Future<bool> deleteDocument(String path) async{
  try{
    await _db.doc(path).delete();
    return true;

  }catch(e){
    print("Firestore DELETE error at $path: $e");
    return false;
  }
}
//get collection
  Future<List<Map<String, dynamic>>> getCollection(String path) async {
    try {
      QuerySnapshot snapshot = await _db.collection(path).get();
      return snapshot.docs
          .map((doc) {
            final data = doc.data();
            if(data is Map<String, dynamic>){
              return data;
            }else if(data is Map<dynamic, dynamic>){
              return data.cast<String, dynamic>(); //convert Map<dynamic,dynamic> to <string, dynamic>
            }
            return <String, dynamic>{};
          })
          .toList();
    } catch (e) {
      print("Firestore COLLECTION error at $path: $e");
      return [];
    }
  }


//current user
User? get currentUser => _auth.currentUser;
String? get uuid => _auth.currentUser?.uid;
// Alias used by some services to reference the authenticated user id.
String? get uid => _auth.currentUser?.uid;
}
