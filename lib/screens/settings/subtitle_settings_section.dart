import 'package:another_iptv_player/repositories/user_preferences.dart';
import 'package:flutter/material.dart';
import '../../widgets/color_picker_tile_widget.dart';
import '../../widgets/dropdown_tile_widget.dart';
import '../../widgets/slider_tile_widget.dart';

class SubtitleSettingsScreen extends StatefulWidget {
  const SubtitleSettingsScreen({super.key});

  @override
  State<SubtitleSettingsScreen> createState() => _SubtitleSettingsScreenState();
}

class _SubtitleSettingsScreenState extends State<SubtitleSettingsScreen> {
  bool _isLoading = true;

  double _fontSize = 32.0;
  double _height = 1.4;
  double _letterSpacing = 0.0;
  double _wordSpacing = 0.0;
  Color _textColor = const Color(0xffffffff);
  Color _backgroundColor = const Color(0xaa000000);
  FontWeight _fontWeight = FontWeight.normal;
  TextAlign _textAlign = TextAlign.center;
  double _padding = 24.0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _fontSize = await UserPreferences.getSubtitleFontSize();
    _height = await UserPreferences.getSubtitleHeight();
    _letterSpacing = await UserPreferences.getSubtitleLetterSpacing();
    _wordSpacing = await UserPreferences.getSubtitleWordSpacing();
    _textColor = await UserPreferences.getSubtitleTextColor();
    _backgroundColor = await UserPreferences.getSubtitleBackgroundColor();
    _fontWeight = await UserPreferences.getSubtitleFontWeight();
    _textAlign = await UserPreferences.getSubtitleTextAlign();
    _padding = await UserPreferences.getSubtitlePadding();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    await UserPreferences.setSubtitleFontSize(_fontSize);
    await UserPreferences.setSubtitleHeight(_height);
    await UserPreferences.setSubtitleLetterSpacing(_letterSpacing);
    await UserPreferences.setSubtitleWordSpacing(_wordSpacing);
    await UserPreferences.setSubtitleTextColor(_textColor);
    await UserPreferences.setSubtitleBackgroundColor(_backgroundColor);
    await UserPreferences.setSubtitleFontWeight(_fontWeight);
    await UserPreferences.setSubtitleTextAlign(_textAlign);
    await UserPreferences.setSubtitlePadding(_padding);
  }

  Future<void> _updateFontSize(double value) async {
    setState(() => _fontSize = value);
    await _saveSettings();
  }

  void _updateHeight(double value) {
    setState(() => _height = value);
    _saveSettings();
  }

  void _updateLetterSpacing(double value) {
    setState(() => _letterSpacing = value);
    _saveSettings();
  }

  void _updateWordSpacing(double value) {
    setState(() => _wordSpacing = value);
    _saveSettings();
  }

  void _updatePadding(double value) {
    setState(() => _padding = value);
    _saveSettings();
  }

  void _updateTextColor(Color color) {
    setState(() => _textColor = color);
    _saveSettings();
  }

  void _updateBackgroundColor(Color color) {
    setState(() => _backgroundColor = color);
    _saveSettings();
  }

  void _updateFontWeight(FontWeight weight) {
    setState(() => _fontWeight = weight);
    _saveSettings();
  }

  void _updateTextAlign(TextAlign align) {
    setState(() => _textAlign = align);
    _saveSettings();
  }

  void _resetToDefaults() {
    setState(() {
      _fontSize = 32.0;
      _height = 1.4;
      _letterSpacing = 0.0;
      _wordSpacing = 0.0;
      _textColor = const Color(0xffffffff);
      _backgroundColor = const Color(0xaa000000);
      _fontWeight = FontWeight.normal;
      _textAlign = TextAlign.center;
      _padding = 24.0;
    });
    _saveSettings();
  }

  Widget _buildPreviewCard() {
    return Container(
      width: double.infinity,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.visibility,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Önizleme',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(_padding),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Örnek altyazı metni\nBu şekilde görünecek',
                  textAlign: _textAlign,
                  textScaler: TextScaler.linear(.38),
                  style: TextStyle(
                    fontSize: _fontSize,
                    height: _height,
                    letterSpacing: _letterSpacing,
                    wordSpacing: _wordSpacing,
                    color: _textColor,
                    backgroundColor: _backgroundColor,
                    fontWeight: _fontWeight,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Altyazı Ayarları'),
        actions: [
          if (!_isLoading)
            TextButton(
              onPressed: _resetToDefaults,
              child: const Text('Sıfırla'),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildPreviewCard(),

                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 16),
                    children: [
                      Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.text_fields,
                                    size: 18,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Font Ayarları',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            SliderTileWidget(
                              icon: Icons.format_size,
                              label: 'Font Boyutu',
                              value: _fontSize,
                              min: 24,
                              max: 96,
                              divisions: 18,
                              onChanged: _updateFontSize,
                            ),
                            const Divider(height: 1),
                            SliderTileWidget(
                              icon: Icons.format_line_spacing,
                              label: 'Satır Yüksekliği',
                              value: _height,
                              min: 1.0,
                              max: 2.5,
                              divisions: 15,
                              onChanged: _updateHeight,
                            ),
                            const Divider(height: 1),
                            SliderTileWidget(
                              icon: Icons.space_bar,
                              label: 'Harf Aralığı',
                              value: _letterSpacing,
                              min: -2.0,
                              max: 5.0,
                              divisions: 70,
                              onChanged: _updateLetterSpacing,
                            ),
                            const Divider(height: 1),
                            SliderTileWidget(
                              icon: Icons.format_textdirection_l_to_r,
                              label: 'Kelime Aralığı',
                              value: _wordSpacing,
                              min: -2.0,
                              max: 10.0,
                              divisions: 120,
                              onChanged: _updateWordSpacing,
                            ),
                            const Divider(height: 1),
                            SliderTileWidget(
                              icon: Icons.padding,
                              label: 'İç Boşluk',
                              value: _padding,
                              min: 8.0,
                              max: 48.0,
                              divisions: 40,
                              onChanged: _updatePadding,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.palette,
                                    size: 18,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Renk Ayarları',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            ColorPickerTileWidget(
                              title: 'Metin Rengi',
                              icon: Icons.format_color_text,
                              color: _textColor,
                              onChanged: _updateTextColor,
                            ),
                            const Divider(height: 1),
                            ColorPickerTileWidget(
                              title: 'Arka Plan Rengi',
                              icon: Icons.format_color_fill,
                              color: _backgroundColor,
                              onChanged: _updateBackgroundColor,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),
                      Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.style,
                                    size: 18,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Stil Ayarları',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            DropdownTileWidget<FontWeight>(
                              icon: Icons.format_bold,
                              label: 'Font Kalınlığı',
                              value: _fontWeight,
                              items: const [
                                DropdownMenuItem(
                                  value: FontWeight.w300,
                                  child: Text('İnce'),
                                ),
                                DropdownMenuItem(
                                  value: FontWeight.normal,
                                  child: Text('Normal'),
                                ),
                                DropdownMenuItem(
                                  value: FontWeight.w500,
                                  child: Text('Orta'),
                                ),
                                DropdownMenuItem(
                                  value: FontWeight.bold,
                                  child: Text('Kalın'),
                                ),
                                DropdownMenuItem(
                                  value: FontWeight.w900,
                                  child: Text('Çok Kalın'),
                                ),
                              ],
                              onChanged: (v) => _updateFontWeight(v!),
                            ),
                            const Divider(height: 1),
                            DropdownTileWidget<TextAlign>(
                              icon: Icons.format_align_center,
                              label: 'Metin Hizalama',
                              value: _textAlign,
                              items: const [
                                DropdownMenuItem(
                                  value: TextAlign.left,
                                  child: Text('Sol'),
                                ),
                                DropdownMenuItem(
                                  value: TextAlign.center,
                                  child: Text('Merkez'),
                                ),
                                DropdownMenuItem(
                                  value: TextAlign.right,
                                  child: Text('Sağ'),
                                ),
                                DropdownMenuItem(
                                  value: TextAlign.justify,
                                  child: Text('İki Yana'),
                                ),
                              ],
                              onChanged: (v) => _updateTextAlign(v!),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
