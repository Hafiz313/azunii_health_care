import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../consts/colors.dart';
import '../../../../consts/fonts.dart';
import '../../../../utils/percentage_size_ext.dart';
import '../controller/medicineController.dart';

class SearchableMedicineField extends StatelessWidget {
  final String title;
  final String hintTxt;
  final Widget prefixIcon;
  final MedicineController controller;

  const SearchableMedicineField({
    super.key,
    required this.title,
    required this.hintTxt,
    required this.prefixIcon,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Accessing reactive variables to ensure Obx triggers a rebuild
      final results = controller.medicineSearchResults;
      final isSearching = controller.isSearchingMedicine.value;

      return LayoutBuilder(
        builder: (context, constraints) {
          return RawAutocomplete<String>(
            textEditingController: controller.medNameController,
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.trim().length < 2) {
                return const Iterable<String>.empty();
              }
              return results;
            },
            onSelected: (String selection) {
              controller.medNameController.text = selection;
              FocusScope.of(context).unfocus();
            },
            fieldViewBuilder: (
              BuildContext context,
              TextEditingController textEditingController,
              FocusNode focusNode,
              VoidCallback onFieldSubmitted,
            ) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.blackColor,
                      fontFamily: FontFamily.satoshi,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    onChanged: (value) {
                      controller.searchMedicine(value);
                    },
                    style: const TextStyle(
                      color: AppColors.blackColor,
                      fontFamily: FontFamily.satoshi,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(width: 0.05, color: AppColors.primary),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 0.1, color: AppColors.primary),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 0.3, color: AppColors.secondary),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: prefixIcon,
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 0,
                      ),
                      suffixIcon: isSearching
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primary,
                                ),
                              ),
                            )
                          : null,
                      hintText: hintTxt,
                      fillColor: AppColors.cardsColor,
                      filled: true,
                      hintStyle: const TextStyle(
                        color: AppColors.blackColor,
                        fontFamily: FontFamily.satoshi,
                        fontSize: 13,
                        fontWeight: FontWeight.w200,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 12.0),
                    ),
                  ),
                ],
              );
            },
            optionsViewBuilder: (
              BuildContext context,
              AutocompleteOnSelected<String> onSelected,
              Iterable<String> options,
            ) {
              if (options.isEmpty) {
                return const SizedBox.shrink();
              }
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 4.0,
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.white,
                  child: Container(
                    width: constraints.maxWidth,
                    constraints: const BoxConstraints(maxHeight: 200),
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.3, color: AppColors.primary),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (BuildContext context, int index) {
                        final String option = options.elementAt(index);
                        return InkWell(
                          onTap: () => onSelected(option),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(width: 0.2, color: AppColors.dividerGray),
                              ),
                            ),
                            child: Text(
                              option,
                              style: const TextStyle(
                                fontFamily: FontFamily.satoshi,
                                fontSize: 14,
                                color: AppColors.blackColor,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    });
  }
}
