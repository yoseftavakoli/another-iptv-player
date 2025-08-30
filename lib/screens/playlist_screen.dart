import 'package:flutter/material.dart';
import '../xtream-codes/new_xtream_code_playlist_screen.dart';

class NewPlaylistScreen extends StatefulWidget {
  const NewPlaylistScreen({super.key});

  @override
  State<NewPlaylistScreen> createState() => _NewPlaylistScreenState();
}

class _NewPlaylistScreenState extends State<NewPlaylistScreen> {
  @override
  void initState() {
    super.initState();
    // Skip chooser and go straight to username/password
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const NewXtreamCodePlaylistScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Optional: tiny placeholder while redirecting
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
