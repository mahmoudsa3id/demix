import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/core/widgets/snack_bar/app_snack_bar_type.dart';
import 'package:flutter/material.dart';

class AppSnackBar {
  AppSnackBar._();

  static SnackBar build({
    required String message,
    AppSnackBarType type = AppSnackBarType.info,
    String? actionLabel,
    VoidCallback? onAction,
    Duration? duration,
  }) {
    final config = _config(type);

    return SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      backgroundColor: Colors.transparent,
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 22),
      duration:
          duration ??
          (type == AppSnackBarType.loading
              ? const Duration(days: 1)
              : const Duration(seconds: 4)),
      dismissDirection: type == AppSnackBarType.loading
          ? DismissDirection.none
          : DismissDirection.horizontal,
      content: _SnackBarCard(
        message: message,
        type: type,
        config: config,
        actionLabel: actionLabel,
        onAction: onAction,
      ),
    );
  }

  static _SnackBarConfig _config(AppSnackBarType type) {
    switch (type) {
      case AppSnackBarType.success:
        return const _SnackBarConfig(
          icon: Icons.check_rounded,
          iconColor: Color(0xFF2FAE68),
          iconBackground: Color(0xFFEAF9F1),
          startColor: Color(0xFF2FAE68),
          endColor: Color(0xFF59C985),
        );

      case AppSnackBarType.error:
        return const _SnackBarConfig(
          icon: Icons.close_rounded,
          iconColor: Color(0xFFE9483F),
          iconBackground: Color(0xFFFFEEEE),
          startColor: Color(0xFFFF5A00),
          endColor: Color(0xFFE9384C),
        );

      case AppSnackBarType.warning:
        return const _SnackBarConfig(
          icon: Icons.warning_amber_rounded,
          iconColor: Color(0xFFF58A00),
          iconBackground: Color(0xFFFFF3E5),
          startColor: Color(0xFFFF7800),
          endColor: Color(0xFFFFA31A),
        );

      case AppSnackBarType.info:
        return const _SnackBarConfig(
          icon: Icons.info_outline_rounded,
          iconColor: AppColors.secondary,
          iconBackground: Color(0xFFF4EAFE),
          startColor: AppColors.primaryLight,
          endColor: AppColors.secondary,
        );

      case AppSnackBarType.loading:
        return const _SnackBarConfig(
          icon: Icons.hourglass_top_rounded,
          iconColor: AppColors.secondary,
          iconBackground: Color(0xFFF4EAFE),
          startColor: AppColors.primaryLight,
          endColor: AppColors.secondary,
        );
    }
  }
}

// ============================================================================
// CARD
// ============================================================================

class _SnackBarCard extends StatelessWidget {
  final String message;
  final AppSnackBarType type;
  final _SnackBarConfig config;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _SnackBarCard({
    required this.message,
    required this.type,
    required this.config,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final isLoading = type == AppSnackBarType.loading;

    final hasAction = actionLabel != null && onAction != null;

    return Container(
      constraints: const BoxConstraints(minHeight: 68),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFCFA),
        borderRadius: BorderRadius.circular(22),

        border: Border.all(color: const Color(0xFFE9E3DF), width: 1.2),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .08),
            blurRadius: 25,
            offset: const Offset(0, 9),
          ),
          BoxShadow(
            color: config.iconColor.withValues(alpha: .08),
            blurRadius: 18,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            // ==========================================================
            // BRAND GRADIENT LINE
            // ==========================================================
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 4,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [config.startColor, config.endColor],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
              child: Row(
                children: [
                  // ====================================================
                  // ICON
                  // ====================================================
                  Container(
                    width: 43,
                    height: 43,
                    decoration: BoxDecoration(
                      color: config.iconBackground,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.4,
                                valueColor: AlwaysStoppedAnimation(
                                  config.iconColor,
                                ),
                              ),
                            )
                          : Icon(
                              config.icon,
                              color: config.iconColor,
                              size: 23,
                            ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // ====================================================
                  // MESSAGE
                  // ====================================================
                  Expanded(
                    child: Text(
                      message,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF17141B),
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),
                  ),

                  // ====================================================
                  // ACTION
                  // ====================================================
                  if (hasAction) ...[
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: onAction,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: [config.startColor, config.endColor],
                          ),
                        ),
                        child: Text(
                          actionLabel!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// CONFIG
// ============================================================================

class _SnackBarConfig {
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final Color startColor;
  final Color endColor;

  const _SnackBarConfig({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.startColor,
    required this.endColor,
  });
}
