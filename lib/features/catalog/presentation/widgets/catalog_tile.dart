import 'package:buffet_app/core/utils/context_extensions.dart';
import 'package:buffet_app/core/utils/format_extensions.dart';
import 'package:buffet_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CatalogTile extends ConsumerWidget {
  final String name;
  final String? subName;
  final double basePrice;
  final bool isSelected;
  final bool isProduct;
  final VoidCallback onLongPress;
  final VoidCallback onTap;
  final IconData icon;

  const CatalogTile({
    super.key,
    required this.name,
    required this.basePrice,
    required this.isSelected,
    required this.isProduct,
    required this.onLongPress,
    required this.onTap,
    required this.icon,
    this.subName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        // Use 'color' here to ensure the ripple effect is visible
        color: isSelected
            ? context.primaryColor.withAlpha(isDark ? 50 : 25)
            : (isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade50),
        // REMOVE THIS LINE: borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Keep it here!
          side: BorderSide(
            color: isSelected
                ? context.primaryColor.withAlpha(120)
                : (isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade200),
            width: isSelected ? 1.5 : 1,
          ),
        ),

        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          child: IntrinsicHeight(
            child: Row(
              children: [
                // 1. SELECTION ACCENT BAR
                if (isSelected)
                  Container(width: 5, color: context.primaryColor),

                // 2. MAIN CONTENT AREA
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        // --- ICON BOX ---
                        Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? context.primaryColor
                                : (isDark ? const Color(0xFF2C2C2C) : Colors.white),
                            borderRadius: BorderRadius.circular(12),
                            border: isSelected
                                ? null
                                : Border.all(color: isDark ? const Color(0xFF3C3C3C) : Colors.grey.shade200),
                          ),
                          child: Icon(
                            isSelected ? Icons.check_circle_rounded : icon,
                            color: isSelected
                                ? Colors.white
                                : context.primaryColor,
                            size: 24,
                          ),
                        ),

                        const SizedBox(width: 14),

                        // --- NAME & CATEGORY ---
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: isSelected
                                      ? FontWeight.w900
                                      : FontWeight.w700,
                                  color: isDark ? Colors.white : Colors.blueGrey.shade900,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              if (subName != null) ...[
                                const SizedBox(height: 2),
                                Text(
                                  subName!.toUpperCase(),
                                  style: TextStyle(
                                    color: isDark ? Colors.grey.shade400 : Colors.blueGrey.shade400,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),

                        // --- 3. PRICE RECTANGLE ---
                        if (basePrice >= 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? context.colorScheme.primaryContainer
                                  : (isDark ? const Color(0xFF2C2C2C) : Colors.white),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected
                                    ? context.primaryColor.withAlpha(100)
                                    : (isDark ? const Color(0xFF3C3C3C) : Colors.grey.shade200),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(5),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: basePrice == 0
                                ? Text(
                                    AppLocalizations.of(
                                      context,
                                    ).free.toUpperCase(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: context
                                          .colorScheme
                                          .onPrimaryContainer,
                                      fontSize: 14,
                                    ),
                                  )
                                : basePrice.toPriceWidget(
                                    ref,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: context.primaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
