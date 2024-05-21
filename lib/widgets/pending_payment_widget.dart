import 'package:digitalpaye_sdk_flutter/guidelines/box_spacing_guidelines.dart';
import 'package:digitalpaye_sdk_flutter/interface/digitalpaye_config_interface.dart';
import 'package:digitalpaye_sdk_flutter/models/digitalpaye_response_payment.dart';
import 'package:digitalpaye_sdk_flutter/utils/app_color.dart';
import 'package:digitalpaye_sdk_flutter/utils/function.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PendingPaymentWidget extends StatelessWidget {
  final DigitalpayeResponsePayment responsePayment;
  final DigitalpayeConfigInterface config;
  final VoidCallback callBack;

  const PendingPaymentWidget({
    Key? key,
    required this.responsePayment,
    required this.config,
    required this.callBack,
  }) : super(key: key);

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
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.warningdColor.withOpacity(0.5),
              ),
              child: const Center(
                child: Icon(
                  Icons.check,
                  color: AppColors.white,
                  size: 50,
                ),
              ),
            ),
            verticalSpaceMedium,
            Text(
              "Paiement en attente.",
              style: GoogleFonts.poppins(
                fontSize: 20,
                color: AppColors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            verticalSpaceSmall,
            Text(
              "${formatNumber(int.parse(responsePayment.amount ?? "0"))} ${responsePayment.currency ?? ""}",
              style: GoogleFonts.poppins(
                fontSize: 32,
                color: AppColors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            verticalSpaceSmall,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Référence",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.colorTexte,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                verticalSpaceTiny,
                Text(
                  "${responsePayment.transactionId}",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            verticalSpaceRegular,
            const Divider(
              color: AppColors.greyFFD9D9D9,
            ),
            verticalSpaceSmall,
            Text(
              "Votre paiement est en attente de validation. Veuillez valider la transaction.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: AppColors.black,
                fontWeight: FontWeight.w400,
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
                onPressed: callBack,
                child: Text(
                  "Vérifier le paiement",
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