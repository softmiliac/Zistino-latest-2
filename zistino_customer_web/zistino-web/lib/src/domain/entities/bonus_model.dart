import 'package:flutter/material.dart';

class BonusModel {
  final String icon;
  final String title;
  final String? description;
  final Widget? descriptionWidget;
  final Widget? footer;
  final String? actionText;
  final bool actionForceEnabled;
  final int progress;
  final int total;
  final bool separateCounter;
  final VoidCallback? onTap;
  final VoidCallback? onActionTap;

  const BonusModel({
    required this.icon,
    required this.title,
    this.description,
    this.descriptionWidget,
    this.footer,
    this.actionText,
    this.actionForceEnabled = false,
    this.progress = 0,
    this.total = 100,
    this.separateCounter = false,
    this.onTap,
    this.onActionTap,
  });
}
