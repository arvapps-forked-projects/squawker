import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:squawker/generated/l10n.dart';
import 'package:squawker/utils/misc.dart';
import 'package:squawker/utils/urls.dart';
import 'package:pref/pref.dart';

class SettingsAboutFragment extends StatelessWidget {
  final String appVersion;

  const SettingsAboutFragment({Key? key, required this.appVersion}) : super(key: key);

  Future<void> _appInfo(BuildContext context) async {
    var deviceInfo = DeviceInfoPlugin();
    var packageInfo = await PackageInfo.fromPlatform();
    Map<String, Object> metadata;

    if (Platform.isAndroid) {
      var info = await deviceInfo.androidInfo;

      metadata = {
        'abis': info.supportedAbis,
        'device': info.device,
        'flavor': getFlavor(),
        'locale': Localizations.localeOf(context).languageCode,
        'os': 'android',
        'system': info.version.sdkInt.toString(),
        'version': packageInfo.buildNumber,
      };
    } else {
      var info = await deviceInfo.iosInfo;

      metadata = {
        'abis': [],
        'device': info.utsname.machine,
        'flavor': getFlavor(),
        'locale': Localizations.localeOf(context).languageCode,
        'os': 'ios',
        'system': info.systemVersion,
        'version': packageInfo.buildNumber,
      };
    }

    showDialog(
        context: context,
        builder: (context) {
          var content = JsonEncoder.withIndent(' ' * 2).convert(metadata);

          return AlertDialog(
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(L10n.of(context).ok)),
              ],
              title: Text(L10n.of(context).app_info),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [const SizedBox(height: 16), Text(content, style: const TextStyle(fontFamily: 'monospace'))],
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(L10n.current.about)),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ListView(children: [
          InkWell(
            child: PrefLabel(
              leading: const Icon(Symbols.info),
              title: Text(L10n.of(context).version),
              subtitle: Text(appVersion),
            ),
            onLongPress: () async {
              await Clipboard.setData(ClipboardData(text: appVersion));

              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(L10n.of(context).copied_version_to_clipboard),
              ));
            },
            onTap: () => _appInfo(context),
          ),
          PrefLabel(
            leading: const Icon(Symbols.favorite),
            title: Text(L10n.of(context).contribute),
            subtitle: Text(L10n.of(context).help_make_fritter_even_better),
            onTap: () => openUri('https://github.com/j-fbriere/squawker'),
          ),
          PrefLabel(
            leading: const Icon(Symbols.bug_report),
            title: Text(L10n.of(context).report_a_bug),
            subtitle: Text(
              L10n.of(context).let_the_developers_know_if_something_is_broken,
            ),
            onTap: () => openUri('https://github.com/j-fbriere/squawker/issues'),
          ),
          PrefLabel(
            leading: const Icon(Symbols.copyright),
            title: Text(L10n.of(context).licenses),
            subtitle: Text(L10n.of(context).all_the_great_software_used_by_fritter),
            onTap: () => showLicensePage(
                context: context,
                applicationName: L10n.of(context).fritter,
                applicationVersion: appVersion,
                applicationLegalese: L10n.of(context).released_under_the_mit_license,
                applicationIcon: Container(
                  margin: const EdgeInsets.all(12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(48.0),
                    child: Image.asset(
                      'assets/icon.png',
                      height: 48.0,
                      width: 48.0,
                    ),
                  ),
                )),
          ),
        ]),
      ),
    );
  }
}
