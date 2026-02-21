import 'package:flutter/material.dart';
import '../../../consts/colors.dart';

class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int lastPage;
  final ValueChanged<int> onPageChanged;

  const PaginationControls({
    super.key,
    required this.currentPage,
    required this.lastPage,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (lastPage <= 1) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Previous button
          _buildNavButton(
            icon: Icons.chevron_left,
            onTap: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
          ),
          const SizedBox(width: 4),

          // Page number buttons
          ..._buildPageButtons(),

          const SizedBox(width: 4),
          // Next button
          _buildNavButton(
            icon: Icons.chevron_right,
            onTap: currentPage < lastPage
                ? () => onPageChanged(currentPage + 1)
                : null,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPageButtons() {
    final List<Widget> buttons = [];
    final List<int> pagesToShow = _getVisiblePages();

    int? previousPage;
    for (final page in pagesToShow) {
      // Add ellipsis if there's a gap
      if (previousPage != null && page - previousPage > 1) {
        buttons.add(
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              '...',
              style: TextStyle(
                color: AppColors.textColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }

      buttons.add(_buildPageButton(page));
      previousPage = page;
    }

    return buttons;
  }

  /// Determine which page numbers to display.
  /// Shows: first, last, current, and 1 neighbor on each side of current.
  List<int> _getVisiblePages() {
    final Set<int> pages = {};

    // Always show first and last
    pages.add(1);
    pages.add(lastPage);

    // Show current page and its neighbors
    for (int i = currentPage - 1; i <= currentPage + 1; i++) {
      if (i >= 1 && i <= lastPage) {
        pages.add(i);
      }
    }

    final sorted = pages.toList()..sort();
    return sorted;
  }

  Widget _buildPageButton(int page) {
    final isActive = page == currentPage;
    return GestureDetector(
      onTap: isActive ? null : () => onPageChanged(page),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.dividerGray,
            width: 1,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          '$page',
          style: TextStyle(
            color: isActive ? Colors.white : AppColors.textColor,
            fontSize: 13,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            fontFamily: 'Satoshi',
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    VoidCallback? onTap,
  }) {
    final isEnabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isEnabled ? AppColors.dividerGray : AppColors.dividerGray.withOpacity(0.4),
            width: 1,
          ),
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 20,
          color: isEnabled ? AppColors.textColor : AppColors.textColor.withOpacity(0.3),
        ),
      ),
    );
  }
}
