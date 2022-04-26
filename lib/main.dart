import 'dart:convert';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:user_mock/UserScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<String> originalnames = [];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(appBarTheme: AppBarTheme(color: Colors.black)),
        home: UserList());
  }
}

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  String ?age = null;
  Object ?gend = null;
  List<String> ?originaltemp;

  saveoriginalnames(originalname) async {
    originalnames.add("$originalname");
    SharedPreferences originalnamespref = await SharedPreferences.getInstance();
    originalnamespref.setStringList("Signinnames", originalnames);
  }

  getsaveoriginalnames() async {
    SharedPreferences originalnamespref = await SharedPreferences.getInstance();
    originaltemp = originalnamespref.getStringList("Signinnames") ?? null;
    if(originaltemp != null){
      setState(() {
        originalnames = originaltemp!;
      });
    }
  }

  @override
  void initState() {
    getsaveoriginalnames();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 10,
          centerTitle: true,
          title: Text("Users List"),
        ),
        backgroundColor: Colors.white10,
        body: FutureBuilder(
            future: DefaultAssetBundle.of(context)
                .loadString("asset/testfile.json"),
            builder: (context, snapshot) {
              var data = json.decode(snapshot.data.toString());
              if (data == null) {
                return Center(
                  child: Text(
                    "Loading...",
                  ),
                );
              } else {
                int len = data[0]["users"].length;
                return Container(
                  child: ListView.builder(
                      itemCount: len,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                              color: Colors.deepOrange[500],
                              border: Border.all(
                                width: 2,
                              ),
                              borderRadius:
                              BorderRadius.all(Radius.circular(15))),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text(
                                    "${data[0]["users"][index]["name"]}",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white)),
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 95,
                                    height: 35,
                                    decoration: BoxDecoration(
                                        color: "${data[0]["users"][index]["atype"]}" ==
                                            "Temproary" ? Colors.grey : Colors
                                            .white,
                                        border: Border.all(
                                            width: 3,
                                            color: "${data[0]["users"][index]["atype"]}" ==
                                                "Temproary" ? Colors.white : Colors.grey),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30.0))),
                                    child: Center(
                                        child: Text(
                                          "${data[0]["users"][index]["atype"]}",
                                          style: TextStyle(
                                            color: "${data[0]["users"][index]["atype"]}" ==
                                                "Temproary"
                                                ? Colors.white
                                                : Colors.black,),
                                        )),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if(originalnames.contains("${data[0]["users"][index]["name"]}") == false){
                                        age = null;
                                        gend = null;
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Dialog(
                                                elevation: 10,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(20.0)),
                                                child: Container(
                                                  height: 170,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(12.0),
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors.black26,
                                                              borderRadius: BorderRadius.circular(15)
                                                          ),
                                                          height: 40,
                                                          width: MediaQuery.of(context).size.width * 0.7,
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left: 15),
                                                            child: TextFormField(
                                                              onChanged: (ss){
                                                                age = ss;
                                                              },
                                                              keyboardType: TextInputType.number,
                                                              cursorColor: Colors.black,
                                                              decoration: InputDecoration(
                                                                border: InputBorder.none,
                                                                hintText: 'Enter Age',
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 10),
                                                        DropDown(
                                                            items: ["Male", "Female", "Other"],
                                                            hint: Text("Select Gender"),
                                                            icon: Icon(
                                                              Icons.expand_more,
                                                              color: Colors.black,
                                                            ),
                                                            onChanged: (s){
                                                              gend = s;
                                                            }
                                                        ),
                                                        SizedBox(height: 10),
                                                        Container(
                                                          width: 95,
                                                          height: 35,
                                                          decoration: BoxDecoration(
                                                              color: Colors.deepOrange,
                                                              border: Border.all(
                                                                  width: 2, color: Colors.black26),
                                                              borderRadius: BorderRadius.all(
                                                                  Radius.circular(30.0))),
                                                          child: GestureDetector(
                                                            onTap: () =>
                                                            {
                                                              saveoriginalnames("${data[0]["users"][index]["name"]}"),
                                                              age != null && gend != null ?
                                                              Navigator.push(context,MaterialPageRoute(builder: (context) => userScreen(name: data[0]["users"][index]["name"],age: age,gend: gend!))).then((value) => {
                                                                setState((){})
                                                              })
                                                                  : Fluttertoast.showToast(msg: 'Enter Details',toastLength: Toast.LENGTH_SHORT),
                                                            },
                                                            child: Center(
                                                                child: Text("Sign In",
                                                                  style: TextStyle(color: Colors.black),
                                                                )),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            });
                                      }
                                      else{
                                        Navigator.push(context,MaterialPageRoute(builder: (context) => userSavedDetails(name: data[0]["users"][index]["name"]))).then((value) => {
                                          setState((){
                                            if(logoutt){
                                                      age = null;
                                                      gend = null;
                                                      originalnames.remove(data[0]["users"][index]["name"]);
                                                    }
                                                  })
                                        });
                                      }
                                    },
                                    child: Container(
                                      width: 95,
                                      height: 35,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              width: 3, color: Colors.grey),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30.0))),
                                      child: Center(
                                          child: Text(
                                            originalnames.contains("${data[0]["users"][index]["name"]}") ? "Sign Out": "Sign In",
                                            style: TextStyle(
                                                color: Colors.black),
                                          )),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      }),
                );
              }
            }));
  }
}
