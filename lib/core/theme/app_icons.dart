import 'package:flutter/painting.dart';
import 'package:flutter_svg/svg.dart';

abstract class AppIcons {
  static final String baseUrl = 'assets/images/';
  static const String logoIcon = 'logo_svg.svg';
  static const String googleIcon = 'google-icon.svg';
  static const String facebookIcon = 'facebook-icon.svg';
  static const String profileIcon = 'receipt-icon.svg';
  static const String receiptIcon = 'profile-icon.svg';



  static SvgPicture getIcon({
    required String iconName,
    double? height,
    double? width,
    Color? iconColor,
  }) {
    return SvgPicture.asset(
      baseUrl+iconName,
      fit: BoxFit.cover,
      color: iconColor,
      height: height,
      width: width,
    );
  }
}
