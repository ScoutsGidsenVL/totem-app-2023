import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totemapp/model/profile_manager.dart';
import 'package:azlistview/azlistview.dart';
import 'package:totemapp/widgets/profile_card.dart';
import 'package:totemapp/widgets/profile_dialog.dart';
import 'package:totemapp/widgets/profile_entry.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class Profielen extends StatefulWidget {
  const Profielen({super.key});

  @override
  State<Profielen> createState() => _ProfielenState();
}

class _ProfielenState extends State<Profielen> {
  final ItemScrollController _scrollController = ItemScrollController();

  @override
  Widget build(BuildContext context) {
    final manager = context.watch<ProfileManager>();
    final profiles = manager.profiles;
    final profile = manager.profile;

    final profilesWithHeader = [ProfileData(name: '#'), ...profiles];

    return Scaffold(
        body: Scrollbar(
            child: LayoutBuilder(
                builder: (context, constraints) => AzListView(
                    itemScrollController: _scrollController,
                    data: profilesWithHeader,
                    itemCount: profiles.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                            padding: const EdgeInsets.all(10),
                            child: ProfileCard(profile));
                      }
                      return ProfileEntry(
                        profile: profiles[index - 1],
                        onSelect: () {
                          _scrollController.scrollTo(
                              index: 0,
                              duration: const Duration(milliseconds: 100));
                        },
                      );
                    },
                    indexBarData: constraints.maxHeight < 400
                        ? []
                        : SuspensionUtil.getTagIndexList(profilesWithHeader),
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
                    )))),
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
                              .createProfile(name: name, color: color);
                        });
                      });
                },
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                label: 'Nieuw profiel',
                child: const Icon(Icons.person_add)),
            SpeedDialChild(
                onTap: () {
                  context.beamToNamed('/profielen/import');
                },
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                label: 'Importeer profiel',
                child: const Icon(Icons.link)),
          ],
        ));
  }
}
