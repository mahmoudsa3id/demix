import 'package:demix/core/routing/route_paths.dart';
import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AccountHeader extends StatelessWidget {
  const AccountHeader({
    super.key,
    required this.name,
    required this.email,
    this.phone,
    this.photoUrl,
  });

  final String name;
  final String email;
  final String? phone;
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          _Avatar(name: name, photoUrl: photoUrl),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.isEmpty ? s.profile : name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.black,
                  ),
                ),
                if (email.isNotEmpty) ...[
                  const SizedBox(height: 5),
                  Text(
                    email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: AppColors.black),
                  ),
                ],
                if (phone != null && phone!.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    phone!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: AppColors.black),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              context.push(RoutePaths.editProfile);
            },
            icon: Icon(Icons.edit_outlined, color: AppColors.secondary),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.name, required this.photoUrl});

  final String name;
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    final letter = name.trim().isEmpty
        ? '?'
        : name.trim().substring(0, 1).toUpperCase();

    return Container(
      width: 64,
      height: 64,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.secondary.withOpacity(.10),
      ),
      child: photoUrl != null && photoUrl!.trim().isNotEmpty
          ? Image.network(
              photoUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return _Fallback(letter);
              },
            )
          : _Fallback(letter),
    );
  }
}

class _Fallback extends StatelessWidget {
  const _Fallback(this.letter);

  final String letter;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        letter,
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w800,
          color: AppColors.secondary,
        ),
      ),
    );
  }
}
