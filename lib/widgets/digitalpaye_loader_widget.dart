import 'package:digitalpaye_sdk_flutter/guidelines/box_spacing_guidelines.dart';
import 'package:digitalpaye_sdk_flutter/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 350,
              height: 170,
              child: Lottie.asset(
                'assets/animations/loader.json',
                package: "digitalpaye_sdk_flutter",
                height: 170,
                fit: BoxFit.cover,
              ),
            ),
            verticalSpaceRegular,
            Text(
              "Veuillez patienter....",
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: AppColors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            verticalSpaceSmall,
            Text(
              "Nous chargeons la page de paiement pour vous.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.black,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
