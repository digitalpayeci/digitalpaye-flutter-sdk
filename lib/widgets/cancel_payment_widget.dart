import 'package:digitalpaye_sdk_flutter/guidelines/box_spacing_guidelines.dart';
import 'package:digitalpaye_sdk_flutter/interface/digitalpaye_config_interface.dart';
import 'package:digitalpaye_sdk_flutter/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CancelPaymentWidget extends StatelessWidget {
  final DigitalpayeConfigInterface config;

  const CancelPaymentWidget({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.errorColor,
              ),
              child: const Center(
                child: Icon(
                  Icons.close,
                  color: AppColors.white,
                  size: 50,
                ),
              ),
            ),
            verticalSpaceMedium,
            Text(
              "Paiement annulé.",
              style: GoogleFonts.poppins(
                fontSize: 20,
                color: AppColors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            verticalSpaceRegular,
            Text(
              "Votre paiement à été annulé.\nVeuillez cliquer sur le bouton ci-dessous pour retourner sur le site du marchand.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.black,
                fontWeight: FontWeight.w300,
              ),
            ),
            verticalSpaceExtraLarge,
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  elevation: MaterialStateProperty.all<double>(0.0),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      config.color ?? AppColors.primaryColor),
                ),
                onPressed: () {
                   Navigator.of(context).pop();
                },
                child: Text(
                  "Retour",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
