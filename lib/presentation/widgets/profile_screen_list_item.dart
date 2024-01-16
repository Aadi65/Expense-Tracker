import 'package:com_cipherschools_assignment/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfileListItem extends StatelessWidget {
  final String title;
  final String iconString;
  final VoidCallback onPressed;

  const ProfileListItem(
      {super.key,
      required this.title,
      required this.iconString,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: h * 0.1067,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: title == 'Logout' ? red20 : violet20,
              ),
              child: SvgPicture.asset(
                iconString,
                color: title == 'Logout' ? red100 : violet100,
                width: 30,
                height: 30,
                fit: BoxFit.scaleDown,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}
