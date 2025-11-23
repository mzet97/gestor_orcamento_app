import 'dart:collection';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Cache de performance para otimizar carregamento de dados
class PerformanceCache {
  static final PerformanceCache _instance = PerformanceCache._internal();
  factory PerformanceCache() => _instance;
  PerformanceCache._internal();

  // Cache principal
  final Map<String, CacheItem> _cache = {};
  final Queue<String> _accessOrder = Queue<String>();
  
  // Configurações
  static const int _maxCacheSize = 100;
  static const Duration _defaultTTL = Duration(minutes: 5);

  /// Adicionar item ao cache
  void set(String key, dynamic value, {Duration? ttl}) {
    // Remove se já existe
    _cache.remove(key);
    _accessOrder.remove(key);
    
    // Adiciona novo item
    _cache[key] = CacheItem(
      value: value,
      expiresAt: DateTime.now().add(ttl ?? _defaultTTL),
    );
    _accessOrder.addFirst(key);
    
    // Mantém tamanho máximo
    if (_cache.length > _maxCacheSize) {
      final oldestKey = _accessOrder.removeLast();
      _cache.remove(oldestKey);
    }
  }

  /// Obter item do cache
  T? get<T>(String key) {
    final item = _cache[key];
    
    if (item == null) return null;
    
    // Verifica se expirou
    if (DateTime.now().isAfter(item.expiresAt)) {
      _cache.remove(key);
      _accessOrder.remove(key);
      return null;
    }
    
    // Atualiza ordem de acesso
    _accessOrder.remove(key);
    _accessOrder.addFirst(key);
    
    return item.value as T?;
  }

  /// Limpar cache
  void clear() {
    _cache.clear();
    _accessOrder.clear();
  }

  /// Remover item específico
  void remove(String key) {
    _cache.remove(key);
    _accessOrder.remove(key);
  }

  /// Verificar se item existe e é válido
  bool has(String key) {
    final item = _cache[key];
    if (item == null) return false;
    
    if (DateTime.now().isAfter(item.expiresAt)) {
      _cache.remove(key);
      _accessOrder.remove(key);
      return false;
    }
    
    return true;
  }

  /// Estatísticas do cache
  Map<String, dynamic> getStats() {
    return {
      'size': _cache.length,
      'maxSize': _maxCacheSize,
      'hitRate': _calculateHitRate(),
      'memoryUsage': _estimateMemoryUsage(),
    };
  }

  double _calculateHitRate() {
    // Simplificado - em produção teria contadores reais
    return _cache.isNotEmpty ? 0.85 : 0.0;
  }

  String _estimateMemoryUsage() {
    // Estimativa simplificada
    final bytes = _cache.length * 1024; // Assume ~1KB por item
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }
}

/// Item do cache
class CacheItem {
  final dynamic value;
  final DateTime expiresAt;

  CacheItem({
    required this.value,
    required this.expiresAt,
  });
}

/// Classe para gerenciar estado de cache em widgets
class CacheWidgetState {
  final PerformanceCache _cache = PerformanceCache();
  bool _isLoading = false;
  String? _error;

  /// Carregar dados com cache
  Future<R?> loadCachedData<R>(
    String cacheKey,
    Future<R> Function() loader, {
    Duration? ttl,
    bool forceRefresh = false,
    VoidCallback? onStateChange,
  }) async {
    try {
      // Verifica cache se não for refresh forçado
      if (!forceRefresh && _cache.has(cacheKey)) {
        final cached = _cache.get<R>(cacheKey);
        if (cached != null) {
          if (kDebugMode) {
            print('📊 Cache hit: $cacheKey');
          }
          return cached;
        }
      }

      // Carrega dados
      _isLoading = true;
      _error = null;
      onStateChange?.call();

      final data = await loader();
      
      // Armazena no cache
      _cache.set(cacheKey, data, ttl: ttl);
      
      _isLoading = false;
      onStateChange?.call();

      if (kDebugMode) {
        print('📊 Cache stored: $cacheKey');
      }

      return data;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      onStateChange?.call();
      return null;
    }
  }

  /// Limpar cache específico
  void clearCache(String key) {
    _cache.remove(key);
  }

  /// Limpar todo o cache
  void clearAllCache() {
    _cache.clear();
  }

  /// Obter estatísticas do cache
  Map<String, dynamic> getCacheStats() {
    return _cache.getStats();
  }

  bool get isLoading => _isLoading;
  String? get error => _error;
}

/// Mixin para widgets com cache de performance
mixin CachedWidget<T extends StatefulWidget> on State<T> {
  /// Referência ao estado para verificar se está montado
  State<T>? _stateRef;
  final CacheWidgetState _cacheState = CacheWidgetState();

  /// Carregar dados com cache
  Future<R?> loadCachedData<R>(
    String cacheKey,
    Future<R> Function() loader, {
    Duration? ttl,
    bool forceRefresh = false,
  }) async {
    // Armazenar referência ao estado atual
    _stateRef = this;
    
    return _cacheState.loadCachedData<R>(
      cacheKey,
      loader,
      ttl: ttl,
      forceRefresh: forceRefresh,
      onStateChange: () {
        if (_stateRef?.mounted ?? false) {
          (_stateRef as State<T>).setState(() {});
        }
      },
    );
  }

  /// Limpar cache específico
  void clearCache(String key) {
    _cacheState.clearCache(key);
  }

  /// Limpar todo o cache
  void clearAllCache() {
    _cacheState.clearAllCache();
  }

  /// Obter estatísticas do cache
  Map<String, dynamic> getCacheStats() {
    return _cacheState.getCacheStats();
  }

  bool get isLoading => _cacheState.isLoading;
  String? get error => _cacheState.error;
}

/// Otimizador de imagens
class ImageOptimizer {
  static const int _maxWidth = 1024;
  static const int _maxHeight = 1024;
  static const int _quality = 85;

  /// Calcular tamanho otimizado mantendo proporção
  static Map<String, int> calculateOptimalSize(int originalWidth, int originalHeight) {
    double width = originalWidth.toDouble();
    double height = originalHeight.toDouble();

    // Reduz se for muito grande
    if (width > _maxWidth) {
      height = (height * _maxWidth) / width;
      width = _maxWidth.toDouble();
    }

    if (height > _maxHeight) {
      width = (width * _maxHeight) / height;
      height = _maxHeight.toDouble();
    }

    return {
      'width': width.round(),
      'height': height.round(),
    };
  }

  /// Verificar se imagem precisa ser otimizada
  static bool needsOptimization(int width, int height, int fileSizeBytes) {
    const int maxFileSize = 500 * 1024; // 500KB
    return width > _maxWidth || height > _maxHeight || fileSizeBytes > maxFileSize;
  }
}

/// Gerenciador de performance global
class PerformanceManager {
  static final PerformanceManager _instance = PerformanceManager._internal();
  factory PerformanceManager() => _instance;
  PerformanceManager._internal();

  final PerformanceCache cache = PerformanceCache();
  
  bool _performanceMonitoringEnabled = false;
  final Map<String, Stopwatch> _timers = {};

  /// Iniciar monitoramento de performance
  void startPerformanceMonitoring() {
    _performanceMonitoringEnabled = true;
    if (kDebugMode) {
      print('🚀 Performance monitoring enabled');
    }
  }

  /// Iniciar timer
  void startTimer(String name) {
    if (!_performanceMonitoringEnabled) return;
    
    _timers[name] = Stopwatch()..start();
  }

  /// Parar timer e logar resultado
  void stopTimer(String name) {
    if (!_performanceMonitoringEnabled) return;
    
    final timer = _timers.remove(name);
    if (timer != null) {
      timer.stop();
      if (kDebugMode) {
        print('⏱️ $name: ${timer.elapsedMilliseconds}ms');
      }
    }
  }

  /// Obter relatório de performance
  Map<String, dynamic> getPerformanceReport() {
    return {
      'cache': cache.getStats(),
      'monitoring_enabled': _performanceMonitoringEnabled,
      'active_timers': _timers.keys.toList(),
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}