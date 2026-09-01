import 'dart:async'; // Add this import

import 'package:flutter/material.dart';

import 'package:buffet_app/core/utils/app_logger.dart';
import 'package:buffet_app/core/utils/toaster.dart';
import 'package:buffet_app/core/widgets/confirm_dialog.dart';

class LogViewerScreen extends StatefulWidget {
  const LogViewerScreen({super.key});

  @override
  State<LogViewerScreen> createState() => _LogViewerScreenState();
}

class _LogViewerScreenState extends State<LogViewerScreen> {
  bool _isFiltering = false;
  Timer? _debounce;
  List<String> _allLines = [];
  List<String> _filteredLogs = [];

  String _searchQuery = "";
  String _selectedLevel = "ALL";
  bool _showTimestamp = true;
  bool _isLoading = true;
  bool _showFilters = false;

  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _showJumpButton = false;

  @override
  void initState() {
    super.initState();
    _loadLogs();
    _verticalController.addListener(() {
      if (_verticalController.hasClients) {
        // Show button if the user has scrolled UP away from the bottom
        // (using a 200px threshold from the max scroll extent)
        final isAwayFromBottom =
            _verticalController.position.maxScrollExtent - _verticalController.offset >
            200;

        if (isAwayFromBottom != _showJumpButton) {
          setState(() => _showJumpButton = isAwayFromBottom);
        }
      }
    });
  }

  Future<void> _loadLogs() async {
    setState(() => _isLoading = true);
    try {
      final content = await AppLogger.getLogContent();
      // Use a local variable to avoid multiple setStates
      final lines = content.split('\n').where((l) => l.trim().isNotEmpty).toList();

      if (mounted) {
        setState(() {
          _allLines = lines;
          _isLoading = false; // <--- ADD THIS HERE
        });
        _applyFilters(); // This will now handle _isFiltering
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _scrollToBottom({bool smooth = false}) {
    if (_verticalController.hasClients) {
      if (smooth) {
        _verticalController.animateTo(
          _verticalController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else {
        _verticalController.jumpTo(_verticalController.position.maxScrollExtent);
      }
    }
  }

  void _onSearchChanged(String val) {
    setState(() {
      _searchQuery = val;
      _isFiltering = true; // Show spinner during debounce
    });

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      _applyFilters();
    });
  }

  void _applyFilters() {
    final query = _searchQuery.toLowerCase().trim();
    final level = _selectedLevel;

    // Perform the filter logic
    final results = _allLines.where((line) {
      final matchesSearch = query.isEmpty || line.toLowerCase().contains(query);
      if (level == "ALL") return matchesSearch;

      final icon = {"ERROR": '❌', "WARNING": '⚠️', "INFO": '💡', "DEBUG": '🐛'}[level];

      return matchesSearch && line.contains(icon!);
    }).toList();

    if (mounted) {
      setState(() {
        _filteredLogs = results;
        _isFiltering = false; // Hide the circle and show the list
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "System Logs",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          actions: [
            IconButton(
              icon: Icon(
                _showFilters ? Icons.filter_list_off_rounded : Icons.filter_list_rounded,
              ),
              onPressed: () {
                if (!_showFilters) {
                  FocusScope.of(context).unfocus();
                }
                setState(() => _showFilters = !_showFilters);
              },
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'share') AppLogger.shareLogFile();
                if (value == 'clear') _confirmClearLogs();
                if (value == 'refresh') _loadLogs();
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'refresh',
                  child: Row(
                    children: [
                      Icon(Icons.refresh, size: 20),
                      SizedBox(width: 10),
                      Text("Refresh"),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'share',
                  child: Row(
                    children: [
                      Icon(Icons.share, size: 20),
                      SizedBox(width: 10),
                      Text("Share Logs"),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'clear',
                  child: Row(
                    children: [
                      Icon(Icons.delete_sweep, color: Colors.red, size: 20),
                      SizedBox(width: 10),
                      Text("Clear All", style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        floatingActionButton: _showJumpButton
            ? FloatingActionButton.small(
                backgroundColor: Colors.orange,
                onPressed: () => _scrollToBottom(), // Use the jump function
                child: const Icon(Icons.arrow_downward, color: Colors.white),
              )
            : null,
        body: SafeArea(
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: _showFilters ? 160 : 0,
                curve: Curves.fastOutSlowIn,
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Container(
                    color: Colors.grey.shade50,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: [
                        RepaintBoundary(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: TextField(
                              controller: _searchController, // <--- ADD THIS LINE
                              decoration: InputDecoration(
                                hintText: "Search string...",
                                prefixIcon: const Icon(Icons.search, size: 18),
                                suffixIcon: _searchQuery.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear, size: 18),
                                        onPressed: () {
                                          setState(() {
                                            _searchController.clear();
                                            _searchQuery = "";
                                            _applyFilters();
                                          });
                                        },
                                      )
                                    : null,
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(vertical: 8),
                                // Adjusted for vertical alignment
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                              ),
                              onChanged:
                                  _onSearchChanged, // Use the dedicated method we created
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                          child: Row(
                            children: ["ALL", "DEBUG", "INFO", "WARNING", "ERROR"]
                                .map(
                                  (level) => Padding(
                                    padding: const EdgeInsets.only(right: 4),
                                    child: ChoiceChip(
                                      label: Text(
                                        level,
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                      selected: _selectedLevel == level,
                                      onSelected: (val) {
                                        if (val) {
                                          _selectedLevel = level;
                                          _applyFilters();
                                        }
                                      },
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              const Text(
                                "Timestamps",
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              Transform.scale(
                                scale: 0.6,
                                child: Switch(
                                  value: _showTimestamp,

                                  onChanged: (val) =>
                                      setState(() => _showTimestamp = val),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                "${_filteredLogs.length} entries",
                                style: const TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: _isLoading || _isFiltering
                    ? const Center(child: CircularProgressIndicator())
                    : SelectionArea(
                        contextMenuBuilder: (context, selectableRegionState) {
                          // 1. Get the default items (Copy, Select All, etc.)
                          final List<ContextMenuButtonItem> buttonItems =
                              selectableRegionState.contextMenuButtonItems;

                          // 2. Hide everything EXCEPT the Copy button
                          buttonItems.retainWhere(
                            (item) => item.type == ContextMenuButtonType.copy,
                          );

                          // 3. Build the toolbar with only that one button
                          return AdaptiveTextSelectionToolbar.buttonItems(
                            anchors: selectableRegionState.contextMenuAnchors,
                            buttonItems: buttonItems,
                          );
                        },

                        child: SingleChildScrollView(
                          // Vertical Scroll
                          controller: _verticalController,
                          child: SingleChildScrollView(
                            // Horizontal Scroll
                            controller: _horizontalController,
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width: 2500,
                              child: Column(
                                // <--- Use Column instead of ListView.builder
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ..._filteredLogs.map(
                                    (log) => _LogLineItem(
                                      line: log,
                                      showTimestamp: _showTimestamp,
                                    ),
                                  ),
                                  SizedBox(height: 36),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmClearLogs() {
    ConfirmDialog.show(
      context: context,
      title: "Clear Logs",
      message: "Are you sure you want to permanently delete the log history?",
      icon: Icons.delete_forever_rounded,
      confirmLabel: "Clear Now",
      onConfirm: () async {
        // 1. Close the dialog immediately
        Navigator.pop(context);

        try {
          // 2. Wipe the file
          await AppLogger.clearLogs();

          // 3. Log a "Fresh Start" message so the new file isn't empty
          AppLogger.warning("SYSTEM: Log file was manually cleared by administrator.");

          // 4. Reload the UI
          await _loadLogs();

          // 5. Use your custom Toaster
          Toaster.show("Logs cleared successfully");
        } catch (e) {
          // Log the error and show an error toast if something goes wrong
          AppLogger.error("Failed to clear logs", e);
          Toaster.show("Error clearing logs", isError: true);
        }
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose(); // Add this
    _verticalController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }
}

class _LogLineItem extends StatelessWidget {
  final String line;
  final bool showTimestamp;
  const _LogLineItem({required this.line, required this.showTimestamp});

  @override
  Widget build(BuildContext context) {
    String displayLine = line;
    if (!showTimestamp && line.startsWith('[')) {
      final bracketEnd = line.indexOf(']');
      if (bracketEnd != -1) displayLine = line.substring(bracketEnd + 1).trim();
    }

    final bool isError = line.contains('❌');
    final bool isWarning = line.contains('⚠️');
    final bool isDebug = line.contains('🐛');
    final bool isInfo = line.contains('💡');

    return RepaintBoundary(
      child: Container(
        // height: showTimestamp ? 32.0 : 24.0, // Matches itemExtent for alignment
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.centerLeft,
        child: Text(
          displayLine,
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.visible,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 10.5,
            height: 1.2, // Improves touch target for selection handles
            color: isError
                ? Colors.red.shade900
                : isWarning
                ? Colors.orange.shade900
                : isDebug
                ? Colors.blueGrey
                : isInfo
                ? Colors.blue.shade900
                : Colors.black87,
          ),
        ),
      ),
    );
  }
}
