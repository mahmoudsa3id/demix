import 'package:demix/core/widgets/snack_bar/app_snack_bar.dart';
import 'package:demix/core/widgets/snack_bar/app_snack_bar_type.dart';
import 'package:flutter/material.dart';

class AppSnackBarService {
  AppSnackBarService._();

  static final AppSnackBarService instance = AppSnackBarService._();

  final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  ScaffoldMessengerState? get _messenger => messengerKey.currentState;

  void show({
    required String message,
    AppSnackBarType type = AppSnackBarType.info,
    String? actionLabel,
    VoidCallback? onAction,
    Duration? duration,
  }) {
    final messenger = _messenger;

    if (messenger == null) return;

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        AppSnackBar.build(
          message: message,
          type: type,
          actionLabel: actionLabel,
          onAction: onAction,
          duration: duration,
        ),
      );
  }

  void success(
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
    Duration? duration,
  }) {
    show(
      message: message,
      type: AppSnackBarType.success,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
    );
  }

  void error(
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
    Duration? duration,
  }) {
    show(
      message: message,
      type: AppSnackBarType.error,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
    );
  }

  void warning(
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
    Duration? duration,
  }) {
    show(
      message: message,
      type: AppSnackBarType.warning,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
    );
  }

  void info(
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
    Duration? duration,
  }) {
    show(
      message: message,
      type: AppSnackBarType.info,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
    );
  }

  void loading(String message) {
    show(message: message, type: AppSnackBarType.loading);
  }

  void hide() {
    _messenger?.hideCurrentSnackBar();
  }

  void remove() {
    _messenger?.removeCurrentSnackBar();
  }
}
