import 'package:flutter/material.dart';
import 'package:prebet/common/app_colors.dart';

class PrebetHeader extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final Widget? trailing;
  final List<Widget>? actions;
  final bool usePrimaryColor;

  const PrebetHeader({
    super.key,
    required this.title,
    this.showBack = true,
    this.trailing,
    this.actions,
    this.usePrimaryColor = true,
  });

  static const double _height = 80;

  @override
  Size get preferredSize => const Size.fromHeight(_height);

  @override
  Widget build(BuildContext context) {
    final Color bgColor =
        usePrimaryColor ? AppColors.primaryColor : Colors.white;

    final Color fgColor =
        usePrimaryColor ? Colors.white : Colors.black;

    final List<Widget>? resolvedActions = actions ??
        (trailing != null
            ? [
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: IconTheme(
                    data: IconThemeData(
                      size: 22,
                      color: fgColor,
                    ),
                    child: trailing!,
                  ),
                )
              ]
            : null);

    return AppBar(
      backgroundColor: bgColor,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      toolbarHeight: _height,

      leading: showBack
          ? IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: fgColor,
                size: 22,
              ),
              onPressed: () => Navigator.pop(context),
            )
          : null,

      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          height: 1.2,
          color: fgColor,
        ),
      ),

      actions: resolvedActions,
    );
  }
}
