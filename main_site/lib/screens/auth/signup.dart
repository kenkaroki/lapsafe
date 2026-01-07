import 'package:flutter/material.dart';
import 'package:main_site/screens/auth/authentication.dart';
import 'package:main_site/screens/home/home.dart';
import 'package:main_site/services/api-service.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final email_controller = TextEditingController();
  final password_conroller = TextEditingController();
  bool password_obscure = true;
  String error_text = '';

  void signup(String username, String password) async {
    final api = ApiService();

    try {
      final data = await api.signup(username, password);
      Navigator.push(context, MaterialPageRoute(builder: (_) => Authentication()));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: ListView(
        children: [
          SizedBox(height: 40),
          ListTile(
            title: Text(
              "SIGNUP",
              style: TextStyle(
                fontSize: 28,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20),
          ListTile(
            title: TextField(
              controller: email_controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Color.fromARGB(255, 2, 78, 78)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Color(0xFF6B1B9A), width: 2),
                ),
                hint: Text('Email'),
                hintStyle: TextStyle(color: Colors.black),
                icon: Icon(Icons.email, color: Colors.black),
              ),
            ),
          ),
          SizedBox(height: 20),
          ListTile(
            title: TextField(
              controller: password_conroller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Color.fromARGB(255, 2, 78, 78)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Color(0xFF6B1B9A), width: 2),
                ),
                hint: Text('Password'),
                hintStyle: TextStyle(color: Colors.black),
                icon: Icon(Icons.lock, color: Colors.black),
                suffix: IconButton(
                  onPressed: () => setState(() {
                    password_obscure = !password_obscure;
                  }),
                  icon: password_obscure
                      ? Icon(Icons.visibility)
                      : Icon(Icons.visibility_off),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          ListTile(
            title: ElevatedButton(
              onPressed: () {
                signup(email_controller.text, password_conroller.text);
              },
              child: Text("SignUp", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 2, 78, 78),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
