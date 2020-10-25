import 'package:flutter/material.dart';
import 'package:vokrug/constants.dart';

class MyAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.4,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(100),
          ),
          color: Theme.of(context).primaryColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            Icons.supervised_user_circle,
            color: kTextLightColor,
            size: 100,
          ),
          SizedBox(
            height: 50,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 25),
              child: Text(
                "Login",
                style: TextStyle(color: kTextLightColor, fontSize: 25),
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
