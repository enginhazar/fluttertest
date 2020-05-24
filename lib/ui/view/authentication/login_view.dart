import 'package:firebasetest/core/google_signin.dart';
import 'package:firebasetest/core/helper/shared_manager.dart';
import 'package:firebasetest/model/firebase_auth_error.dart';
import 'package:firebasetest/model/user_Login_Request.dart';
import 'package:firebasetest/services/firebase_service.dart';
import 'package:firebasetest/ui/view/home/firebase_home.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  LoginView({Key key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  String userName;
  String password;
  FirebaseServices service = new FirebaseServices();
  GlobalKey<ScaffoldState> scaffold = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((value) {
      if (SharedManager.instance.getString(SharedEnum.TOKEN).isNotEmpty) {
        navigateToHome();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffold,
        floatingActionButton: FloatingActionButton(
          heroTag: "tag1",
          onPressed: () {
            GoogleSigninHelper.instance.signOut();
          },
          child: Icon(Icons.exit_to_app),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                userNameTextField(),
                SizedBox(height: 10),
                passwordTextField(),
                SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children: <Widget>[
                    FloatingActionButton.extended(
                      heroTag: "Tag2",
                      onPressed: () async {
                        var data = await GoogleSigninHelper.instance.signin();
                        if (data != null) {
                          var user = await GoogleSigninHelper.instance
                              .firebaseSignin();
                        }
                      },
                      backgroundColor: Colors.green,
                      label: Text("Google Login"),
                      icon: Icon(Icons.outlined_flag),
                    ),
                    customLoginFabbButton(context),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  void navigateToHome() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => FireHomeView()));
  }

  FloatingActionButton customLoginFabbButton(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: "Tag3",
      onPressed: () async {
        var result = await service.postUser(UserLoginRequest(
            email: userName, password: password, returnSecureToken: true));
        if (result is FirebaseAuthError) {
          scaffold.currentState
              .showSnackBar(SnackBar(content: Text(result.error.message)));
        } else {
          navigateToHome();
        }
      },
      label: Text("Login"),
      icon: Icon(Icons.android),
    );
  }

  TextField passwordTextField() {
    return TextField(
      onChanged: (val) {
        setState(() {
          password = val;
        });
      },
      decoration:
          InputDecoration(border: OutlineInputBorder(), labelText: "Password"),
    );
  }

  TextField userNameTextField() {
    return TextField(
      onChanged: (val) {
        setState(() {
          userName = val;
        });
      },
      decoration:
          InputDecoration(border: OutlineInputBorder(), labelText: "User Name"),
    );
  }
}
