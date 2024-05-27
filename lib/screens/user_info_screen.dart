import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:signin/screens/sign_in_screen.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  bool _isSigningOut = false;

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SignInScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Info'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('User Info Screen'),
            SizedBox(height: 16),
            Text('Name: ${widget.user.displayName ?? 'N/A'}'),
            SizedBox(height: 8),
            Text('Email: ${widget.user.email ?? 'N/A'}'),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  _isSigningOut = true;
                });
                await FirebaseAuth.instance.signOut(); // Sign out the user
                setState(() {
                  _isSigningOut = false;
                });
                Navigator.pushReplacement( // Navigate back to the sign-in screen
                  context,
                  _routeToSignInScreen(),
                );
              },
              child: _isSigningOut ? CircularProgressIndicator() : Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
