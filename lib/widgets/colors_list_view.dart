import 'package:flutter/material.dart';

class ColorsListView extends StatefulWidget {
  final Function(Color) onColorSelected;
  final int initialColor;

  const ColorsListView({
    super.key,
    required this.onColorSelected,
    this.initialColor = 0xFFC5B8C9,
  });

  @override
  State<ColorsListView> createState() => _ColorsListViewState();
}

class _ColorsListViewState extends State<ColorsListView> {
  final List<Color> colors = const [
    Color(0xFFC5B8C9), // الموف الافتراضي
    Color(0xFFFFAB91), // خوخي
    Color(0xFFFFCC80), // برتقالي فاتح
    Color(0xFFE6EE9C), // ليموني
    Color(0xFF80CBC4), // تيل
    Color(0xFF90CAF9), // سماوي
    Color(0xFFF48FB1), // وردي
  ];

  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = colors.indexWhere((c) => c.value == widget.initialColor);
    if (selectedIndex == -1) selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38 * 2,
      child: ListView.builder(
        itemCount: colors.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
                widget.onColorSelected(colors[index]);
              },
              child: CircleAvatar(
                radius: 20,
                backgroundColor: colors[index],
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.black87)
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }
}
