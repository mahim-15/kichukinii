import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kichukini/mainScreen/home_screen.dart';
import 'package:kichukini/splashScreen/my_splash_screen.dart';
import 'package:kichukini/widget/custom_text_field.dart';
import 'package:kichukini/widget/loading_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationTabPage extends StatefulWidget {
  const RegistrationTabPage({super.key});

  @override
  State<RegistrationTabPage> createState() => _RegistrationTabPageState();
}

class _RegistrationTabPageState extends State<RegistrationTabPage> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController confirmPasswordEditingController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  SharedPreferences? sharedPreferences;
  File? _image; // Variable to store selected image

  /// Function to pick image from gallery
  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  /// Form validation and user registration
  Future<void> _validateAndRegister() async {
    if (passwordTextEditingController.text != confirmPasswordEditingController.text) {
      Fluttertoast.showToast(msg: "⚠️ Passwords do not match.");
      return;
    }

    if (nameTextEditingController.text.isEmpty ||
        emailTextEditingController.text.isEmpty ||
        passwordTextEditingController.text.isEmpty ||
        confirmPasswordEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "⚠️ Please fill all fields.");
      return;
    }
    showDialog(
      context: context,
       builder: (c){
        return LoadingDialogWidget(
          message: "Registering your account",

        );

       });
    // Register user
    await _registerUser();
  }

  /// Registers user with Firebase Authentication
  Future<void> _registerUser() async {
    User? currentUser;

    try {
      UserCredential authResult = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim(),
      );
      currentUser = authResult.user;
    } catch (error) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "❌ Registration Failed: $error");
      return;
    }

    if (currentUser != null) {
      await _saveUserToFirestore(currentUser);
    }
  }

  /// Saves user data to Firestore and locally (excluding image)
  Future<void> _saveUserToFirestore(User currentUser) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // User Data Map (excluding image)
      Map<String, dynamic> userData = {
        "uid": currentUser.uid,
        "email": currentUser.email,
        "name": nameTextEditingController.text.trim(),
        "status": "approved",
        "userCart": ["initialValue"],
      };

      // Save user data in Firestore
      await firestore.collection("users").doc(currentUser.uid).set(userData);
      Fluttertoast.showToast(msg: "✅ Registration Successful!");

      // Save user data locally
      sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences!.setString("uid", currentUser.uid);
      await sharedPreferences!.setString("email", currentUser.email!);
      await sharedPreferences!.setString("name", nameTextEditingController.text.trim());
      await sharedPreferences!.setStringList("userCart", ["initialValue"]);

      Navigator.push(context,MaterialPageRoute(builder: (c)=>MySplashScreen()));

      print("✅ User data saved successfully in Firestore!");
    } catch (error) {
      Fluttertoast.showToast(msg: "🔥 Firestore Save Error: $error");
      print("🔥 Firestore Save Error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 12),

          /// Profile Image Picker (Only for UI, NOT uploaded)
          GestureDetector(
            onTap: _pickImage,
            child: CircleAvatar(
              radius: MediaQuery.of(context).size.width * 0.20,
              backgroundColor: Colors.grey[300],
              backgroundImage: _image != null ? FileImage(_image!) : null,
              child: _image == null
                  ? Icon(
                      Icons.add_photo_alternate,
                      color: Colors.grey[700],
                      size: MediaQuery.of(context).size.width * 0.20,
                    )
                  : null, // Hide icon if image selected
            ),
          ),

          const SizedBox(height: 12),

          /// Form Fields
          Form(
            key: formKey,
            child: Column(
              children: [
                CustomTextField(
                  textEditingController: nameTextEditingController,
                  iconData: Icons.person,
                  hintText: "Name",
                  isobsecre: false,
                  enabled: true,
                ),
                CustomTextField(
                  textEditingController: emailTextEditingController,
                  iconData: Icons.email,
                  hintText: "Email",
                  isobsecre: false,
                  enabled: true,
                ),
                CustomTextField(
                  textEditingController: passwordTextEditingController,
                  iconData: Icons.lock,
                  hintText: "Password",
                  isobsecre: true,
                  enabled: true,
                ),
                CustomTextField(
                  textEditingController: confirmPasswordEditingController,
                  iconData: Icons.lock,
                  hintText: "Confirm Password",
                  isobsecre: true,
                  enabled: true,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          /// Sign Up Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pinkAccent,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
            ),
            onPressed: _validateAndRegister,
            child: const Text(
              "Sign Up",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
