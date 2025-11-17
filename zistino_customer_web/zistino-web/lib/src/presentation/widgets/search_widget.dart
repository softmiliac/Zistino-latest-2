import 'package:flutter/material.dart';
import 'package:admin_dashboard/src/presentation/style/dimens.dart';
import 'package:get/get.dart';
import '../style/colors.dart';

class SearchWidget extends StatefulWidget {
  SearchWidget({
    Key? key,
    required this.textEditingController,
    this.onTapClear,
    this.isDesktop = false,
    this.isTablet = false,
    this.onFieldSubmitted,
  }) : super(key: key);
  final TextEditingController textEditingController;
  final ValueChanged<String>? onFieldSubmitted;
  final VoidCallback? onTapClear;
  bool isDesktop;
  bool isTablet;

  @override
  State<SearchWidget> createState() => SearchWidgetState();
}

class SearchWidgetState extends State<SearchWidget> {
  final ThemeData theme = Get.theme;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(Get.context!).size.width;
    return TextFormField(
      onFieldSubmitted: widget.onFieldSubmitted,
      controller: widget.textEditingController,
      textInputAction: TextInputAction.search,
      onTap: () =>
          widget.textEditingController.text = widget.textEditingController.text,
      style: theme.textTheme.subtitle2?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: width / 92,
          color: AppColors.textBlackColor),
      decoration: InputDecoration(
        hoverColor: Colors.transparent,
        fillColor: Colors.white,
        contentPadding: widget.isDesktop
            ? EdgeInsetsDirectional.only(start: width / 200, end: 0)
            : EdgeInsets.symmetric(horizontal: standardSize),
        prefixIcon: Icon(
          Icons.search,
          size: width / 70,
        ),
        suffixIcon: widget.textEditingController.text.isEmpty
            ? const SizedBox()
            : AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: widget.textEditingController.text.isEmpty ? 0 : 1,
                child: GestureDetector(
                  onTap: widget.onTapClear ??
                      () {
                        setState(() {
                          widget.textEditingController.clear();
                        });
                      },
                  child: Container(
                    margin: EdgeInsets.only(
                      top: xxSmallSize / 2,
                      bottom: xxSmallSize / 2,
                      left: xxSmallSize / 1.5,
                    ),
                    padding: EdgeInsets.all(
                        widget.isDesktop ? xxSmallSize / 10 : smallSize / 4),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: AppColors.borderColor, width: 1)),
                    child: Icon(Icons.close,
                        color: theme.iconTheme.color,
                        size: widget.isDesktop ? xxSmallSize : standardSize),
                  ),
                ),
              ),
        hintText: 'جستجــو...',
        hintStyle: theme.textTheme.subtitle2?.copyWith(
          color: AppColors.captionColor,
          fontSize: width / 92,
        ),
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(
                widget.isDesktop ? width / 140 : smallRadius)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(
                widget.isDesktop ? width / 140 : smallRadius)),
        disabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(
                widget.isDesktop ? width / 140 : smallRadius)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme.primaryColor),
            borderRadius: BorderRadius.circular(
                widget.isDesktop ? width / 140 : smallRadius)),
      ),
    );
  }
}
