import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vokrug/UI/app_bar.dart';
import 'package:vokrug/constants.dart';
import 'package:vokrug/UI/home_page.dart';
import 'package:vokrug/db/database.dart';
import 'package:vokrug/models/user.dart';

import 'login_page.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final formKey = GlobalKey<FormState>();
  bool isAutoValidate = false;
  String _login, _password;
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MyAppBar(),
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
                  child: Form(
                    key: formKey,
                    autovalidate: isAutoValidate,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Login',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Вводите логин';
                            }
                            return null;
                          },
                          onSaved: (value) => _login = value,
                          controller: _loginController,
                        ),
                        SizedBox(height: 30),
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Вводите Парол';
                            }
                            return null;
                          },
                          onSaved: (value) => _password = value,
                          controller: _passwordController,
                        ),
                        SizedBox(height: 80),
                        Container(
                          width: double.infinity,
                          height: 50,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            onPressed: validateInputs,
                            color: Theme.of(context).primaryColor,
                            child: Text(
                              'Войти',
                              style: TextStyle(
                                  fontSize: 20, color: kTextLightColor),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            );
                          },
                          child: Text(
                            'Новый пользователь',
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFF9A9BB2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void validateInputs() async {
    User user;
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      print('login ' + _login + 'pas ' + _password);
      user = await DBProvider.db.authUser(_login, _password);
      if (user == null) {
        Fluttertoast.showToast(
            msg: "Нет такого пользователя",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: kPrimaryColor,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        print('success');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(userId: user.id),
          ),
        );
      }
    } else {
      // After input, turn on automatic inspection
      setState(() => isAutoValidate = true);
    }
  }
}
