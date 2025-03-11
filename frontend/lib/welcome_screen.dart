import 'package:flutter/material.dart';
import 'package:frontend/custom_scaffold.dart';
import 'package:frontend/sign_in_page.dart';
import 'package:frontend/sign_up_page.dart';
import 'package:frontend/welcome_btn.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          Flexible(
              flex: 8,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                child: Center(
                    child: RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(children: [
                          TextSpan(
                              text: "Welcome to Spendora!\n\n",
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                color: Colors.black,
                              )),
                          TextSpan(
                              text: "Balance your spending, elevate your aura\n",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ))
                        ]))),
              )),
          Flexible(
              flex: 1,
              child: Container(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    children: [
                      Expanded(
                          child: WelcomeButton(
                        btnText: "Sign Up",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpPage()),
                          );
                        },
                        color: Colors.transparent,
                        textColor: Colors.black,
                      )),
                      Expanded(
                          child: WelcomeButton(
                        btnText: "Log In",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignInPage()),
                          );
                        },
                        color: Colors.white,
                        textColor: Colors.green,
                      )),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
