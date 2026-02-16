import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final VoidCallback onTap;
  final AnimationController anim;

  const MenuButton({super.key, required this.onTap, required this.anim});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: anim,
      builder: (context, child) {
        return FloatingActionButton(
          elevation: 4,
          onPressed: onTap,
          backgroundColor: Colors.blue.shade600,
          child: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: anim,
            color: Colors.white,
            size: 28,
          ),
        );
      },
    );
  }
}
