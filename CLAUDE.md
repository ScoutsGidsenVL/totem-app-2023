# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Totemapp — de totem-app van Scouts en Gidsen Vlaanderen (Flutter, cross-platform: Android/iOS/web/desktop/linux/macos/windows). Ondersteunt "totemisatie": leden krijgen een totemdier op basis van karaktereigenschappen. GitHub-repo heet `ScoutsGidsenVL/totem-app-2023` (lokale map/pubspec-naam is `totemapp`, zelfde project).

## Commands

- Dependencies installeren: `flutter pub get`
- App draaien: `flutter run`
- Linten: `flutter analyze` (config in `analysis_options.yaml`, gebruikt `flutter_lints`)
- Testen: `flutter test` — let op: `test/widget_test.dart` is verouderde boilerplate die een counter-app test die niet meer bestaat in `main.dart`; geen betrouwbare indicator van dekking.
- JSON-model-parsing code regenereren na wijzigingen aan `lib/model/totem_data.dart` of `pubspec.yaml`: `flutter pub run build_runner watch --delete-conflicting-outputs`
- Launcher icons regenereren: `flutter pub run flutter_launcher_icons`
- Splash screens regenereren: `flutter pub run flutter_native_splash:create`

Geen CI/CD geconfigureerd (geen `.github/workflows`) — verificatie gebeurt manueel.

## Architectuur

- **Entry point** `lib/main.dart`: `MultiProvider` met vier `ChangeNotifier`s — `DynamicData`, `SettingsData`, `ProfileManager` (hangt af van `DynamicData`), `TraitsFilter` (hangt af van `ProfileManager`). Routing via `beamer`, vier tabs in een bottom `NavigationBar` (Totemisatie, Totems, Eigenschappen, Profielen), elk een eigen `BeamLocation` met geneste subroutes.
- **Content fetch** `lib/model/dynamic_data.dart`: haalt `assets/content/totems.json` en `checklist.md` op. Volgorde: netwerk (`raw.githubusercontent.com/ScoutsGidsenVL/totem-app-2023/main`) → gecachete kopie → gebundelde asset. In debug mode wordt altijd rechtstreeks de gebundelde asset gebruikt. Hierdoor kan content bijgewerkt worden door simpelweg naar `main` te pushen, zonder nieuwe app-release.
- **`assets/content/totems.json`**: manueel onderhouden brondata voor alle dieren en eigenschappen (naam, synoniemen, traits, beschrijving, Wikimedia-afbeelding). Niet gegenereerd — rechtstreeks bewerkt; git-historiek toont frequente kleine redactionele passes (bv. genderneutraal maken van beschrijvingen).
- **`lib/model/totem_data.dart` / `totem_data.g.dart`**: `json_serializable`-modellen. `totem_data.g.dart` is gegenereerd — niet manueel bewerken, regenereren via `build_runner`.
- **`lib/model/traits_filter.dart`**: scoort dieren op het aandeel matchende geselecteerde eigenschappen, voedt de Eigenschappen-matchfunctie.
- **`lib/model/profile_manager.dart`**: bewaart profielen via `SharedPreferences`; codeert/decodeert een profiel als compacte base64-blob (naam, kleur, dier-ID's, 360-bit trait-bitset), deelbaar via `totemapp.be/?p=<code>`, onderschept in `main.dart`'s `routeInformationParser`.
- **`AnimalData.isNew`**: markeert dieren met `id >= 393` als nieuw tot een hardcoded cutoff-datum — controleer of deze nog actueel is bij onderhoud.
- **Android SDK-versies**: `android/app/build.gradle` gebruikt `flutter.compileSdkVersion` / `flutter.targetSdkVersion` (dynamisch, bepaald door de geïnstalleerde Flutter SDK-versie), niet hardcoded. Play Store target-API-vereisten los je dus op door de Flutter SDK te upgraden, niet door een getal in dit bestand te wijzigen — zie ook `android/settings.gradle` (AGP-versie) en `android/gradle/wrapper/gradle-wrapper.properties` (Gradle-versie), die wel expliciet gepind zijn en soms mee moeten upgraden.
