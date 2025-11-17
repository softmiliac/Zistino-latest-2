// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../style/colors.dart';
import '../style/dimens.dart';



class TextFormFieldEditProfileWidget extends StatefulWidget {
  final TextEditingController textEditingController;

   TextFormFieldEditProfileWidget({
    Key? key,
    required this.textEditingController,
    this.validator,
    this.textInputAction,
    this.keyboardType,
    this.isEnable = true,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.onChange,
    this.maxLine,
    this.readOnly,
    this.textDirection,
    this.maxLength,
    this.onEditingComplete,
    this.hint,
    this.label,
    this.labelColor,
    this.labelEmptyColor,
    this.labelDisabledColor,
    this.filled,
    this.fillColor,
    this.suffixIcon,
    this.prefixIcon,
    this.isPassword = false,
    this.showCounter = false,
    this.counterStyle,
    this.errorText,
    this.autovalidateMode,
    this.onTap,
    this.suffixWidget,
    this.padding,
    this.border,
    this.disableBorder,
    this.enableBorder,
    this.focusedBorder,
  }) : super(key: key);
  final List<TextInputFormatter>? inputFormatters;
  final AutovalidateMode? autovalidateMode;
  final String? hint;
  final String? label;
  final String? errorText;
  final Color? labelColor;
  final Color? labelEmptyColor;
  final Color? labelDisabledColor;
  final bool? filled;
  final Color? fillColor;
  final bool? isEnable;
  final bool isPassword;
  final TextDirection? textDirection;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final ValueChanged<String>? onChange;
  final int? maxLine;
  final int? maxLength;
  final VoidCallback? onEditingComplete;
  final bool? readOnly;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool? showCounter;
  final TextStyle? counterStyle;
  final Widget? suffixWidget;
  final InputBorder? border;
  final InputBorder? disableBorder;
  final InputBorder? enableBorder;
  final InputBorder? focusedBorder;
  EdgeInsetsDirectional? padding;

  @override
  State<TextFormFieldEditProfileWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldEditProfileWidget> {
  final ThemeData theme = Get.theme;
  bool isVisibleContent = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        widget.label != null && widget.label!.isNotEmpty
            ? Container(
          margin: EdgeInsets.only(bottom: xSmallSize),
          // alignment: Alignment.c,
          child: Text(
            widget.label ?? "",
            style: theme.textTheme.caption!.copyWith(
              fontWeight: FontWeight.w600,
              color: widget.isEnable != null && !widget.isEnable!
                  ? widget.labelDisabledColor ??
                  AppColors.textBlackColor
                  : widget.labelEmptyColor ?? Colors.black,
            ),
          ),
        )
            : const SizedBox(),
        Directionality(
          textDirection: widget.textDirection ?? TextDirection.rtl,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  onTap: widget.onTap,
                  enabled: widget.isEnable,
                  autovalidateMode: widget.autovalidateMode,
                  textDirection: widget.textDirection ?? TextDirection.rtl,
                  maxLines: widget.maxLine ?? 1,
                  maxLength: widget.maxLength,
                  inputFormatters: widget.inputFormatters,
                  controller: widget.textEditingController,
                  obscureText: widget.isPassword
                      ? isVisibleContent
                      ? false
                      : true
                      : false,
                  textInputAction: widget.textInputAction,
                  keyboardType: widget.keyboardType,
                  onFieldSubmitted: widget.onFieldSubmitted,
                  validator: widget.validator,
                  readOnly: widget.readOnly ?? false,
                  onEditingComplete: widget.onEditingComplete,
                  onChanged: widget.onChange ??
                          (value) {
                        setState(() {});
                      },
                  style:
                  theme.textTheme.bodyText2?.copyWith(color: Colors.black),
                  decoration: InputDecoration(contentPadding: widget.padding ?? const EdgeInsetsDirectional.all(0),
                    errorText: widget.errorText,
                    border:widget.border ?? OutlineInputBorder(borderSide: const BorderSide(color: AppColors.borderColor,),borderRadius: BorderRadius.circular(xSmallRadius)),
                    disabledBorder:  widget.disableBorder ?? OutlineInputBorder(borderSide: const BorderSide(color: AppColors.borderColor),borderRadius: BorderRadius.circular(xSmallRadius)),
                    enabledBorder:widget.enableBorder ??  OutlineInputBorder(borderSide: const BorderSide(color: AppColors.borderColor),borderRadius: BorderRadius.circular(xSmallRadius)),
                    focusedBorder:widget.focusedBorder ??  OutlineInputBorder(borderSide:  BorderSide(color:widget.readOnly == true ?  AppColors.borderColor : theme.primaryColor),borderRadius: BorderRadius.circular(xSmallRadius)),

                    hintText: widget.hint,
                    filled: widget.filled,
                    hintStyle: theme.textTheme.caption!.copyWith(color: Colors.black),
                    fillColor: widget.fillColor,
                    prefixIcon: widget.prefixIcon,
                    counter: widget.showCounter != null && widget.showCounter!
                        ? null
                        : const SizedBox(),
                    counterStyle: widget.counterStyle ??
                        const TextStyle(
                          color: Colors.black,
                        ),
                    suffixIcon: widget.suffixIcon ??
                        (widget.isPassword
                            ? IconButton(
                          icon: isVisibleContent
                              ? Container(
                            margin:
                            EdgeInsets.only(right: xSmallSize),
                            child: SvgPicture.asset(
                              "assets/ic_eye.svg",
                            ),
                          )
                              : Container(
                            margin:
                            EdgeInsets.only(right: xSmallSize),
                            child: SvgPicture.asset(
                              "assets/ic_eye_off.svg",
                            ),
                          ),
                          onPressed: () {
                            setState(
                                  () {
                                isVisibleContent = !isVisibleContent;
                              },
                            );
                          },
                          color: AppColors.captionColor,
                        )
                            : null),
                  ),
                ),
              ),
              widget.suffixWidget ?? const SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}
