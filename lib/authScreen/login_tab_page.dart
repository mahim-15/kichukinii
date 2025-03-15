import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kichukini/global/global.dart';
import 'package:kichukini/mainScreen/home_screen.dart';
import 'package:kichukini/splashScreen/my_splash_screen.dart';
import 'package:kichukini/widget/custom_text_field.dart';
import 'package:kichukini/widget/loading_dialog.dart';

class LoginTabPage extends StatefulWidget {
  const LoginTabPage({super.key});

  @override
  State<LoginTabPage> createState() => _LoginTabPageState();
}

class _LoginTabPageState extends State<LoginTabPage> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  validateForm() {
    if (emailTextEditingController.text.isNotEmpty &&
        passwordTextEditingController.text.isNotEmpty) {
      // Allow user to login
      loginNow();
    } else {
      Fluttertoast.showToast(msg: "Please provide email and password");
    }
  }

  loginNow() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingDialogWidget(
            message: "Checking credentials",
          );
        });

    User? currentUser;
    try {
      UserCredential authResult = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim(),
      );
      currentUser = authResult.user;
    } catch (error) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "❌ Login Failed: $error");
      return;
    }

    if (currentUser != null) {
      checkIfUserRecordExists(currentUser);
    }
  }

  checkIfUserRecordExists(User currentUser) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .get()
        .then((record) async {
      if (record.exists) {
        // Status is approved
        if (record.data()!["status"] == "approved") {
          await sharedPreferences!.setString("uid", record.data()!["uid"]);
          await sharedPreferences!.setString("email", record.data()!["email"]);
          await sharedPreferences!.setString("name", record.data()!["name"]);

          List<String> userCartList =
              record.data()!["userCart"].cast<String>();
          await sharedPreferences!.setStringList("userCart", userCartList);

          // Navigate to HomeScreen
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (c) => MySplashScreen()));
        } else {
          FirebaseAuth.instance.signOut();
          Navigator.pop(context);
          Fluttertoast.showToast(
              msg: "You have been BLOCKED by admin.\nContact Admin");
        }
      } else {
        FirebaseAuth.instance.signOut();
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "This record does not exist.");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard when tapping outside
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "images/login.png",
                height: MediaQuery.of(context).size.height * 0.40,
              ),
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
                  // Email Field (Fixed)
                  CustomTextField(
                    textEditingController: emailTextEditingController,
                    iconData: Icons.email,
                    hintText: "Email",
                    isobsecre: false,
                    enabled: true,
                    keyboardType: TextInputType.emailAddress, // Fix applied
                  ),
                  // Password Field
                  CustomTextField(
                    textEditingController: passwordTextEditingController,
                    iconData: Icons.lock,
                    hintText: "Password",
                    isobsecre: true,
                    enabled: true,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                ),
                onPressed: () {
                  FocusScope.of(context).unfocus(); // Hide keyboard before login
                  validateForm();
                },
                child: const Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
