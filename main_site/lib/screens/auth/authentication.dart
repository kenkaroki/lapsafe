import 'package:flutter/material.dart';
import 'package:main_site/screens/auth/login.dart';
import 'package:main_site/screens/auth/signup.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  bool is_login = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          is_login? SizedBox(height: 500, width: (MediaQuery.sizeOf(context).width * 0.8) , child: Login(),) : SizedBox(height: 400,  width: (MediaQuery.sizeOf(context).width * 0.8),
                    child: Signup()),
          TextButton(onPressed: () => setState(() {
            is_login = !is_login;
          }), child: is_login? Text('Dont have an account ? Signup' , style: TextStyle(color: Colors.white),) : Text('Already have an acoount? Login',
                      style: TextStyle(color: Colors.white),
                    ))
        ],
      )),
      backgroundColor: const Color.fromARGB(255, 2, 67, 62),
    );
  }
}
