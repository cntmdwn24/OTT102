import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ott102/presentation/providers/main_provider.dart';
import 'package:ott102/presentation/providers/select_profile_provider.dart';
import '../../common/color.dart';
import '../components/launch/empty_profile_card.dart';
import 'create_profile_screen.dart';
import '../components/widget/custom_bottom_navigation.dart';

class SelectProfileScreen extends StatefulWidget {
  const SelectProfileScreen({super.key});

  @override
  State<SelectProfileScreen> createState() => _SelectProfileScreenState();
}

class _SelectProfileScreenState extends State<SelectProfileScreen> {
  void updateScreen() => setState(() {});

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      selectProfileProvider.addListener(updateScreen);
      selectProfileProvider.loadProfiles();
    });
  }

  @override
  void dispose() {
    selectProfileProvider.removeListener(updateScreen);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'select_a_profile_to_watch'.tr(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Spacer(flex: 10),
            selectProfileProvider.profiles.isEmpty
                ? EmptyProfileCard()
                : _ProfilesList(),
            Spacer(flex: 15),
            Center(
              child: GestureDetector(
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => CreateProfileScreen()),
                  );
                  selectProfileProvider.loadProfiles();
                },
                child: Column(
                  children: [
                    Icon(Icons.add_circle_outline,
                        color: Colors.white, size: 60),
                    SizedBox(height: 6),
                    Text(
                      'add_profile'.tr(),
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    )
                  ],
                ),
              ),
            ),
            Spacer(flex: 10),
          ],
        ),
      ),
    );
  }

  Widget _ProfilesList() {
    return Center(
      child: Wrap(
        spacing: 40,
        runSpacing: 40,
        children: selectProfileProvider.profiles.map(
          (profile) {
            String profileInitial =
                (profile.profileName.isNotEmpty) ? profile.profileName[0] : '';

            return GestureDetector(
              onTap: () async {
                mainProvider.setSelectedProfile(profile);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (_) => CustomBottomNavigationBar()),
                );
              },
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  border: Border.all(width: 1.5, color: Colors.white),
                  color: profile.backgroundColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  profileInitial,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
