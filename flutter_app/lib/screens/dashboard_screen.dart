import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? _username;
  String? _profilePic;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      setState(() {
        _username = userDoc['username'];
        _profilePic = userDoc['profile_pic'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_profilePic != null)
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(_profilePic!),
              ),
            const SizedBox(height: 16),
            if (_username != null)
              Text('Hello, $_username', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/weather');
              },
              child: const Text('Weather'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/statistics');
              },
              child: const Text('Statistics'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/camera');
              },
              child: const Text('Camera'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/account');
              },
              child: const Text('Account'),
            ),
          ],
        ),
      ),
    );
  }
}
