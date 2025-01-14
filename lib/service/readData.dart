
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class ReadData {
  static Future<List?> fetchBookedTime(selectedDate,doctId) async {
    List? bookedTimeslots;
    await FirebaseFirestore.instance
        .collection("bookedTimeSlots")
        .doc(doctId).collection(doctId)
        .doc(selectedDate)
        .get()
        .then((snapshot) =>
    {bookedTimeslots = snapshot.data()!["bookedTimeSlots"]})
        .catchError((e) => {print(e)});

    return bookedTimeslots;
  }

  static Future fetchOpeningClosingTime() async {
    final firebaseInstance = await FirebaseFirestore.instance
        .collection("timing")
        .doc("clinicTiming")
        .get();

    return firebaseInstance;
  }
  static Future fetchTiming() async {
    final firebaseInstance = await FirebaseFirestore.instance.collection(
        'timing').doc("clinicTiming")
        .get();

    return firebaseInstance;
  }


  static fetchSettingsStream() {
    final firebaseInstance = FirebaseFirestore.instance.collection(
        'settings').doc("settings").snapshots();
    //doc(settingName).snapshots();

    return firebaseInstance;
  }
  static fetchSettings() {
    final firebaseInstance = FirebaseFirestore.instance.collection(
        'settings').doc("settings").get();

    return firebaseInstance;
  }


  static fetchNotificationDotStatus() {
    final firebaseInstance = FirebaseFirestore.instance.collection(
        'profile').doc("profile").snapshots();
    //doc(settingName).snapshots();

    return firebaseInstance;
  }
  static fetchDoctorsNotificationDotStatus(String doctId) {
    final firebaseInstance = FirebaseFirestore.instance.collection(
        'doctorsNoti').doc("$doctId").snapshots();
    //doc(settingName).snapshots();

    return firebaseInstance;
  }


  static fetchPharmaNotificationDotStatus(String pharmaId) {

    // print("pppppppppppppppiiiiiiiiiiiiiddddddddd$pharmaId");
    final firebaseInstance = FirebaseFirestore.instance.collection(
        'pharma').doc("$pharmaId").snapshots();
    //doc(settingName).snapshots();

    return firebaseInstance;
  }
  static fetchLabAttenderNotificationDotStatus(String id) {

    // print("pppppppppppppppiiiiiiiiiiiiiddddddddd$pharmaId");
    final firebaseInstance = FirebaseFirestore.instance.collection(
        'labattender').doc("$id").snapshots();
    //doc(settingName).snapshots();

    return firebaseInstance;
  }

  // firebase database realtime
  static fetchMessagesStream(id) {
    DatabaseReference firebaseInstance = FirebaseDatabase.instance.ref().child("messages").child(id);
    return firebaseInstance;
  }

}