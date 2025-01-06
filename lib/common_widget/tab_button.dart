import 'package:fitness/common/colo_extension.dart';
import 'package:flutter/material.dart';

class TabButton extends StatelessWidget {
  final String icon;
  final String selectIcon;
  final VoidCallback onTap;
  final bool isActive;
  final String title;
  const TabButton(
      {super.key,
      required this.icon,
      required this.selectIcon,
      required this.isActive,
      required this.onTap,
        required this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            isActive ? selectIcon : icon,
            width: 25,
            height: 25,
            fit: BoxFit.fitWidth,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 8,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? TColor.gray : TColor.secondaryColor1,
            ),
          ),
          const SizedBox(height: 8),

        ],
      ),
    );
  }
}
