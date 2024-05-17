import 'package:digitalpaye_sdk_flutter/guidelines/spacing_guidelines.dart';
import 'package:flutter/widgets.dart';

/// Horizontal spaces

const Widget horizontalSpaceTiny = SizedBox(width: Spacing.tiny);
const Widget horizontalSpaceExtraTiny = SizedBox(width: Spacing.extraTiny);
const Widget horizontalSpaceSmall = SizedBox(width: Spacing.small);
const Widget horizontalSpaceRegular = SizedBox(width: Spacing.regular);
const Widget horizontalSpaceMedium = SizedBox(width: Spacing.medium);
const Widget horizontalSpaceLarge = SizedBox(width: Spacing.large);
const Widget horizontalSpaceExtraLarge = SizedBox(width: Spacing.extraLarge);

const Widget horizontalSpace10 = SizedBox(width: Spacing.spacing_10);

/// Vertical spaces

const Widget verticalSpaceExtraTiny = SizedBox(height: Spacing.extraTiny);
const Widget verticalSpaceTiny = SizedBox(height: Spacing.tiny);
const Widget verticalSpaceSmall = SizedBox(height: Spacing.small);
const Widget verticalSpaceRegular = SizedBox(height: Spacing.regular);
const Widget verticalSpaceMedium = SizedBox(height: Spacing.medium);
const Widget verticalSpaceLarge = SizedBox(height: Spacing.large);
const Widget verticalSpaceExtraLarge = SizedBox(height: Spacing.extraLarge);

const Widget verticalSpace10 = SizedBox(height: Spacing.spacing_10);

/// Custom spaces

Widget horizontalSpace(double space) {
  return SizedBox(width: space);
}

Widget verticalSpace(double space) {
  return SizedBox(height: space);
}
