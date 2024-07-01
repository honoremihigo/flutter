import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../styles/style.dart';
import 'dart:io';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  File? _profileImage;
  String _message = '';

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _register() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _message = 'Passwords do not match';
      });
      return;
    }
    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      String? imageUrl;
      if (_profileImage != null) {
        final storageRef = FirebaseStorage.instance.ref().child('profile_pics').child(userCredential.user!.uid);
        await storageRef.putFile(_profileImage!);
        imageUrl = await storageRef.getDownloadURL();
      }
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'username': _usernameController.text,
        'email': _emailController.text,
        'profile_pic': imageUrl,
      });
      await SharedPreferences.getInstance()
        ..setBool('isLoggedIn', true)
        ..setString('username', _usernameController.text);
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      setState(() {
        _message = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                    child: _profileImage == null ? const Icon(Icons.add_a_photo) : null,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _usernameController,
                  decoration: kTextFieldDecoration.copyWith(labelText: 'Username'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  decoration: kTextFieldDecoration.copyWith(labelText: 'Email'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: kTextFieldDecoration.copyWith(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _confirmPasswordController,
                  decoration: kTextFieldDecoration.copyWith(labelText: 'Confirm Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: kButtonStyle,
                  onPressed: _register,
                  child: const Text('Register'),
                ),
                const SizedBox(height: 8),
                Text(_message, style: const TextStyle(color: Colors.red)),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Already have an account? Login', style: kLinkStyle),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
