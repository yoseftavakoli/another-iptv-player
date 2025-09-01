import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:another_iptv_player/l10n/localization_extension.dart';
import 'package:another_iptv_player/screens/xtream-codes/xtream_code_data_loader_screen.dart';
import 'package:another_iptv_player/controllers/playlist_controller.dart';
import 'package:another_iptv_player/models/api_configuration_model.dart';
import 'package:another_iptv_player/models/playlist_model.dart';
import 'package:another_iptv_player/repositories/iptv_repository.dart';

class NewXtreamCodePlaylistScreen extends StatefulWidget {
  const NewXtreamCodePlaylistScreen({super.key});

  @override
  State<NewXtreamCodePlaylistScreen> createState() =>
      NewXtreamCodePlaylistScreenState();
}

class NewXtreamCodePlaylistScreenState
    extends State<NewXtreamCodePlaylistScreen> {
  final _formKey = GlobalKey<FormState>();

  // hidden
  final _nameController = TextEditingController(text: 'Playlist-1');
  final _urlController = TextEditingController(text: 'http://pakhsh.persicola.cc');

  // visible
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // TV focus
  final _fUser = FocusNode(debugLabel: 'user');
  final _fPass = FocusNode(debugLabel: 'pass');
  final _fBtn  = FocusNode(debugLabel: 'btn');

  bool _obscurePassword = true;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_validate);
    _passwordController.addListener(_validate);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _fUser.dispose();
    _fPass.dispose();
    _fBtn.dispose();
    super.dispose();
  }

  void _validate() {
    final ok = _usernameController.text.trim().isNotEmpty &&
        _passwordController.text.trim().isNotEmpty;
    if (ok != _isFormValid) setState(() => _isFormValid = ok);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // Map D-pad arrows & Enter/Select to focus traversal / press
    final shortcuts = <ShortcutActivator, Intent>{
      const SingleActivator(LogicalKeyboardKey.arrowDown): const NextFocusIntent(),
      const SingleActivator(LogicalKeyboardKey.arrowUp): const PreviousFocusIntent(),
      const SingleActivator(LogicalKeyboardKey.arrowRight): const NextFocusIntent(),
      const SingleActivator(LogicalKeyboardKey.arrowLeft): const PreviousFocusIntent(),
      const SingleActivator(LogicalKeyboardKey.enter): const ActivateIntent(),
      const SingleActivator(LogicalKeyboardKey.select): const ActivateIntent(),
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
      body: Shortcuts(
        shortcuts: shortcuts,
        child: Actions(
          actions: <Type, Action<Intent>>{
            NextFocusIntent: CallbackAction<NextFocusIntent>(
              onInvoke: (_) => FocusScope.of(context).nextFocus(),
            ),
            PreviousFocusIntent: CallbackAction<PreviousFocusIntent>(
              onInvoke: (_) => FocusScope.of(context).previousFocus(),
            ),
          },
          child: Consumer<PlaylistController>(
            builder: (context, controller, _) {
              return FocusTraversalGroup(
                policy: OrderedTraversalPolicy(),
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    _header(cs),
                    const SizedBox(height: 20),
                    // order 1
                    FocusTraversalOrder(
                      order: const NumericFocusOrder(1),
                      child: _fieldUsername(cs),
                    ),
                    const SizedBox(height: 14),
                    // order 2
                    FocusTraversalOrder(
                      order: const NumericFocusOrder(2),
                      child: _fieldPassword(cs),
                    ),
                    const SizedBox(height: 20),
                    // order 3
                    FocusTraversalOrder(
                      order: const NumericFocusOrder(3),
                      child: _btnSignIn(controller, cs),
                    ),
                    if (controller.error != null) ...[
                      const SizedBox(height: 12),
                      _error(controller.error!, cs),
                    ],
                    const SizedBox(height: 10),
                    _info(cs),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _header(ColorScheme cs) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.live_tv, size: 40, color: cs.primary),
          const SizedBox(height: 8),
          Text('Enter your credentials',
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: cs.onSurface)),
          const SizedBox(height: 4),
          Text('Sign in with your username and password.',
              style:
                  TextStyle(fontSize: 14, color: cs.onSurface.withOpacity(0.7))),
        ],
      );

  Widget _fieldUsername(ColorScheme cs) => TextFormField(
        controller: _usernameController,
        focusNode: _fUser,
        autofocus: true,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          labelText: context.loc.username,
          hintText: context.loc.username_placeholder,
          prefixIcon: Icon(Icons.person, color: cs.primary),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: cs.surface,
        ),
        validator: (v) {
          if (v == null || v.trim().isEmpty) return context.loc.username_required;
          if (v.trim().length < 3) return context.loc.username_min_3;
          return null;
        },
        onFieldSubmitted: (_) => _fPass.requestFocus(),
      );

  Widget _fieldPassword(ColorScheme cs) => TextFormField(
        controller: _passwordController,
        focusNode: _fPass,
        textInputAction: TextInputAction.done,
        obscureText: _obscurePassword,
        decoration: InputDecoration(
          labelText: context.loc.password,
          hintText: context.loc.password_placeholder,
          prefixIcon: Icon(Icons.lock, color: cs.primary),
          suffixIcon: IconButton(
            icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off,
                color: cs.onSurface.withOpacity(0.6)),
            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: cs.surface,
        ),
        validator: (v) {
          if (v == null || v.trim().isEmpty) return context.loc.password_required;
          if (v.length < 3) return context.loc.password_min_3;
          return null;
        },
        onFieldSubmitted: (_) => _fBtn.requestFocus(),
      );

  Widget _btnSignIn(PlaylistController controller, ColorScheme cs) {
    final enabled = _isFormValid && !controller.isLoading;

    final button = ElevatedButton.icon(
      focusNode: _fBtn,
      icon: const Icon(Icons.login, size: 20),
      label: Text(
        context.loc.submit_create_playlist,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        backgroundColor:
            enabled ? cs.primary : cs.onSurface.withOpacity(0.12),
        foregroundColor:
            enabled ? cs.onPrimary : cs.onSurface.withOpacity(0.7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: enabled ? _signIn : null,
    );

    return controller.isLoading
        ? const Center(
            child: SizedBox(
              height: 40,
              width: 40,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          )
        : button;
  }

  Widget _error(String error, ColorScheme cs) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cs.errorContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.error),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: cs.error),
            const SizedBox(width: 12),
            Expanded(
              child: Text(error,
                  style: TextStyle(
                      color: cs.onErrorContainer, fontSize: 14)),
            ),
          ],
        ),
      );

  Widget _info(ColorScheme cs) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cs.primaryContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.primary),
        ),
        child: Text(
          '${context.loc.all_datas_are_stored_in_device}\n${context.loc.url_format_validate_message}',
          style: TextStyle(
            color: cs.onPrimaryContainer,
            fontSize: 12.5,
            height: 1.35,
          ),
        ),
      );

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = Provider.of<PlaylistController>(context, listen: false);
    controller.clearError();

    final repository = IptvRepository(
      ApiConfig(
        baseUrl: _urlController.text.trim(), // hidden, fixed
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
      ),
      _nameController.text.trim(),
    );

    final playerInfo = await repository.getPlayerInfo(forceRefresh: true);
    if (playerInfo == null) {
      controller.setError(context.loc.invalid_credentials);
      return;
    }

    final playlist = await controller.createPlaylist(
      name: _nameController.text.trim(),
      type: PlaylistType.xtream,
      url: _urlController.text.trim(),
      username: _usernameController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (playlist != null) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => XtreamCodeDataLoaderScreen(playlist: playlist),
        ),
      );
    }
  }
}
