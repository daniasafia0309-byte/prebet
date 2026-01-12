import 'package:flutter/material.dart';
import 'package:prebet/data/user_model.dart';
import 'package:prebet/common/widgets/avatar_utils.dart';

class UserAvatar extends StatelessWidget {
  final AppUser user;
  final double size;
  final bool outlined;

  const UserAvatar({
    super.key,
    required this.user,
    this.size = 40,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = AvatarUtils.colorFromIndex(user.avatarIndex);
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: outlined ? Colors.white : color,
      child: CircleAvatar(
        radius: outlined ? (size / 2) - 2 : size / 2,
        backgroundColor: color,
        child: Text(
          AvatarUtils.initial(user.name),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: size * 0.45,
          ),
        ),
      ),
    );
  }
}
