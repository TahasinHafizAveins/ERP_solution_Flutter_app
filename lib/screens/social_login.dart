import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialLogin extends StatelessWidget {
  const SocialLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Facebook
        IconButton(
          icon: FaIcon(FontAwesomeIcons.facebook, color: Colors.blue),
          iconSize: 36,
          onPressed: () {
            print("Login with Facebook");
            // TODO: Handle Facebook Auth2
          },
        ),
        SizedBox(width: 20),

        // Google
        IconButton(
          icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
          iconSize: 36,
          onPressed: () {
            print("Login with Google");
            // TODO: Handle Google Auth2
          },
        ),
        SizedBox(width: 20),

        // GitHub
        IconButton(
          icon: FaIcon(FontAwesomeIcons.github, color: Colors.black),
          iconSize: 36,
          onPressed: () {
            print("Login with GitHub");
            // TODO: Handle GitHub Auth2
          },
        ),
      ],
    );
  }
}
