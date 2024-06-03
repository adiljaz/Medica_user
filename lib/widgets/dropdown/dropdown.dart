import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Drobdown extends StatelessWidget {
  final List<String> genderItems;

  final String typeText;
  final Function(String?)? onChange;
  final String ?initialvalue ;


  Drobdown(
      {super.key,
      required this.genderItems,
      required this.typeText,
      required this.onChange,
       this.initialvalue, 
      });

   String?selectedValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<String>(
      value: initialvalue,
    
       autovalidateMode: AutovalidateMode.onUserInteraction,
      isExpanded: true,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      hint: Text(
        typeText,
        style: TextStyle(fontSize: 14, color: Colormanager.grayText),
      ),
      items: genderItems
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select gender';
        }
        return null;
      },
      onChanged: onChange,
      onSaved: (value) {
        selectedValue = value.toString();
      },
      buttonStyleData: const ButtonStyleData(
        padding: EdgeInsets.only(right: 8),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 24,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}
