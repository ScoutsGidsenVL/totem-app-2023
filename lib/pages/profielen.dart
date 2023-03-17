import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totem_app/model/profile_manager.dart';
import 'package:azlistview/azlistview.dart';
import 'package:totem_app/widgets/profile_card.dart';
import 'package:totem_app/widgets/profile_dialog.dart';
import 'package:totem_app/widgets/profile_entry.dart';

class Profielen extends StatelessWidget {
  const Profielen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final manager = context.watch<ProfileManager>();
    final profiles = manager.profiles;
    final profile = manager.profile;

    return Scaffold(
        body: Column(children: [
          profile == null
              ? Container()
              : Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
                  child: ProfileCard(profile)),
          Expanded(
              child: Scrollbar(
                  child: AzListView(
                      padding: const EdgeInsets.only(top: 10),
                      data: profiles,
                      itemCount: profiles.length,
                      itemBuilder: (context, index) {
                        return ProfileEntry(profile: profiles[index]);
                      },
                      indexBarData: SuspensionUtil.getTagIndexList(profiles),
                      indexBarOptions: IndexBarOptions(
                        needRebuild: true,
                        hapticFeedback: true,
                        selectTextStyle: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                        selectItemDecoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.primary),
                      ))))
        ]),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return ProfileDialog(onSubmitted: (name, color) {
                      context
                          .read<ProfileManager>()
                          .createProfile(name, color: color);
                    });
                  });
            },
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            child: const Icon(Icons.add)));
  }
}
