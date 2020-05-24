import 'package:firebasetest/core/google_signin.dart';
import 'package:firebasetest/model/student.dart';
import 'package:firebasetest/model/user.dart';
import 'package:firebasetest/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FireHomeView extends StatefulWidget {
  FireHomeView({Key key}) : super(key: key);

  @override
  _FireHomeViewState createState() => _FireHomeViewState();
}

class _FireHomeViewState extends State<FireHomeView> {
  FirebaseServices service;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    service = FirebaseServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GoogleSigninHelper.instance.user == null
            ? CircleAvatar()
            : GoogleUserCircleAvatar(
                identity: GoogleSigninHelper.instance.user),
      ),
      body: studentBuilder,
    );
  }

  Widget get studentBuilder => FutureBuilder<List<Student>>(
      future: service.getStudent(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.hasData) {
              return _listStudent(snapshot.data);
            } else {
              return _notFoundWidget;
            }
            break;
          default:
            return _waitingWidget;
        }
      });

  Widget _listStudent(List<Student> list) {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) => _studentCard(list[index]));
  }

  Widget _studentCard(Student student) {
    return Card(
      child: ListTile(
        title: Text(student.name),
        subtitle: Text(student.number.toString()),
      ),
    );
  }

  Widget _listUser(List<User> list) {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) => _userCard(list[index]));
  }

  Widget _userCard(User user) {
    return Card(
      child: ListTile(title: Text(user.name)),
    );
  }

  Widget get _notFoundWidget => Center(
        child: Text("Not Found"),
      );
  Widget get _waitingWidget => Center(
        child: CircularProgressIndicator(),
      );
}
