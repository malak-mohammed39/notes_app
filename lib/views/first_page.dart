import 'package:flutter/material.dart';

import 'home_page.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8E2E8),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),

                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 25,
                    ),

                    child: Column(
                      children: [
                        const Spacer(),

                        Image.asset(
                          'assets/images/task_image.png',
                          height: 350,
                        ),

                        const SizedBox(height: 30),

                        const Text(
                          'Create free notes & collaborate\nwith your team',
                          textAlign: TextAlign.center,

                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          'Capture your thoughts, organize your daily tasks, and keep everything in one place',
                          textAlign: TextAlign.center,

                          style: TextStyle(fontSize: 18, color: Colors.black54),
                        ),

                        const Spacer(),

                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                            );
                          },

                          child: Container(
                            width: double.infinity,
                            height: 55,

                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 159, 147, 181),

                              borderRadius: BorderRadius.circular(25),
                            ),

                            child: const Center(
                              child: Text(
                                "Get Started",

                                style: TextStyle(
                                  color: Colors.white,
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
              ),
            );
          },
        ),
      ),
    );
  }
}
