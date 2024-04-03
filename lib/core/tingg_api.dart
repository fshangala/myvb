import 'package:cloud_firestore/cloud_firestore.dart';

class TinggExpressCheckout {
  FirebaseFirestore db = FirebaseFirestore.instance;
  Future<Map<String, dynamic>?> generatePayload(
      Map<String, dynamic> data) async {
    var documentReference = db.collection('tinggPayment').doc(data['msisdn']);
    await documentReference.set(data);
    var documentSnapshot = await documentReference.get();
    return documentSnapshot.data();
  }
}
