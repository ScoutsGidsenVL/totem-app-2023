import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totemapp/model/profile_manager.dart';
import 'package:azlistview/azlistview.dart';
import 'package:totemapp/widgets/import_dialog.dart';
import 'package:totemapp/widgets/profile_card.dart';
import 'package:totemapp/widgets/profile_dialog.dart';
import 'package:totemapp/widgets/profile_entry.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class Profielen extends StatelessWidget {
  const Profielen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final manager = context.watch<ProfileManager>();
    final profiles = manager.profiles;
    final profile = manager.profile;

    return Scaffold(
        body: Column(children: [
          Padding(
              padding: const EdgeInsets.all(10), child: ProfileCard(profile)),
          Expanded(
              child: Scrollbar(
                  child: AzListView(
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
        floatingActionButton: SpeedDial(
          icon: Icons.add,
          activeIcon: Icons.close,
          spacing: 3,
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          children: [
            SpeedDialChild(
                onTap: () {
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
                label: 'Nieuw profiel',
                child: const Icon(Icons.person_add)),
            SpeedDialChild(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return ImportDialog(onSubmitted: (profile) {
                          context
                              .read<ProfileManager>()
                              .addProfile(profile, force: true);
                        });
                      });
                },
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                label: 'Importeer profiel',
                child: const Icon(Icons.link)),
          ],
        ));
  }
}
