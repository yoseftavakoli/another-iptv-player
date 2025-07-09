import 'package:another_iptv_player/views/screens/xtream-codes/xtream_code_data_loader_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/playlist_controller.dart';
import '../../../../models/api_configuration_model.dart';
import '../../../../models/playlist_model.dart';
import '../../../../repositories/iptv_repository.dart';

class NewXtreamCodePlaylistScreen extends StatefulWidget {
  const NewXtreamCodePlaylistScreen({super.key});

  @override
  NewXtreamCodePlaylistScreenState createState() => NewXtreamCodePlaylistScreenState();
}

class NewXtreamCodePlaylistScreenState extends State<NewXtreamCodePlaylistScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Playlist-1');
  final _urlController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateForm);
    _urlController.addListener(_validateForm);
    _usernameController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
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
          _urlController.text.trim().isNotEmpty &&
          _usernameController.text.trim().isNotEmpty &&
          _passwordController.text.trim().isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text('XStream Playlist')),
      body: Consumer<PlaylistController>(
        builder: (context, controller, child) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(colorScheme),
                  SizedBox(height: 32),
                  _buildPlaylistNameField(colorScheme),
                  SizedBox(height: 20),
                  _buildUrlField(colorScheme),
                  SizedBox(height: 20),
                  _buildUsernameField(colorScheme),
                  SizedBox(height: 20),
                  _buildPasswordField(colorScheme),
                  SizedBox(height: 32),
                  _buildSaveButton(controller, colorScheme),
                  if (controller.error != null) ...[
                    SizedBox(height: 20),
                    _buildErrorCard(controller.error!, colorScheme),
                  ],
                  SizedBox(height: 20),
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
        SizedBox(height: 16),
        Text(
          'XStream Code Playlist',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'IPTV sağlayıcınızdan aldığınız bilgileri girin',
          style: TextStyle(
            fontSize: 16,
            color: colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaylistNameField(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Playlist Adı',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: 'Playlist için bir isim girin',
            prefixIcon: Icon(Icons.playlist_add, color: colorScheme.primary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
            filled: true,
            fillColor: colorScheme.surface,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Playlist adı gerekli';
            }
            if (value.trim().length < 2) {
              return 'Playlist adı en az 2 karakter olmalı';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildUrlField(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'API URL',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: _urlController,
          keyboardType: TextInputType.url,
          decoration: InputDecoration(
            hintText: 'http://example.com:8080',
            prefixIcon: Icon(Icons.link, color: colorScheme.primary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
            filled: true,
            fillColor: colorScheme.surface,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'API URL gerekli';
            }

            // Basit URL validation
            final uri = Uri.tryParse(value.trim());
            if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
              return 'Geçerli bir URL giriniz (http:// veya https://)';
            }

            if (!['http', 'https'].contains(uri.scheme)) {
              return 'URL http:// veya https:// ile başlamalı';
            }

            return null;
          },
        ),
      ],
    );
  }

  Widget _buildUsernameField(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kullanıcı Adı',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: _usernameController,
          decoration: InputDecoration(
            hintText: 'Kullanıcı adınızı girin',
            prefixIcon: Icon(Icons.person, color: colorScheme.primary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
            filled: true,
            fillColor: colorScheme.surface,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Kullanıcı adı gerekli';
            }
            if (value.trim().length < 3) {
              return 'Kullanıcı adı en az 3 karakter olmalı';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordField(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Şifre',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            hintText: 'Şifrenizi girin',
            prefixIcon: Icon(Icons.lock, color: colorScheme.primary),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
            filled: true,
            fillColor: colorScheme.surface,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Şifre gerekli';
            }
            if (value.length < 3) {
              return 'Şifre en az 3 karakter olmalı';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSaveButton(
    PlaylistController controller,
    ColorScheme colorScheme,
  ) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: controller.isLoading
            ? null
            : (_isFormValid ? _savePlaylist : null),
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          disabledBackgroundColor: colorScheme.onSurface.withOpacity(0.12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: controller.isLoading ? 0 : 2,
        ),
        child: controller.isLoading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Kaydediliyor...',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.save, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Playlist\'i Kaydet',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildErrorCard(String error, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.error),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: colorScheme.error),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hata Oluştu',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onErrorContainer,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  error,
                  style: TextStyle(
                    color: colorScheme.onErrorContainer,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.primary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: colorScheme.primary, size: 20),
              SizedBox(width: 8),
              Text(
                'Bilgi',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            '• Tüm bilgiler güvenli bir şekilde cihazınızda saklanır\n'
            '• Şifre bilgileri şifrelenmiş olarak korunur\n'
            '• URL formatı: http://sunucu:port şeklinde olmalıdır\n'
            '• IPTV sağlayıcınızdan aldığınız bilgileri doğru giriniz',
            style: TextStyle(
              color: colorScheme.onPrimaryContainer,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _savePlaylist() async {
    if (_formKey.currentState!.validate()) {
      final controller = Provider.of<PlaylistController>(
        context,
        listen: false,
      );

      controller.clearError();

      final repository = IptvRepository(
        ApiConfig(
          baseUrl: _urlController.text.trim(),
          username: _usernameController.text.trim(),
          password: _passwordController.text.trim(),
        ),
        _nameController.text.trim(),
      );

      try {
        var playerInfo = await repository.getPlayerInfo(forceRefresh: true);

        if (playerInfo == null) {
          // controller.setError(
          //   'Giriş bilgileri hatalı! Lütfen kullanıcı adı, şifre ve URL bilgilerinizi kontrol ediniz.',
          // );
          // todo:::
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
              builder: (context) => XtreamCodeDataLoaderScreen(playlist: playlist),
            ),
          );
        }
      } catch (ex) {}

      // Navigator.of(context).popUntil((route) => route.isFirst);

      // // Başarı mesajı göster
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Row(
      //       children: [
      //         Icon(Icons.check_circle, color: Colors.white),
      //         SizedBox(width: 8),
      //         Expanded(
      //           child: Text(
      //             'Playlist "${_nameController.text.trim()}" başarıyla oluşturuldu!',
      //           ),
      //         ),
      //       ],
      //     ),
      //     backgroundColor: Colors.green,
      //     duration: Duration(seconds: 3),
      //   ),
      // );
    }
  }
}
