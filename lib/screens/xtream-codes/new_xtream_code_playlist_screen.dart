import 'package:another_iptv_player/l10n/localization_extension.dart';
import 'package:another_iptv_player/screens/xtream-codes/xtream_code_data_loader_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/playlist_controller.dart';
import '../../../../models/api_configuration_model.dart';
import '../../../../models/playlist_model.dart';
import '../../../../repositories/iptv_repository.dart';

class NewXtreamCodePlaylistScreen extends StatefulWidget {
  const NewXtreamCodePlaylistScreen({super.key});

  @override
  NewXtreamCodePlaylistScreenState createState() =>
      NewXtreamCodePlaylistScreenState();
}

class NewXtreamCodePlaylistScreenState
    extends State<NewXtreamCodePlaylistScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Playlist-1');
  final _urlController = TextEditingController(); // kept internal, never shown
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();

    // Use public Caddy reverse proxy (port 80)
    _urlController.text = 'http://pakhsh.persicola.cc';

    _nameController.addListener(_validateForm);
    _usernameController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    // NOTE: no listener for _urlController since it's hidden/fixed
  }

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isFormValid =
          _nameController.text.trim().isNotEmpty &&
          _usernameController.text.trim().isNotEmpty &&
          _passwordController.text.trim().isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text('Sign in')),
      body: Consumer<PlaylistController>(
        builder: (context, controller, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(colorScheme),
                  const SizedBox(height: 32),
                  // (Optional) You can hide playlist name too; leave it for now.
                  _buildUsernameField(colorScheme),
                  const SizedBox(height: 20),
                  _buildPasswordField(colorScheme),
                  const SizedBox(height: 28),
                  _buildSignInButton(controller, colorScheme),
                  if (controller.error != null) ...[
                    const SizedBox(height: 20),
                    _buildErrorCard(controller.error!, colorScheme),
                  ],
                  const SizedBox(height: 16),
                  _buildInfoCard(colorScheme),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Icon(Icons.stream, size: 30, color: colorScheme.onPrimary),
        ),
        const SizedBox(height: 16),
        Text('Enter your credentials',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            )),
        const SizedBox(height: 6),
        Text('Sign in with your username and password.',
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface.withOpacity(0.7),
            )),
      ],
    );
  }

  Widget _buildUsernameField(ColorScheme colorScheme) {
    return TextFormField(
      controller: _usernameController,
      decoration: InputDecoration(
        labelText: context.loc.username,
        hintText: context.loc.username_placeholder,
        prefixIcon: Icon(Icons.person, color: colorScheme.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: colorScheme.surface,
      ),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return context.loc.username_required;
        if (v.trim().length < 3) return context.loc.username_min_3;
        return null;
      },
    );
  }

  Widget _buildPasswordField(ColorScheme colorScheme) {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: context.loc.password,
        hintText: context.loc.password_placeholder,
        prefixIcon: Icon(Icons.lock, color: colorScheme.primary),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility : Icons.visibility_off,
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: colorScheme.surface,
      ),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return context.loc.password_required;
        if (v.length < 3) return context.loc.password_min_3;
        return null;
      },
    );
  }

  Widget _buildSignInButton(
    PlaylistController controller,
    ColorScheme colorScheme,
  ) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: controller.isLoading ? null : (_isFormValid ? _signIn : null),
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          disabledBackgroundColor: colorScheme.onSurface.withOpacity(0.12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: controller.isLoading
            ? const CircularProgressIndicator(strokeWidth: 2)
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.login, size: 20),
                  SizedBox(width: 8),
                  Text('Sign in', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ],
              ),
      ),
    );
  }

  Widget _buildErrorCard(String error, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.error),
      ),
      child: Row(children: [
        Icon(Icons.error_outline, color: colorScheme.error),
        const SizedBox(width: 12),
        Expanded(
          child: Text(error,
              style: TextStyle(color: colorScheme.onErrorContainer, fontSize: 14)),
        ),
      ]),
    );
  }

  Widget _buildInfoCard(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.primary),
      ),
      child: Text(
        '${context.loc.all_datas_are_stored_in_device}\n${context.loc.url_format_validate_message}',
        style: TextStyle(
          color: colorScheme.onPrimaryContainer,
          fontSize: 13,
          height: 1.4,
        ),
      ),
    );
  }

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      final controller = Provider.of<PlaylistController>(context, listen: false);
      controller.clearError();

      final repository = IptvRepository(
        ApiConfig(
          baseUrl: _urlController.text.trim(),      // hidden, fixed
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => XtreamCodeDataLoaderScreen(playlist: playlist),
          ),
        );
      }
    }
  }
}
