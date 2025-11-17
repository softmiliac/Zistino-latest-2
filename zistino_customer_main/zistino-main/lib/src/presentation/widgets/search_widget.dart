import 'package:flutter/material.dart';
import 'package:zistino/src/presentation/style/dimens.dart';
import 'package:get/get.dart';
import '../style/colors.dart';

class SearchWidget extends StatefulWidget {
  SearchWidget({
    Key? key,
    required this.textEditingController,
    this.onTapClear,
    this.onChange,
    this.isDesktop = false,
    this.onFieldSubmitted,
  }) : super(key: key);
  final TextEditingController textEditingController;
  final ValueChanged<String>? onFieldSubmitted;
  final ValueChanged<String>? onChange;
  final VoidCallback? onTapClear;
  bool isDesktop;

  @override
  State<SearchWidget> createState() => SearchWidgetState();
}

class SearchWidgetState extends State<SearchWidget> {
  final ThemeData theme = Get.theme;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: widget.onFieldSubmitted,
      controller: widget.textEditingController,
      textInputAction: TextInputAction.search,
      onTap: () {
        if(widget.textEditingController.text.isNotEmpty){
          if (widget.textEditingController.text.endsWith(' ') == false) {
            widget.textEditingController.text =
                '${widget.textEditingController.text.trim()} ';
          }
        }
      },
      onChanged: widget.onChange,
      style: theme.textTheme.subtitle2?.copyWith(
          fontWeight: FontWeight.w600, color: AppColors.textBlackColor),
      decoration: InputDecoration(
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: widget.isDesktop ? xSmallSize : standardSize),
          prefixIcon: const Icon(Icons.search),
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
                  top: xSmallSize,
                  bottom: xSmallSize,
                  right: xSmallSize,
                ),
                padding: EdgeInsets.all(widget.isDesktop ? xxSmallSize/8 : smallSize / 4),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: AppColors.borderColor, width: 1)),
                child: Icon(Icons.close,
                    color: theme.iconTheme.color, size: widget.isDesktop ? xSmallSize : standardSize),
              ),
            ),
          ),
          hintText: 'جستجــو...',
          hintStyle: theme.textTheme.subtitle2?.copyWith(color: AppColors.captionColor),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.isDesktop ? xxSmallSize/1.5 : smallRadius),
              borderSide: BorderSide.none
          )
      ),
    );
  }
}
