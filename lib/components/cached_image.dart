import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CachedImage extends StatefulWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final BlendMode? colorBlendMode;
  final Widget Function(BuildContext, Widget, ImageChunkEvent?)? loadingBuilder;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;
  final String? semanticLabel;

  const CachedImage({
    Key? key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.color,
    this.colorBlendMode,
    this.loadingBuilder,
    this.errorBuilder,
    this.semanticLabel,
  }) : super(key: key);

  @override
  State<CachedImage> createState() => _CachedImageState();
}

class _CachedImageState extends State<CachedImage> {
  static final Map<String, ui.Image> _imageCache = {};
  static final Map<String, int> _accessCounts = {};
  static const int _maxCacheSize = 50; // Máximo de imagens em cache

  ui.Image? _cachedImage;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(CachedImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imagePath != widget.imagePath) {
      _loadImage();
    }
  }

  Future<void> _loadImage() async {
    if (_imageCache.containsKey(widget.imagePath)) {
      // Imagem já está em cache
      setState(() {
        _cachedImage = _imageCache[widget.imagePath];
        _isLoading = false;
        _accessCounts[widget.imagePath] =
            (_accessCounts[widget.imagePath] ?? 0) + 1;
      });
      return;
    }

    try {
      // Carregar nova imagem
      final ByteData data = await rootBundle.load(widget.imagePath);
      final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
      final frame = await codec.getNextFrame();
      final image = frame.image;

      // Adicionar ao cache
      _addToCache(widget.imagePath, image);

      setState(() {
        _cachedImage = image;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _addToCache(String key, ui.Image image) {
    // Limpar cache antigo se necessário
    if (_imageCache.length >= _maxCacheSize) {
      _cleanupCache();
    }

    _imageCache[key] = image;
    _accessCounts[key] = 1;
  }

  void _cleanupCache() {
    // Remove imagens menos acessadas
    final sortedEntries = _accessCounts.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    // Remove 20% das imagens menos acessadas
    final toRemove = (sortedEntries.length * 0.2).ceil();
    for (int i = 0; i < toRemove && i < sortedEntries.length; i++) {
      final key = sortedEntries[i].key;
      _imageCache.remove(key);
      _accessCounts.remove(key);
    }
  }

  @override
  void dispose() {
    // Limpar recursos se necessário
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingWidget();
    }

    if (_error != null) {
      return _buildErrorWidget();
    }

    if (_cachedImage == null) {
      return _buildErrorWidget();
    }

    return Semantics(
      label: widget.semanticLabel ?? 'Imagem',
      image: true,
      child: RawImage(
        image: _cachedImage!,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        color: widget.color,
        colorBlendMode: widget.colorBlendMode,
      ),
    );
  }

  Widget _buildLoadingWidget() {
    if (widget.loadingBuilder != null) {
      return widget.loadingBuilder!(context, Container(), null);
    }

    return Container(
      width: widget.width,
      height: widget.height,
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    if (widget.errorBuilder != null) {
      return widget.errorBuilder!(context, _error ?? 'Erro desconhecido', null);
    }

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.broken_image_outlined,
              color: Theme.of(context).colorScheme.error,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              'Erro ao carregar imagem',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método estático para limpar todo o cache
  static void clearCache() {
    _imageCache.clear();
    _accessCounts.clear();
  }

  // Método estático para obter estatísticas do cache
  static Map<String, dynamic> getCacheStats() {
    return {
      'cachedImages': _imageCache.length,
      'totalAccesses': _accessCounts.values.fold(0, (a, b) => a + b),
      'cacheSize': _maxCacheSize,
    };
  }
}

// Widget para imagens de rede com cache
class CachedNetworkImage extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final BlendMode? colorBlendMode;
  final Widget Function(BuildContext, Widget, ImageChunkEvent?)? loadingBuilder;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;
  final String? semanticLabel;

  const CachedNetworkImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.color,
    this.colorBlendMode,
    this.loadingBuilder,
    this.errorBuilder,
    this.semanticLabel,
  }) : super(key: key);

  @override
  State<CachedNetworkImage> createState() => _CachedNetworkImageState();
}

class _CachedNetworkImageState extends State<CachedNetworkImage> {
  static final Map<String, Uint8List> _networkCache = {};
  static final Map<String, DateTime> _cacheTimestamps = {};
  static const Duration _cacheDuration = Duration(hours: 24);
  static const int _maxCacheSize = 100; // Máximo de imagens em cache

  Uint8List? _cachedData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadNetworkImage();
  }

  @override
  void didUpdateWidget(CachedNetworkImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _loadNetworkImage();
    }
  }

  Future<void> _loadNetworkImage() async {
    // Verificar se está em cache e não expirou
    if (_networkCache.containsKey(widget.imageUrl)) {
      final cachedTime = _cacheTimestamps[widget.imageUrl];
      if (cachedTime != null &&
          DateTime.now().difference(cachedTime) < _cacheDuration) {
        setState(() {
          _cachedData = _networkCache[widget.imageUrl];
          _isLoading = false;
        });
        return;
      } else {
        // Cache expirou, remover
        _networkCache.remove(widget.imageUrl);
        _cacheTimestamps.remove(widget.imageUrl);
      }
    }

    try {
      // Limpar cache antigo se necessário
      if (_networkCache.length >= _maxCacheSize) {
        _cleanupCache();
      }

      // Carregar nova imagem (simulação - em produção usaria http package)
      // Por enquanto, vamos usar um placeholder
      await Future.delayed(const Duration(milliseconds: 500));

      // Em produção, substituir por:
      // final response = await http.get(Uri.parse(widget.imageUrl));
      // if (response.statusCode == 200) {
      //   final data = response.bodyBytes;
      //   _addToCache(widget.imageUrl, data);
      //   setState(() {
      //     _cachedData = data;
      //     _isLoading = false;
      //   });
      // } else {
      //   throw Exception('Failed to load image: ${response.statusCode}');
      // }

      // Placeholder para demonstração
      throw UnsupportedError('Network images require http package');
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _addToCache(String key, Uint8List data) {
    _networkCache[key] = data;
    _cacheTimestamps[key] = DateTime.now();
  }

  void _cleanupCache() {
    // Remove imagens mais antigas
    final sortedEntries = _cacheTimestamps.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    // Remove 20% das imagens mais antigas
    final toRemove = (sortedEntries.length * 0.2).ceil();
    for (int i = 0; i < toRemove && i < sortedEntries.length; i++) {
      final key = sortedEntries[i].key;
      _networkCache.remove(key);
      _cacheTimestamps.remove(key);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingWidget();
    }

    if (_error != null) {
      return _buildErrorWidget();
    }

    if (_cachedData == null) {
      return _buildErrorWidget();
    }

    return Semantics(
      label: widget.semanticLabel ?? 'Imagem',
      image: true,
      child: Image.memory(
        _cachedData!,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        color: widget.color,
        colorBlendMode: widget.colorBlendMode,
      ),
    );
  }

  Widget _buildLoadingWidget() {
    if (widget.loadingBuilder != null) {
      return widget.loadingBuilder!(context, Container(), null);
    }

    return Container(
      width: widget.width,
      height: widget.height,
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    if (widget.errorBuilder != null) {
      return widget.errorBuilder!(context, _error ?? 'Erro desconhecido', null);
    }

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.broken_image_outlined,
              color: Theme.of(context).colorScheme.error,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              'Erro ao carregar imagem',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método estático para limpar todo o cache
  static void clearCache() {
    _imageCache.clear();
    _accessCounts.clear();
  }
}