import 'package:buffet_app/core/providers/config_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../generated/l10n.dart';

class LivePreviewCard extends ConsumerWidget {
  final String configKey;
  final String tempValue;
  final bool isSaved;

  const LivePreviewCard({
    super.key,
    required this.configKey,
    required this.tempValue,
    required this.isSaved,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = isSaved ? Colors.green : Colors.orange;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withAlpha(isSaved ? 15 : 8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSaved ? Colors.green : Colors.orange.withAlpha(30),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Text(
            isSaved
                ? AppLocalizations.of(context).saved
                : AppLocalizations.of(context).livePreview,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Use your existing logic to show the icon/sign
              _buildPreviewSign(tempValue, color),

              // Spacing specific to your SAR icon
              if (tempValue.contains('sar.svg')) const SizedBox(width: 8),

              Flexible(
                child: Text(
                  _getPreviewPrice(ref, configKey, tempValue),
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: isSaved ? Colors.green : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewSign(String value, Color color) {
    if (value.contains('.svg')) {
      return SvgPicture.asset(
        value,
        width: 28,
        height: 28,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      );
    }
    return Text(
      value,
      style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  String _getPreviewPrice(WidgetRef ref, String key, String value) {
    final configs = ref.read(configProvider);
    final numLoc = (key == 'number_format') ? value : (configs['number_format'] ?? 'en');

    // Logic: if it's Arabic format, return localized digits
    return numLoc == 'ar' ? "١,٢٥٠.٥٠" : "1,250.50";
  }
}
