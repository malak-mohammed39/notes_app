import 'package:flutter/material.dart';
import 'home_page.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE8E2E8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 25),
          child: Column(
            children: [
              Spacer(),
              Image.asset('assets/images/task_image.png', height: 300),
              SizedBox(height: 40),

              Text(
                'Create free notes & collaborate\nwith your team',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 30),

              Text(
                'Capture your thoughts, organize your daily tasks, and keep everything in one place',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: const Color.fromARGB(255, 18, 1, 1),
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 159, 147, 181),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Text(
                      "Get Started",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
