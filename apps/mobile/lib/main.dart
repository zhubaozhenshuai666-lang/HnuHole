import 'package:flutter/material.dart';

import 'hnuhole_mobile.dart';

void main() {
  final repository = HttpChannelRepository(
    baseUri: Uri.parse(
      const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'http://127.0.0.1:8080',
      ),
    ),
  );
  final directory = ChannelDirectoryController(repository: repository);

  runApp(_HnuholeApp(directory: directory, repository: repository));
}

class _HnuholeApp extends StatefulWidget {
  const _HnuholeApp({required this.directory, required this.repository});

  final ChannelDirectoryController directory;
  final HttpChannelRepository repository;

  @override
  State<_HnuholeApp> createState() => _HnuholeAppState();
}

class _HnuholeAppState extends State<_HnuholeApp> {
  final ChannelTreeSession _treeSession = ChannelTreeSession();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void dispose() {
    widget.directory.dispose();
    widget.repository.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hnuhole',
      scaffoldMessengerKey: _scaffoldMessengerKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF76AFC8)),
        useMaterial3: true,
      ),
      home: EntryScreen(
        directory: widget.directory,
        treeSession: _treeSession,
        onLoginRequested: () {
          // Authentication is supplied by the next slice. Keeping the entry
          // callback explicit makes the tree usable with a real login flow or
          // a development verification adapter without changing its state
          // model.
          _scaffoldMessengerKey.currentState?.showSnackBar(
            const SnackBar(content: Text('Email verification is not wired yet')),
          );
        },
        onChannelSelected: (channel) {
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(content: Text('Open ${channel.displayName}')),
          );
        },
      ),
    );
  }
}
