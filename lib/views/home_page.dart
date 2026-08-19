import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Colors
  // Background
  static const Color backgroundColor = Color(0xFFE8E2E8);

  // Main card
  static const Color cardColor = Color(0xFFC5B8C9);

  // Main purple
  static const Color purple = Color(0xFF8B5FA8);

  // Dark purple
  static const Color darkPurple = Color(0xFF68447D);

  // Search
  static const Color lightPurple = Color(0xFFD8CEDA);

  // Text
  static const Color textColor = Color(0xFF29222B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'ALL NOTES',
          style: TextStyle(
            color: textColor,
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
               color: darkPurple,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const TextField(
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: 'Search notes...',
                  hintStyle: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                ),
              ),
            ),

            const Spacer(),

            
            
            

            Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(12),

                
                highlightColor: darkPurple.withOpacity(0.35),

               
                splashColor: purple.withOpacity(0.45),

                child: Ink(
                  width: 600,
                  height: 50,
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.18),
                        blurRadius: 7,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      SizedBox(width: 15),

                      Icon(
                        Icons.delete,
                        color: darkPurple,
                      ),

                      Expanded(
                        child: Center(
                          child: Text(
                            'SHOW DELETED NOTES',
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 40),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

           
            Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(12),

                highlightColor: darkPurple.withOpacity(0.35),

               
                splashColor: purple.withOpacity(0.45),

                child: Ink(
                  width: 600,
                  height: 50,
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.18),
                        blurRadius: 7,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      SizedBox(width: 15),

                      Icon(
                        Icons.favorite,
                        color: darkPurple,
                      ),

                      Expanded(
                        child: Center(
                          child: Text(
                            'SHOW FAVOURITE NOTES',
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 40),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),

      

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: purple,
        elevation: 8,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}