import 'package:flutter/foundation.dart';

import '../channels/channel.dart';
import '../channels/channel_repository.dart';

enum ChannelDirectoryStatus {
  signedOut,
  loading,
  ready,
  failure,
}

/// Coordinates authentication state and an all-or-nothing directory load.
///
/// A failed or incomplete response never reaches the tree. This is important
/// for the entry contract: the UI must not present a partial or stale set of
/// channels as if it were current business data.
class ChannelDirectoryController extends ChangeNotifier {
  ChannelDirectoryController({required ChannelRepository repository})
      : _repository = repository;

  final ChannelRepository _repository;
  ChannelDirectoryStatus _status = ChannelDirectoryStatus.signedOut;
  List<Channel> _channels = const <Channel>[];
  ChannelRepositoryException? _error;
  String? _sessionToken;
  int _requestVersion = 0;
  bool _disposed = false;

  ChannelDirectoryStatus get status => _status;
  List<Channel> get channels => _channels;
  ChannelRepositoryException? get error => _error;
  bool get isAuthenticated => _sessionToken != null;

  /// Starts a fresh directory load after email verification/session setup.
  Future<void> setSessionToken(String? token) async {
    final normalized = token?.trim();
    _sessionToken = normalized == null || normalized.isEmpty ? null : normalized;
    _requestVersion++;

    if (_sessionToken == null) {
      _clearToSignedOut();
      return;
    }
    await load();
  }

  /// Alias used by authentication adapters after verification succeeds.
  Future<void> authenticate(String sessionToken) => setSessionToken(sessionToken);

  void signOut() {
    _sessionToken = null;
    _requestVersion++;
    _clearToSignedOut();
  }

  Future<void> retry() => load();

  Future<void> load() async {
    final token = _sessionToken;
    if (token == null) {
      _clearToSignedOut();
      return;
    }

    final version = ++_requestVersion;
    _status = ChannelDirectoryStatus.loading;
    _channels = const <Channel>[];
    _error = null;
    _notifyIfAlive();

    try {
      final loaded = await _repository.loadChannels(sessionToken: token);
      if (!_isCurrent(version)) {
        return;
      }
      // Validate once more at this boundary for repositories that are not the
      // HTTP implementation (for example, an integration adapter).
      _channels = ChannelDirectory.validate(loaded);
      _status = ChannelDirectoryStatus.ready;
      _error = null;
      _notifyIfAlive();
    } on ChannelRepositoryException catch (error) {
      if (!_isCurrent(version)) {
        return;
      }
      if (error.isUnauthorized) {
        _sessionToken = null;
        _clearToSignedOut();
        return;
      }
      _channels = const <Channel>[];
      _status = ChannelDirectoryStatus.failure;
      _error = error;
      _notifyIfAlive();
    } on FormatException catch (error) {
      if (!_isCurrent(version)) {
        return;
      }
      _channels = const <Channel>[];
      _status = ChannelDirectoryStatus.failure;
      _error = ChannelRepositoryException(
        message: 'The channel service returned an invalid directory: ${error.message}',
        code: 'invalid_channel_directory',
      );
      _notifyIfAlive();
    } on Object catch (error) {
      if (!_isCurrent(version)) {
        return;
      }
      _channels = const <Channel>[];
      _status = ChannelDirectoryStatus.failure;
      _error = ChannelRepositoryException(message: 'Unable to load channels: $error');
      _notifyIfAlive();
    }
  }

  void _clearToSignedOut() {
    _status = ChannelDirectoryStatus.signedOut;
    _channels = const <Channel>[];
    _error = null;
    _notifyIfAlive();
  }

  bool _isCurrent(int version) => !_disposed && version == _requestVersion;

  void _notifyIfAlive() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
