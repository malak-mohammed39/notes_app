import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/notes_cubit/theme_cubit.dart';
import 'home_page.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state;

    final background = isDark
        ? const Color(0xFF211D23)
        : const Color(0xFFE8E2E8);
    final titleText = isDark ? Colors.white : Colors.black;
    final subtitleText = isDark ? Colors.white70 : Colors.black54;
    final buttonColor = isDark
        ? const Color(0xFF4B3158)
        : const Color.fromARGB(255, 159, 147, 181);

    return Scaffold(
      backgroundColor: background,
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

                        Text(
                          'Create free notes & collaborate\nwith your team',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: titleText,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          'Capture your thoughts, organize your daily tasks, and keep everything in one place',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18, color: subtitleText),
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
                              color: buttonColor,
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
