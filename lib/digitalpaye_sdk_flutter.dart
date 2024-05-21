import 'package:digitalpaye_sdk_flutter/models/digitalpaye_payment_config.dart';
import 'package:digitalpaye_sdk_flutter/models/digitalpaye_response_payment.dart';
import 'package:digitalpaye_sdk_flutter/utils/app_color.dart';
import 'package:digitalpaye_sdk_flutter/view_model/payment_view_model.dart';
import 'package:digitalpaye_sdk_flutter/views/digitalpaye_payment_view.dart';
import 'package:digitalpaye_sdk_flutter/widgets/digitalpaye_loader_widget.dart';
import 'package:digitalpaye_sdk_flutter/widgets/error_page.dart';
import 'package:flutter/material.dart';
import 'package:digitalpaye_sdk_flutter/interface/digitalpaye_config_interface.dart';
import 'package:digitalpaye_sdk_flutter/repository/digitalpaye_repository.dart';
import 'package:provider/provider.dart';

class DigitalpayeFlutterSDK extends StatefulWidget {
  final DigitalpayeConfigInterface config;
  final DigitalpayePaymentConfig payment;
  final Widget Function(DigitalpayeResponsePayment)? pendingBuilder;

  final Widget Function(DigitalpayeResponsePayment)? successBuilder;
  final Widget Function(DigitalpayeResponsePayment)? errorBuilder;

  const DigitalpayeFlutterSDK({
    super.key,
    required this.config,
    required this.payment,
    this.pendingBuilder,
    this.successBuilder,
    this.errorBuilder,
  });

  @override
  // ignore: library_private_types_in_public_api
  _DigitalpayeFlutterSDKState createState() => _DigitalpayeFlutterSDKState();
}

class _DigitalpayeFlutterSDKState extends State<DigitalpayeFlutterSDK> {
  late final PaymentViewModel _viewModel =
      PaymentViewModel(repository: DigitalpayeRepository(widget.config));
  @override
  void initState() {
    _viewModel.generateToken();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.getAccessToken = (value) {
        _viewModel.accessToken = value;
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
    return ChangeNotifierProvider<PaymentViewModel>.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Consumer<PaymentViewModel>(
          builder: (context, model, child) => _viewModel.isLoader
              ? const LoaderWidget()
              : _viewModel.showError
                  ? ErrorPageView(
                      config: widget.config,
                    )
                  : DigitalpayePaymentView(
                      accessToken: _viewModel.accessToken ?? "",
                      payment: widget.payment,
                      config: widget.config,
                      successBuilder: widget.successBuilder,
                      errorBuilder: widget.errorBuilder,
                      pendingBuilder: widget.pendingBuilder,
                    ),
        ),
      ),
    );
  }
}
