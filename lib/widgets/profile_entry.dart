import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totemapp/model/profile_manager.dart';
import 'package:totemapp/util.dart';

class ProfileEntry extends StatelessWidget {
  final ProfileData profile;

  const ProfileEntry({super.key, required this.profile, this.onSelect});

  final void Function()? onSelect;

  @override
  Widget build(BuildContext context) {
    final manager = context.watch<ProfileManager>();

    return ListTile(
        contentPadding: const EdgeInsets.only(left: 16, right: 32),
        onTap: () {
          manager.selectProfile(profile.name);
          onSelect?.call();
        },
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child:
                  Icon(Icons.account_circle, color: profile.getColor(context)),
            ),
            Flexible(
              child: Text.rich(
                  TextSpan(children: [
                    TextSpan(
                        text: profile.name,
                        style: const TextStyle(fontSize: 20)),
                    profile.animals.isEmpty
                        ? const TextSpan()
                        : TextSpan(
                            text: ' - ${profile.animals.join(', ')}',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant)),
                  ]),
                  overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
        trailing: IconButton(
            onPressed: () {
              final oldSelectedName = manager.selectedName;
              manager.deleteProfile(profile.name);
              showUndo(context, '${profile.name} verwijderd', () {
                manager.selectedName = oldSelectedName;
                manager.addProfile(profile);
              });
            },
            icon: const Icon(Icons.delete)));
  }
}
