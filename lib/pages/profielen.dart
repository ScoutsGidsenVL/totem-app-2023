import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totem_app/model/loaded_profile.dart';
import 'package:azlistview/azlistview.dart';
import 'package:totem_app/widgets/profile_entry.dart';

class Profielen extends StatelessWidget {
  const Profielen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var loadedProfile = context.watch<LoadedProfile>();
    var profiles = loadedProfile.profiles;

    return Scaffold(
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
                ))),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      title: const Text('Nieuw profiel'),
                      contentPadding: const EdgeInsets.all(12),
                      children: [
                        TextField(
                            onSubmitted: (a) {
                              loadedProfile.createProfile(a);
                              Navigator.pop(context);
                            },
                            autofocus: true,
                            decoration: const InputDecoration(
                                labelText: 'Naam',
                                border: OutlineInputBorder())),
                      ],
                    );
                  });
            },
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.add)));
  }
}
