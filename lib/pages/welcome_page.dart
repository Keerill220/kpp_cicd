import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFA8DAFF), Color(0xFFC7E9FF)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 60),
              child: Container(
                constraints: BoxConstraints(maxWidth: 345),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 60,
                      offset: Offset(0, 20),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '💧',
                      style: TextStyle(
                        fontSize: 48,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: Offset(2, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Water Tracker',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Stay hydrated, stay healthy',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF666666),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 50),
                    SizedBox(
                      width: 250,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF64B5F6),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 18, horizontal: 60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 8,
                          shadowColor: Color(0xFF64B5F6).withOpacity(0.3),
                        ),
                        child: Text(
                          'LOGIN',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: 250,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RegisterPage()),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Color(0xFF64B5F6),
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 60),
                          side: BorderSide(color: Color(0xFF64B5F6), width: 3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          backgroundColor: Colors.white,
                          elevation: 4,
                          shadowColor: Colors.black.withOpacity(0.1),
                        ),
                        child: Text(
                          'REGISTER',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    Text(
                      '✓ Track your daily water intake\n✓ Achieve your hydration goals\n✓ Stay healthy and energized',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF999999),
                        height: 1.8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
