import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totem_app/model/profile_manager.dart';
import 'package:azlistview/azlistview.dart';
import 'package:totem_app/widgets/profile_entry.dart';

class Profielen extends StatelessWidget {
  const Profielen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var manager = context.watch<ProfileManager>();
    var profiles = manager.profiles;
    var profile = manager.profile;

    return Scaffold(
        body: Scrollbar(
            child: Column(children: [
          profile == null
              ? Container()
              : Padding(
                  padding: const EdgeInsets.all(10),
                  child: Card(
                      child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Row(children: [
                      Icon(Icons.account_circle,
                          size: 48,
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant),
                      Expanded(
                          child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(profile.name,
                                  style: const TextStyle(fontSize: 22)))),
                      IconButton(
                          onPressed: () {
                            manager.unselectProfile();
                          },
                          icon: const Icon(Icons.close))
                    ]),
                  ))),
          Expanded(
              child: LayoutBuilder(
                  builder: (context, constraints) => AzListView(
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
        ])),
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
                              manager.createProfile(a);
                              Navigator.pop(context);
                            },
                            autofocus: true,
                            textCapitalization: TextCapitalization.words,
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
