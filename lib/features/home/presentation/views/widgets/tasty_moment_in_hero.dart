import 'package:demix/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class TastyMomentsInHero extends StatelessWidget {
  const TastyMomentsInHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -.10,
      child: SizedBox(
        width: 82,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'Tasty',
              style: TextStyle(
                fontSize: 21,
                height: .85,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Text(
              'Moments',
              style: TextStyle(
                fontSize: 18,
                height: .83,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Text(
              'Everyday',
              style: TextStyle(
                fontSize: 19,
                height: .9,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              width: 54,
              height: 2.5,
              margin: const EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
