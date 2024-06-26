import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:squawker/trends/_list.dart';
import 'package:squawker/trends/_settings.dart';
import 'package:squawker/trends/_tabs.dart';

class TrendsScreen extends StatefulWidget {
  const TrendsScreen({Key? key}) : super(key: key);

  @override
  State<TrendsScreen> createState() => _TrendsScreenState();
}

class _TrendsScreenState extends State<TrendsScreen> with AutomaticKeepAliveClientMixin<TrendsScreen> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: const TrendsTabBar(),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Symbols.add_rounded),
          onPressed: () async => showModalBottomSheet(
                context: context,
                builder: (context) => const TrendsSettings(),
              )),
      body: TrendsList(),
    );
  }
}
