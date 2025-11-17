import 'package:flutter/material.dart';

import 'text_form_field_widget.dart';

Widget searchWidget({
  required TextEditingController controller,
}) {
  return TextFormFieldWidget(
    textEditingController: controller,
    prefixIcon: const Icon(Icons.search), // TODO: Use svg instead
    hint: "جستجــو...",
    textInputAction: TextInputAction.search,
  );
}
