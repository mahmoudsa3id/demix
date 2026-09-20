import 'dart:async';

import 'package:demix/core/utils/helper/business_hours_utils.dart';
import 'package:demix/features/business/domain/entities/business.dart';
import 'package:demix/features/business/presentation/pages/widgets/business_profile_open_status_pill.dart';
import 'package:flutter/material.dart';

class BusinessProfileLiveOpenStatus extends StatefulWidget {
  const BusinessProfileLiveOpenStatus({super.key, required this.business});

  final Business business;

  @override
  State<BusinessProfileLiveOpenStatus> createState() =>
      _BusinessProfileLiveOpenStatusState();
}

class _BusinessProfileLiveOpenStatusState
    extends State<BusinessProfileLiveOpenStatus> {
  Timer? _timer;

  bool _isOpen = false;

  @override
  void initState() {
    super.initState();

    _refresh();

    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      _refresh();
    });
  }

  void _refresh() {
    final business = widget.business;

    final result = isBusinessCurrentlyOpen(
      open: business.workingHours?.open,
      close: business.workingHours?.close,
      isManuallyOpen: business.isOpen,
    );

    if (!mounted) {
      return;
    }

    if (_isOpen != result) {
      setState(() {
        _isOpen = result;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BusinessProfileOpenStatusPill(isOpen: _isOpen);
  }
}
