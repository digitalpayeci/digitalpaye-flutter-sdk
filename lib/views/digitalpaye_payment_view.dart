import 'dart:async';
import 'package:digitalpaye_sdk_flutter/enum/enum_status_payment.dart';
import 'package:digitalpaye_sdk_flutter/enum/enum_type_payment.dart';
import 'package:digitalpaye_sdk_flutter/guidelines/box_spacing_guidelines.dart';
import 'package:digitalpaye_sdk_flutter/interface/digitalpaye_config_interface.dart';
import 'package:digitalpaye_sdk_flutter/models/digitalpaye_payment_config.dart';
import 'package:digitalpaye_sdk_flutter/models/digitalpaye_response_payment.dart';
import 'package:digitalpaye_sdk_flutter/repository/digitalpaye_repository.dart';
import 'package:digitalpaye_sdk_flutter/utils/app_color.dart';
import 'package:digitalpaye_sdk_flutter/utils/function.dart';
import 'package:digitalpaye_sdk_flutter/view_model/payment_view_model.dart';
import 'package:digitalpaye_sdk_flutter/widgets/cancel_payment_widget.dart';
import 'package:digitalpaye_sdk_flutter/widgets/failed_payment_widget.dart';
import 'package:digitalpaye_sdk_flutter/widgets/pending_payment_widget.dart';
import 'package:digitalpaye_sdk_flutter/widgets/success_payment_widget.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class DigitalpayePaymentView extends StatefulWidget {
  final DigitalpayePaymentConfig payment;
  final DigitalpayeConfigInterface config;
  final String accessToken;
  final Widget Function(DigitalpayeResponsePayment)? pendingBuilder;
  final Widget Function(DigitalpayeResponsePayment)? successBuilder;
  final Widget Function(DigitalpayeResponsePayment)? errorBuilder;
  const DigitalpayePaymentView({
    super.key,
    required this.config,
    required this.accessToken,
    this.successBuilder,
    this.pendingBuilder,
    this.errorBuilder,
    required this.payment,
  });

  @override
  DigitalpayePaymentViewState createState() => DigitalpayePaymentViewState();
}

class DigitalpayePaymentViewState extends State<DigitalpayePaymentView> {
  late final PaymentViewModel _viewModel =
      PaymentViewModel(repository: DigitalpayeRepository(widget.config));
  DigitalpayePaymentConfig get _payment => widget.payment;
  TextEditingController otpController = TextEditingController();
  TextEditingController customerNameController = TextEditingController();
  TextEditingController customerEmailController = TextEditingController();
  TextEditingController customerPhoneController = TextEditingController();
  @override
  void initState() {
    _viewModel.phone = _payment.customerId ?? "";
    _viewModel.name = _payment.nameUser ?? "";
    _viewModel.email = _payment.emailUser ?? "";
    customerNameController.text = _viewModel.name ?? "";
    customerPhoneController.text = _viewModel.phone ?? "";
    customerEmailController.text = _viewModel.email ?? "";
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.onPending = (bool value) {
        _viewModel.startStatusPolling(
            context: context, token: widget.accessToken);
      };
      _viewModel.onFailed = (value) {
        widget.errorBuilder?.call(value);
      };
      _viewModel.onSuccessful = (value) {
        widget.successBuilder?.call(value);
      };
      _viewModel.onCancelPending = (value) {
        widget.pendingBuilder?.call(value);
      };
      _viewModel.onError = (bool value) {
        Future.delayed(const Duration(seconds: 3), () async {
          _viewModel.showError = false;
          _viewModel.messageError = null;
        });
      };
    });
    super.initState();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isBackgroundColorBlack =
        (widget.config.color ?? AppColors.white) == AppColors.primaryColor;

    final defaultPinTheme = PinTheme(
      width: 60,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Colors.black,
        fontWeight: FontWeight.bold,
        height: 1.4,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.greyFFD9D9D9,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
    );
    final focusedPinTheme = PinTheme(
      width: 60,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Colors.black,
        fontWeight: FontWeight.bold,
        height: 1.4,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.primaryColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    return ChangeNotifierProvider<PaymentViewModel>.value(
      value: _viewModel,
      key: widget.key,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: widget.config.color ?? AppColors.white,
          elevation: 0,
          title: Text(
            "Retour",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: isBackgroundColorBlack ? AppColors.white : AppColors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: isBackgroundColorBlack ? AppColors.white : AppColors.black,
            ),
            onPressed: () {
              if (_viewModel.interfacePayment == null) {
                Navigator.of(context).pop();
              } else {
                _viewModel.interfacePayment = null;
              }
            },
          ),
        ),
        body: Consumer<PaymentViewModel>(
          builder: (context, model, child) => Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    (_viewModel.statusPayment == EnumStatusPayment.cancel)
                        ? CancelPaymentWidget(
                            config: widget.config,
                          )
                        : (_viewModel.statusPayment ==
                                EnumStatusPayment.pending)
                            ? widget.pendingBuilder
                                    ?.call(_viewModel.responsePayment!) ??
                                PendingPaymentWidget(
                                  responsePayment: _viewModel.responsePayment!,
                                  config: widget.config,
                                  callBack: () {
                                    _viewModel.getStatusPayment(
                                        token: widget.accessToken);
                                  },
                                )
                            : (_viewModel.statusPayment ==
                                    EnumStatusPayment.successful)
                                ? widget.successBuilder
                                        ?.call(_viewModel.responsePayment!) ??
                                    SuccessPaymentWidget(
                                      responsePayment:
                                          _viewModel.responsePayment!,
                                      config: widget.config,
                                    )
                                : (_viewModel.statusPayment ==
                                        EnumStatusPayment.failed)
                                    ? widget.errorBuilder?.call(
                                            _viewModel.responsePayment!) ??
                                        FailedPaymentWidget(
                                          responsePayment:
                                              _viewModel.responsePayment!,
                                          config: widget.config,
                                        )
                                    : Column(
                                        children: [
                                          _viewModel.interfacePayment ==
                                                  EnumTypePayment.orange.value
                                              ? Container(
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  color: AppColors.white,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          if (_viewModel
                                                              .showError)
                                                            AnimatedOpacity(
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          300),
                                                              opacity: _viewModel
                                                                      .showError
                                                                  ? 1.0
                                                                  : 0.0,
                                                              child: Container(
                                                                height: 50,
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(5),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: AppColors
                                                                      .dangerColor,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                                child: Row(
                                                                  children: [
                                                                    const Icon(
                                                                      CupertinoIcons
                                                                          .info,
                                                                      color: AppColors
                                                                          .white,
                                                                    ),
                                                                    horizontalSpaceSmall,
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        "${_viewModel.messageError}",
                                                                        style: GoogleFonts
                                                                            .poppins(
                                                                          fontSize:
                                                                              14,
                                                                          color:
                                                                              AppColors.white,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          verticalSpaceRegular,
                                                          Center(
                                                            child: Image.asset(
                                                              width: 50,
                                                              _viewModel
                                                                      .selectedPayment
                                                                      ?.svgSelected ??
                                                                  "",
                                                              package:
                                                                  "digitalpaye_sdk_flutter",
                                                            ),
                                                          ),
                                                          verticalSpaceRegular,
                                                          Text(
                                                            "Confirmer la transaction",
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize: 20,
                                                              color: AppColors
                                                                  .black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                          verticalSpaceRegular,
                                                          Container(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            alignment: Alignment
                                                                .center,
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(5),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: const Color(
                                                                  0xFFF4A50C),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                const Icon(
                                                                  CupertinoIcons
                                                                      .info,
                                                                  color:
                                                                      AppColors
                                                                          .white,
                                                                ),
                                                                horizontalSpaceSmall,
                                                                Expanded(
                                                                  child: Text(
                                                                    "Composez #144*82# pour générer un code à 4 chiffres afin de valider la transaction.",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                      fontSize:
                                                                          14,
                                                                      color: AppColors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          verticalSpaceLarge,
                                                          Pinput(
                                                            length: 4,
                                                            defaultPinTheme:
                                                                defaultPinTheme,
                                                            focusedPinTheme:
                                                                focusedPinTheme,
                                                            listenForMultipleSmsOnAndroid:
                                                                true,
                                                            controller:
                                                                otpController,
                                                            pinAnimationType:
                                                                PinAnimationType
                                                                    .none,
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            inputFormatters: <TextInputFormatter>[
                                                              LengthLimitingTextInputFormatter(
                                                                  4),
                                                              FilteringTextInputFormatter
                                                                  .digitsOnly
                                                            ],
                                                            showCursor: true,
                                                            onChanged: (value) {
                                                              _viewModel
                                                                      .codePin =
                                                                  value;
                                                            },
                                                          ),
                                                          verticalSpaceLarge,
                                                          SizedBox(
                                                            height: 50,
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child:
                                                                ElevatedButton(
                                                              style:
                                                                  ButtonStyle(
                                                                shape: MaterialStateProperty
                                                                    .all<
                                                                        RoundedRectangleBorder>(
                                                                  RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                  ),
                                                                ),
                                                                elevation:
                                                                    MaterialStateProperty
                                                                        .all<double>(
                                                                            0.0),
                                                                backgroundColor:
                                                                    MaterialStateProperty
                                                                        .all<
                                                                            Color>(
                                                                  _viewModel
                                                                          .buttomOrangeMoneyisEnabled
                                                                      ? widget.config
                                                                              .color ??
                                                                          AppColors
                                                                              .primaryColor
                                                                      : AppColors
                                                                          .greyFFD9D9D9,
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                if (_viewModel
                                                                    .buttomOrangeMoneyisEnabled) {
                                                                  _viewModel.createPayment(
                                                                      token: widget
                                                                          .accessToken,
                                                                      params: widget
                                                                          .payment);
                                                                }
                                                              },
                                                              child: Text(
                                                                "Payer maintenant",
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontSize: 14,
                                                                  color:
                                                                      AppColors
                                                                          .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          verticalSpaceExtraLarge,
                                                          MouseRegion(
                                                            cursor:
                                                                SystemMouseCursors
                                                                    .click,
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: Text(
                                                                "Annuler la transaction",
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontSize: 14,
                                                                  color:
                                                                      AppColors
                                                                          .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : _viewModel.interfacePayment ==
                                                      EnumTypePayment.mtn.value
                                                  ? Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20),
                                                      color: AppColors.white,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          if (_viewModel
                                                              .showError)
                                                            AnimatedOpacity(
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          300),
                                                              opacity: _viewModel
                                                                      .showError
                                                                  ? 1.0
                                                                  : 0.0,
                                                              child: Container(
                                                                height: 50,
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(5),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: AppColors
                                                                      .dangerColor,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                                child: Row(
                                                                  children: [
                                                                    const Icon(
                                                                      CupertinoIcons
                                                                          .info,
                                                                      color: AppColors
                                                                          .white,
                                                                    ),
                                                                    horizontalSpaceSmall,
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        "${_viewModel.messageError}",
                                                                        style: GoogleFonts
                                                                            .poppins(
                                                                          fontSize:
                                                                              14,
                                                                          color:
                                                                              AppColors.white,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          verticalSpaceRegular,
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Center(
                                                                child:
                                                                    Image.asset(
                                                                  width: 50,
                                                                  _viewModel
                                                                          .selectedPayment
                                                                          ?.svgSelected ??
                                                                      "",
                                                                  package:
                                                                      "digitalpaye_sdk_flutter",
                                                                ),
                                                              ),
                                                              verticalSpaceRegular,
                                                              Text(
                                                                "Confirmer la transaction",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontSize: 20,
                                                                  color:
                                                                      AppColors
                                                                          .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                              verticalSpaceRegular,
                                                              SizedBox(
                                                                width: 400,
                                                                child: Text(
                                                                  "Pour confirmer la transaction, veuillez composer cette syntaxe et suivez les instructions.",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontSize:
                                                                        14,
                                                                    color: AppColors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                  ),
                                                                ),
                                                              ),
                                                              verticalSpaceMedium,
                                                              DottedBorder(
                                                                dashPattern: const [
                                                                  10,
                                                                  20
                                                                ],
                                                                strokeWidth: 1,
                                                                borderType:
                                                                    BorderType
                                                                        .RRect,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(8),
                                                                radius:
                                                                    const Radius
                                                                        .circular(
                                                                        30),
                                                                child:
                                                                    Container(
                                                                  width: 400,
                                                                  height: 100,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: AppColors
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            30),
                                                                  ),
                                                                  child: Text(
                                                                    "*133#",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                      fontSize:
                                                                          32,
                                                                      color: AppColors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              verticalSpaceExtraLarge,
                                                              SizedBox(
                                                                height: 50,
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                child:
                                                                    ElevatedButton(
                                                                  style:
                                                                      ButtonStyle(
                                                                    shape: MaterialStateProperty
                                                                        .all<
                                                                            RoundedRectangleBorder>(
                                                                      RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8),
                                                                      ),
                                                                    ),
                                                                    elevation: MaterialStateProperty
                                                                        .all<double>(
                                                                            0.0),
                                                                    backgroundColor: MaterialStateProperty.all<
                                                                            Color>(
                                                                        AppColors
                                                                            .primaryColor),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    _viewModel.getStatusPayment(
                                                                        token: widget
                                                                            .accessToken);
                                                                  },
                                                                  child: Text(
                                                                    "Vérifier le paiement",
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                      fontSize:
                                                                          14,
                                                                      color: AppColors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              verticalSpaceExtraLarge,
                                                              MouseRegion(
                                                                cursor:
                                                                    SystemMouseCursors
                                                                        .click,
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child: Text(
                                                                    "Annuler la transaction",
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                      fontSize:
                                                                          14,
                                                                      color: AppColors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20),
                                                      color: AppColors.white,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              ClipOval(
                                                                child: widget
                                                                            .config
                                                                            .logo !=
                                                                        null
                                                                    ? Image
                                                                        .asset(
                                                                        widget
                                                                            .config
                                                                            .logo!,
                                                                        width:
                                                                            70.0,
                                                                        height:
                                                                            70.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      )
                                                                    : Image
                                                                        .asset(
                                                                        "assets/images/digitalpaye.png",
                                                                        width:
                                                                            70.0,
                                                                        height:
                                                                            70.0,
                                                                        package:
                                                                            "digitalpaye_sdk_flutter",
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                              ),
                                                              verticalSpaceSmall,
                                                              Text(
                                                                "${formatNumber(widget.payment.amount.toInt())} ${widget.payment.currency.value}",
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontSize: 32,
                                                                  color:
                                                                      AppColors
                                                                          .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                ),
                                                              ),
                                                              verticalSpaceTiny,
                                                              Text(
                                                                widget.payment
                                                                    .designation,
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontSize: 14,
                                                                  color: AppColors
                                                                      .colorTexte,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                              ),
                                                              verticalSpaceTiny,
                                                              Text(
                                                                "Ref: ${widget.payment.transactionId}",
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontSize: 14,
                                                                  color: AppColors
                                                                      .colorTexte,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                ),
                                                              ),
                                                              verticalSpaceSmall,
                                                            ],
                                                          ),
                                                          verticalSpaceRegular,
                                                          if (_viewModel
                                                              .showError)
                                                            AnimatedOpacity(
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          300),
                                                              opacity: _viewModel
                                                                      .showError
                                                                  ? 1.0
                                                                  : 0.0,
                                                              child: Container(
                                                                height: 50,
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(5),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: AppColors
                                                                      .dangerColor,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                                child: Row(
                                                                  children: [
                                                                    const Icon(
                                                                      Icons
                                                                          .info,
                                                                      color: AppColors
                                                                          .white,
                                                                    ),
                                                                    horizontalSpaceSmall,
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        "${_viewModel.messageError}",
                                                                        style: GoogleFonts
                                                                            .poppins(
                                                                          fontSize:
                                                                              14,
                                                                          color:
                                                                              AppColors.white,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          verticalSpaceRegular,
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "Sélectionner un moyen de paiement",
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontSize: 16,
                                                                  color:
                                                                      AppColors
                                                                          .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                              verticalSpaceRegular,
                                                              Row(
                                                                children: List
                                                                    .generate(
                                                                  _viewModel
                                                                      .paymentTypes
                                                                      .length,
                                                                  (index) =>
                                                                      Row(
                                                                    children: [
                                                                      MouseRegion(
                                                                        cursor:
                                                                            SystemMouseCursors.click,
                                                                        child:
                                                                            GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            _viewModel.selectPayment(_viewModel.paymentTypes[index]);
                                                                          },
                                                                          child:
                                                                              Image.asset(
                                                                            width:
                                                                                55,
                                                                            package:
                                                                                "digitalpaye_sdk_flutter",
                                                                            key:
                                                                                UniqueKey(),
                                                                            _viewModel.selectedPayment?.value == _viewModel.paymentTypes[index].value
                                                                                ? _viewModel.paymentTypes[index].svgSelected
                                                                                : _viewModel.paymentTypes[index].svgUnSelected,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      horizontalSpaceRegular,
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              verticalSpaceRegular,
                                                              Text(
                                                                "Nom complet",
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontSize: 14,
                                                                  color:
                                                                      AppColors
                                                                          .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                              ),
                                                              verticalSpaceSmall,
                                                              Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                height: 50,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                    color: AppColors
                                                                        .greyFFD9D9D9,
                                                                    width: 1,
                                                                  ),
                                                                  color:
                                                                      AppColors
                                                                          .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                                child:
                                                                    Container(
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .only(
                                                                    left: 10,
                                                                    right: 10,
                                                                  ),
                                                                  child:
                                                                      TextFormField(
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                    autofocus:
                                                                        false,
                                                                    controller:
                                                                        customerNameController,
                                                                    decoration:
                                                                        const InputDecoration(
                                                                      border: InputBorder
                                                                          .none,
                                                                      enabledBorder:
                                                                          InputBorder
                                                                              .none,
                                                                      focusedBorder:
                                                                          InputBorder
                                                                              .none,
                                                                    ),
                                                                    textInputAction:
                                                                        TextInputAction
                                                                            .next,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .text,
                                                                    onChanged:
                                                                        (value) {
                                                                      _viewModel
                                                                              .name =
                                                                          value;
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                              verticalSpaceSmall,
                                                              Text(
                                                                "Adresse email",
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontSize: 14,
                                                                  color:
                                                                      AppColors
                                                                          .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                              ),
                                                              verticalSpaceSmall,
                                                              Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                height: 50,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                    color: AppColors
                                                                        .greyFFD9D9D9,
                                                                    width: 1,
                                                                  ),
                                                                  color:
                                                                      AppColors
                                                                          .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                                child:
                                                                    Container(
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .only(
                                                                    left: 10,
                                                                    right: 10,
                                                                  ),
                                                                  child:
                                                                      TextFormField(
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                    autofocus:
                                                                        false,
                                                                    controller:
                                                                        customerEmailController,
                                                                    decoration:
                                                                        const InputDecoration(
                                                                      border: InputBorder
                                                                          .none,
                                                                      enabledBorder:
                                                                          InputBorder
                                                                              .none,
                                                                      focusedBorder:
                                                                          InputBorder
                                                                              .none,
                                                                    ),
                                                                    textInputAction:
                                                                        TextInputAction
                                                                            .next,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .emailAddress,
                                                                    onChanged:
                                                                        (value) {
                                                                      _viewModel
                                                                              .email =
                                                                          value;
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                              verticalSpaceSmall,
                                                              Text(
                                                                "Numéro de téléphone",
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontSize: 14,
                                                                  color:
                                                                      AppColors
                                                                          .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                              ),
                                                              verticalSpaceSmall,
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    flex: 0,
                                                                    child: Container(
                                                                        alignment: Alignment.center,
                                                                        padding: const EdgeInsets.all(5),
                                                                        height: 50,
                                                                        decoration: BoxDecoration(
                                                                          border:
                                                                              Border.all(
                                                                            color:
                                                                                AppColors.greyFFD9D9D9,
                                                                            width:
                                                                                1,
                                                                          ),
                                                                          color:
                                                                              AppColors.white,
                                                                          borderRadius:
                                                                              BorderRadius.circular(8),
                                                                        ),
                                                                        child: Row(
                                                                          children: [
                                                                            Image.asset(
                                                                              "assets/images/flag_ivory_coast.png",
                                                                              package: "digitalpaye_sdk_flutter",
                                                                              width: 20,
                                                                            ),
                                                                            horizontalSpaceSmall,
                                                                            Text(
                                                                              "+225",
                                                                              style: GoogleFonts.poppins(
                                                                                fontSize: 14,
                                                                                color: AppColors.black,
                                                                                fontWeight: FontWeight.w400,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        )),
                                                                  ),
                                                                  horizontalSpaceTiny,
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      height:
                                                                          50,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              AppColors.greyFFD9D9D9,
                                                                          width:
                                                                              1,
                                                                        ),
                                                                        color: AppColors
                                                                            .white,
                                                                        borderRadius:
                                                                            BorderRadius.circular(8),
                                                                      ),
                                                                      child:
                                                                          Container(
                                                                        margin:
                                                                            const EdgeInsets.only(
                                                                          left:
                                                                              10,
                                                                          right:
                                                                              10,
                                                                        ),
                                                                        child:
                                                                            TextFormField(
                                                                          style:
                                                                              const TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                          ),
                                                                          autofocus:
                                                                              false,
                                                                          decoration:
                                                                              const InputDecoration(
                                                                            border:
                                                                                InputBorder.none,
                                                                            enabledBorder:
                                                                                InputBorder.none,
                                                                            focusedBorder:
                                                                                InputBorder.none,
                                                                          ),
                                                                          textInputAction:
                                                                              TextInputAction.done,
                                                                          keyboardType:
                                                                              TextInputType.number,
                                                                          controller:
                                                                              customerPhoneController,
                                                                          inputFormatters: <TextInputFormatter>[
                                                                            LengthLimitingTextInputFormatter(10),
                                                                            FilteringTextInputFormatter.digitsOnly
                                                                          ],
                                                                          onChanged:
                                                                              (value) {
                                                                            _viewModel.phone =
                                                                                value;
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          verticalSpaceLarge,
                                                          SizedBox(
                                                            height: 50,
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child:
                                                                ElevatedButton(
                                                              style:
                                                                  ButtonStyle(
                                                                shape: MaterialStateProperty
                                                                    .all<
                                                                        RoundedRectangleBorder>(
                                                                  RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                  ),
                                                                ),
                                                                elevation:
                                                                    MaterialStateProperty
                                                                        .all<double>(
                                                                            0.0),
                                                                backgroundColor:
                                                                    MaterialStateProperty
                                                                        .all<
                                                                            Color>(
                                                                  !_viewModel
                                                                          .isButtonDisabled
                                                                      ? widget.config
                                                                              .color ??
                                                                          AppColors
                                                                              .primaryColor
                                                                      : AppColors
                                                                          .greyFFD9D9D9,
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                if (!_viewModel
                                                                    .isButtonDisabled) {
                                                                  if (_viewModel
                                                                          .selectedPayment
                                                                          ?.value ==
                                                                      EnumTypePayment
                                                                          .orange
                                                                          .value) {
                                                                    _viewModel
                                                                            .interfacePayment =
                                                                        EnumTypePayment
                                                                            .orange
                                                                            .value;
                                                                  } else {
                                                                    _viewModel.createPayment(
                                                                        token: widget
                                                                            .accessToken,
                                                                        params:
                                                                            widget.payment);
                                                                  }
                                                                }
                                                              },
                                                              child: Text(
                                                                "Payer maintenant",
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontSize: 14,
                                                                  color:
                                                                      AppColors
                                                                          .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                        ],
                                      )
                  ],
                ),
              ),
              if (_viewModel.isLoader)
                Container(
                  color: Colors.white.withOpacity(0.9),
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: SizedBox(
                      width: 250,
                      height: 100,
                      child: Lottie.asset(
                        'assets/animations/loader.json',
                        package: "digitalpaye_sdk_flutter",
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ), // Indicateur de chargement
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
