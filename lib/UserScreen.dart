import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<String> UserDetails = [];
List<String> UserLists = [];
bool logoutt = false;

void deleteData(name) async {
  SharedPreferences UserDetailspref = await SharedPreferences.getInstance();
  SharedPreferences UserListspref = await SharedPreferences.getInstance();
  UserLists = UserListspref.getStringList("Signinnames")!;
  UserLists.remove(name);
  UserListspref.setStringList("Signinnames", UserLists);
  UserDetailspref.remove(name);
}

class userScreen extends StatefulWidget {
  String? name;
  String? age;
  Object? gend;

  userScreen({Key? key, this.name, this.age, this.gend}) : super(key: key);

  @override
  State<userScreen> createState() => _userScreenState();
}

class _userScreenState extends State<userScreen> {
  saveoriginalnames(name, age, gend) async {
    UserDetails.add("$name");
    UserDetails.add("$age");
    UserDetails.add("$gend");
    SharedPreferences UserDetailspref = await SharedPreferences.getInstance();
    UserDetailspref.setStringList(name, UserDetails);
  }

  @override
  void initState() {
    saveoriginalnames(widget.name, widget.age, widget.gend);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async{
          UserDetails = [];
          return true;
        },
        child: userDetails(
            name: widget.name, age: widget.age, gend: widget.gend!));
  }
}

String? loadname;
String loadage = "Age";
String loadgend = "Gender";

class userSavedDetails extends StatefulWidget {
  String? name;

  userSavedDetails({Key? key, this.name}) : super(key: key);

  @override
  State<userSavedDetails> createState() => _userSavedDetailsState();
}

class _userSavedDetailsState extends State<userSavedDetails> {
  List<String> originaltemp = [];

  Future<void> getsaveoriginalnames(name) async {
    SharedPreferences UserDetailspref = await SharedPreferences.getInstance();
    originaltemp = UserDetailspref.getStringList(name)!;
    setState(() {
      loadname = originaltemp[0];
      loadage = originaltemp[1];
      loadgend = originaltemp[2];
    });
  }

  @override
  void initState() {
    getsaveoriginalnames(widget.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async{
          UserDetails = [];
          return true;
        },
        child: userDetails(name: loadname, age: loadage, gend: loadgend));
  }
}

class userDetails extends StatelessWidget {
  const userDetails({
    Key? key,
    required this.name,
    required this.age,
    required this.gend,
  }) : super(key: key);

  final String? name;
  final String? age;
  final Object gend;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Name : $name",
            style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 30,
                color: Colors.white)),
        Text("Age : $age",
            style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 30,
                color: Colors.white)),
        Text("Gender : $gend",
            style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 30,
                color: Colors.white)),
        SizedBox(
          height: 25,
        ),
        Container(
          width: 125,
          height: 45,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 3, color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
          child: GestureDetector(
            onTap: () {
              deleteData(name);
              logoutt = true;
              Navigator.pop(context);
            },
            child: Center(
                child: Text(
              "Sign Out",
              style: TextStyle(color: Colors.black, fontSize: 20),
            )),
          ),
        ),
      ],
    );
  }
}
