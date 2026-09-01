import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/format_extensions.dart';
import '../../../../generated/l10n.dart';
import '../providers/catalog_providers.dart'; // Import your category provider

enum ImportAction { add, replace, duplicate, skip }

class ImportPreviewScreen extends ConsumerStatefulWidget {
  final List<dynamic> incomingItems;
  final List<dynamic> existingItems;
  final int activeIndex; // 0: Products, 1: Add-ons, 2: Categories

  const ImportPreviewScreen({
    super.key,
    required this.incomingItems,
    required this.existingItems,
    required this.activeIndex,
  });

  @override
  ConsumerState<ImportPreviewScreen> createState() => _ImportConflictScreenState();
}

class _ImportConflictScreenState extends ConsumerState<ImportPreviewScreen> {
  late Map<int, ImportAction> userChoices;

  @override
  void initState() {
    super.initState();
    userChoices = {};
    _initializeChoices();
  }

  void _initializeChoices() {
    for (int i = 0; i < widget.incomingItems.length; i++) {
      final item = widget.incomingItems[i];
      final exists = widget.existingItems.any(
        (e) => e.name.trim().toLowerCase() == item.name.trim().toLowerCase(),
      );
      userChoices[i] = exists ? ImportAction.skip : ImportAction.add;
    }
  }

  void _setBulkAction(ImportAction action) {
    setState(() {
      for (int i = 0; i < widget.incomingItems.length; i++) {
        final item = widget.incomingItems[i];
        final exists = widget.existingItems.any(
          (e) => e.name.trim().toLowerCase() == item.name.trim().toLowerCase(),
        );
        if (exists) userChoices[i] = action;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          onPressed: () =>
              Navigator.pop(context, null), // Return null to signify cancellation
          icon: const Icon(Icons.close_rounded),
          tooltip: l10n.cancel, // Ensure 'cancel' is in your l10n
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.importPreview, style: const TextStyle(fontWeight: FontWeight.w900)),
            Text(
              l10n.processedItems(widget.incomingItems.length),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: TextButton.icon(
              onPressed: () => Navigator.pop(context, userChoices),
              style: TextButton.styleFrom(
                // Give it a subtle background so it looks like a primary action
                backgroundColor: Colors.orange.withAlpha(26),
                foregroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  // Corrected name
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              icon: const Icon(
                Icons.system_update_alt_rounded, // Icon that implies "Data is coming in"
                size: 18,
              ),
              label: Text(
                l10n.importAction,
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                Icon(Icons.bolt, size: 18, color: Colors.blue[700]),
                const SizedBox(width: 8),
                Text(
                  l10n.duplicates,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const Spacer(),
                _bulkBtn(l10n.skipAll, ImportAction.skip, Colors.grey),
                const SizedBox(width: 8),
                _bulkBtn(l10n.replaceAll, ImportAction.replace, Colors.blue),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.incomingItems.length,
              itemBuilder: (context, index) {
                final incoming = widget.incomingItems[index];
                dynamic existing;
                try {
                  existing = widget.existingItems.firstWhere(
                    (e) =>
                        e.name.trim().toLowerCase() == incoming.name.trim().toLowerCase(),
                  );
                } catch (_) {
                  existing = null;
                }

                final bool isDuplicate = existing != null;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDuplicate
                          ? Colors.orange.withOpacity(0.2)
                          : Colors.transparent,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    incoming.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                _buildBadge(isDuplicate, l10n),
                              ],
                            ),
                            const SizedBox(height: 8),
                            _buildInfoSection(isDuplicate, existing, incoming),
                          ],
                        ),
                      ),
                      if (isDuplicate) _buildActionSelector(index, l10n),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(bool isDuplicate, dynamic existing, dynamic incoming) {
    if (widget.activeIndex == 2) return const SizedBox.shrink();

    return Column(
      children: [
        // Price Row
        Row(
          children: [
            const Icon(Icons.payments_outlined, size: 14, color: Colors.grey),
            const SizedBox(width: 8),
            isDuplicate
                ? _buildPriceComparison(existing.basePrice, incoming.basePrice)
                : (incoming.basePrice as num).toPriceWidget(
                    ref,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
          ],
        ),

        // Category Row (Only for Products index 0)
        if (widget.activeIndex == 0) ...[
          const SizedBox(height: 6),
          _buildCategoryComparison(isDuplicate, existing, incoming),
        ],
      ],
    );
  }

  Widget _buildCategoryComparison(bool isDuplicate, dynamic existing, dynamic incoming) {
    final l10n = AppLocalizations.of(context);
    final String newCatName = incoming.category?.name ?? l10n.noCategory;

    // Check if the category in the CSV exists in our current DB
    final allCategories = ref.watch(categoryNotifierProvider).value ?? [];
    final bool catExistsInDb = allCategories.any(
      (c) => c.name.trim().toLowerCase() == newCatName.trim().toLowerCase(),
    );

    if (!isDuplicate) {
      return Row(
        children: [
          const Icon(Icons.category_outlined, size: 14, color: Colors.grey),
          const SizedBox(width: 8),
          Text(newCatName, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 6),
          _dbStatusIndicator(catExistsInDb),
        ],
      );
    }

    final String oldCatName = existing.category?.name ?? l10n.noCategory;
    final bool isChanged = oldCatName != newCatName;

    return Row(
      children: [
        const Icon(Icons.category_outlined, size: 14, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          oldCatName,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
            decoration: TextDecoration.lineThrough,
          ),
        ),
        const SizedBox(width: 6),
        const Icon(Icons.arrow_forward_rounded, size: 12, color: Colors.grey),
        const SizedBox(width: 6),
        Text(
          newCatName,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isChanged ? Colors.blue[700] : Colors.grey[700],
          ),
        ),
        const SizedBox(width: 6),
        _dbStatusIndicator(catExistsInDb),
      ],
    );
  }

  Widget _dbStatusIndicator(bool exists) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: exists ? Colors.blue[50] : Colors.purple[50],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        exists ? l10n.catExists : l10n.newCat,
        style: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.bold,
          color: exists ? Colors.blue[800] : Colors.purple[800],
        ),
      ),
    );
  }

  Widget _buildPriceComparison(double oldPrice, double newPrice) {
    final bool isChanged = oldPrice != newPrice;
    return Row(
      children: [
        oldPrice.toPriceWidget(
          ref,
          style: const TextStyle(
            decoration: TextDecoration.lineThrough,
            fontSize: 11,
            color: Colors.grey,
          ),
        ),
        const SizedBox(width: 6),
        const Icon(Icons.arrow_forward_rounded, size: 12, color: Colors.grey),
        const SizedBox(width: 6),
        newPrice.toPriceWidget(
          ref,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: isChanged ? Colors.blue[700] : Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(bool exists, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: exists ? Colors.orange[50] : Colors.green[50],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        exists ? l10n.exists : l10n.newWord,
        style: TextStyle(
          color: exists ? Colors.orange[800] : Colors.green[800],
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildActionSelector(int index, AppLocalizations l10n) {
    final currentAction = userChoices[index] ?? ImportAction.skip;

    // Calculate the alignment for the slider based on selection
    // Products/Addons have 3 options, Categories have 2.
    final List<ImportAction> availableActions = [
      ImportAction.skip,
      ImportAction.replace,
      if (widget.activeIndex != 2) ImportAction.duplicate,
    ];

    final int selectedIndex = availableActions.indexOf(currentAction);

    // Maps index to Alignment: -1.0 (left), 0.0 (center), 1.0 (right)
    // For 2 items: -1.0 and 1.0
    double alignmentX = -1.0;
    if (availableActions.length == 3) {
      alignmentX = selectedIndex == 0 ? -1.0 : (selectedIndex == 1 ? 0.0 : 1.0);
    } else {
      alignmentX = selectedIndex == 0 ? -1.0 : 1.0;
    }

    // Get color based on selected action
    Color activeColor = Colors.grey[700]!;
    if (currentAction == ImportAction.replace) activeColor = Colors.blue[700]!;
    if (currentAction == ImportAction.duplicate) activeColor = Colors.purple[700]!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Container(
        height: 44, // Fixed height for the sliding bar
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            // THE SLIDER (The moving background)
            AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOutCubic,
              alignment: Alignment(alignmentX, 0),
              child: FractionallySizedBox(
                widthFactor: 1 / availableActions.length,
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: activeColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: activeColor.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // THE BUTTONS (The text layers)
            Row(
              children: availableActions.map((action) {
                String label = "";
                if (action == ImportAction.skip) label = l10n.skip;
                if (action == ImportAction.replace) label = l10n.replace;
                if (action == ImportAction.duplicate) label = l10n.duplicate;

                return _choiceBtn(index, label, action);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _choiceBtn(int index, String label, ImportAction action) {
    bool isSelected = userChoices[index] == action;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => setState(() => userChoices[index] = action),
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 250),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
            child: Text(label),
          ),
        ),
      ),
    );
  }

  Widget _bulkBtn(String label, ImportAction action, Color color) {
    return InkWell(
      onTap: () => _setBulkAction(action),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: color.withAlpha(51)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
        ),
      ),
    );
  }
}
