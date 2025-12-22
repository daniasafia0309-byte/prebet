import 'package:flutter/material.dart';
import '../app_colors.dart';

class PrebetAppBar extends StatelessWidget
    implements PreferredSizeWidget {

  final String title;
  final bool showLocation;
  final bool showSearch;
  final String? location;
  final String? avatarText;
  final VoidCallback? onAvatarTap;

  const PrebetAppBar({
    super.key,
    required this.title,
    this.showLocation = false,
    this.showSearch = false,
    this.location,
    this.avatarText,
    this.onAvatarTap,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(showSearch ? 120 : 60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.card,
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: !showLocation,

      title: showLocation
          ? _locationHeader()
          : Text(
              title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),

      actions: [
        if (avatarText != null)
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: onAvatarTap,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primary,
                child: Text(
                  avatarText!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],

      bottom: showSearch ? _searchBar() : null,
    );
  }

  Widget _locationHeader() {
    return Row(
      children: [
        const Icon(
          Icons.location_on,
          color: AppColors.primary,
          size: 20,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Location',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                location ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  PreferredSizeWidget _searchBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.page,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const TextField(
            decoration: InputDecoration(
              hintText: 'Search messages...',
              prefixIcon: Icon(Icons.search),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
