// this class is going to be used as a data class to load the data from a user and use it globally
library global;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  // collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('services_info');

  // create user data at the startup of an account
  Future updateUserData(Map<String, dynamic> services) async {
    return await userCollection.doc(uid).set(services);
  }

  // get user data from the database
  Future<DocumentSnapshot> getUserData() async {
    return await userCollection.doc(uid).get();
  }

  // modify user data
  Future updateUserData1(Map<String, dynamic> services) async {
    return await userCollection.doc(uid).update(services);
  }
}

class UserActive {
  User? user;
  String? uid = "default_uid";
  String? email = "default_email";
  // here I'm going to make a map called services. it's going to contains info about the active services

  UserActive(this.user, this.uid, this.email);

  User? get getFbUser => user;
  String? get getEmail => email;
  String? get getUid => uid;

  set setFbUser(User? user) => this.user = user;
  set setEmail(String? email) => this.email = email;
  set setUid(String? uid) => this.uid = uid;

  // collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('services_info');

  // get user data from the database
  Future<DocumentSnapshot> getUserData() async {
    return await userCollection.doc(uid).get();
  }

  // get user data from the database and convert it to a map
  Future<Map<String, dynamic>> getUserDataMap() async {
    return await userCollection.doc(uid).get().then((DocumentSnapshot ds) {
      final data = ds.data();
      // convert data to a Map<String, dynamic>
      return data as Map<String, dynamic>;
    });
  }

  // create user data at the startup of an account
  Future createUserData(Map<String, dynamic> services) async {
    return await userCollection.doc(uid).set(services);
  }

  // modify user data
  Future updateUserData(Map<String, dynamic> services) async {
    return await userCollection.doc(uid).update(services);
  }

  // make a function to append a string to a tab
  Future appendToTab(String tab, String value) async {
    return await userCollection.doc(uid).update({
      tab: FieldValue.arrayUnion([value])
    });
  }

  // make a function to remove a string from a tab
  Future removeFromTab(String tab, String value) async {
    return await userCollection.doc(uid).update({
      tab: FieldValue.arrayRemove([value])
    });
  }

  // make a function that changes a bool value
  Future changeBool(String tab, bool value) async {
    return await userCollection.doc(uid).update({tab: value});
  }

  // USELESS BLOCK OF FCT TO DELETE AT THE END //

  // make a function to get the data of one user depending on the uid
  Future<DocumentSnapshot> getUserDataFromUid(String uid) async {
    return await userCollection.doc(uid).get();
  }
}

UserActive? userActive;

Map<String, dynamic> services = {
  "btc": {
    "isLogged": false,
    "enabled": false,
    "api_key": "",
  },
  "steam": {
    "isLogged": false,
    "enabled": false,
    "api_key": "",
  },
  "weather": {
    "isLogged": true,
    "enabled": false,
    "api_key": "",
  },
  "youtube": {
    "isLogged": true,
    "enabled": false,
    "api_key": "",
  },
  "twitch": {
    "isLogged": false,
    "enabled": false,
    "api_key": "",
  },
  "activatedWidgetId": ["weather", "btc", "youtube"],
};

var debugUid = "2E1CuhK9u1WDnU6J7o2jDFMCK7k1"; // thegoodbash@gmail.com account

var data;

// first the user need to have a map of <String, dynamic> to store all the API keys that we used
// if we click to a button to add a service, I need to make to necessary oauth login methods

/*
  Here is an example of the user flow:
    1. User create an account, through mail, Twitter or Google Oauth:
      - The account is stored in the firebase DB
      - The user log in the dashboard

    2. To add a service, he goes to the services page and get a service list:
      - If the service needs a login, the user can click to the button <Login> and he'll be redirected to the requested oauth :
        -> There, if the connection is successful, the service is added to the user's account in Firebase and the login button change to "Already connected"
        -> If the connection is not successful, do nothing

      - If the service doesn't need a login, the user can click to the Switch button:
          -> There, an API key is going to be generated and the service is added to the user's account in Firebase

    3. To add a widget, the User click on the "+" button on the BOARD page (route : "/"):
      The widgets are going to be presented like this in a floating scrolling list (pseudo-code) :
        if (service.activated == True):
           "SERVICE_NAME:",          
          "
            - Widget n
            - Widget n+1
            ...
          "
          // if you click on widget n, it's just gonna add another box to the board, that you can move around

    WHAT IS THE CURRENT STEP OF THE USER FLOW?:

     Linking the services to the database:

      x. - Twitter Oauth isn't done yet // Twitter is not going to be done yet

*/ 