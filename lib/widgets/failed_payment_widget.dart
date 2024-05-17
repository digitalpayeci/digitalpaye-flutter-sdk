import 'package:digitalpaye_sdk_flutter/enum/enum_type_payment.dart';
import 'package:digitalpaye_sdk_flutter/guidelines/box_spacing_guidelines.dart';
import 'package:digitalpaye_sdk_flutter/interface/digitalpaye_config_interface.dart';
import 'package:digitalpaye_sdk_flutter/models/digitalpaye_response_payment.dart';
import 'package:digitalpaye_sdk_flutter/utils/app_color.dart';
import 'package:digitalpaye_sdk_flutter/utils/function.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FailedPaymentWidget extends StatelessWidget {
  final DigitalpayeResponsePayment responsePayment;
  final DigitalpayeConfigInterface config;

  const FailedPaymentWidget(
      {super.key, required this.responsePayment, required this.config});

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
                shape: BoxShape.circle, color: AppColors.errorColor),
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
            "Paiement échoué.",
            style: GoogleFonts.poppins(
              fontSize: 20,
              color: AppColors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          verticalSpaceSmall,
          Text(
            "${formatNumber(int.parse(responsePayment.amount??""))} ${responsePayment.currency}",
            style: GoogleFonts.poppins(
              fontSize: 32,
              color: AppColors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          verticalSpaceSmall,
          const Divider(
            color: AppColors.greyFFD9D9D9,
          ),
          verticalSpaceSmall,
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "ID de la transaction",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: AppColors.black,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Montant",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: AppColors.black,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    "${formatNumber(int.parse(responsePayment.amount??""))} ${responsePayment.currency}",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: AppColors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              verticalSpaceRegular,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Opérateur",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: AppColors.black,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    EnumTypePayment.from(
                            value: responsePayment.typePayment ??
                                EnumTypePayment.unknown.value)
                        .localizableValue,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: AppColors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              verticalSpaceRegular,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Date",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: AppColors.black,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    "${responsePayment.date}",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: AppColors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
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
    ));
  }
}
