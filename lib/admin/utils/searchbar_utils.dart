import 'package:chiggy_wiggy/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class SearchBarUtils {
  static Widget searchBar(
      BuildContext context,
      String keyName,
      String placeHolder,
      String addButtonLabel,
      Function onSearchTab,
      Function onAddButtonTab) {
    String val = '';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FormHelper.inputFieldWidget(
                context,
                Icon(Icons.ac_unit),
                keyName,
                placeHolder,
                () {},
                () {},
                onChange: (onChangeValue) => {val = onChangeValue},
                showPrefixIcon: false,
                suffixIcon: Container(
                  child: GestureDetector(
                    child: Icon(Icons.search),
                    onTap: () {
                      return onSearchTab(val);
                    },
                  ),
                ),
                borderColor: getThemeColor(),
                borderFocusColor: getThemeColor(),
                borderRadius: 20,
                paddingLeft: 0,
              ),
            ),
          ),
        ),
        FormHelper.submitButton(
          addButtonLabel,
          () {
            return onAddButtonTab();
          },
          borderRadius: 10,
          width: 100,
          fontSize: 12,
          btnColor: getThemeColor(),
        )
      ],
    );
  }
}
