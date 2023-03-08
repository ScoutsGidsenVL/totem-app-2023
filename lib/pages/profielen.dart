import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totem_app/model/loaded_profile.dart';
import 'package:azlistview/azlistview.dart';
import 'package:totem_app/widgets/profile_entry.dart';

class Profielen extends StatelessWidget {
  const Profielen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var profiles = context.watch<LoadedProfile>().profiles;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Profielen'),
        ),
        body: Scrollbar(
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
                ))));
  }
}
