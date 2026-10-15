import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../../model/in_app/inline_in_app_message_data.dart';
import '../../../model/in_app/inline_in_app_size.dart';

typedef InlineInAppViewLoadedCallback = void Function(
    InlineInAppMessageData data);
typedef InlineInAppViewFailedCallback = void Function(
    InlineInAppMessageData data, String error);
typedef InlineInAppViewSizeChangedCallback = void Function(
    InlineInAppMessageData data, InlineInAppSize size);

const String _inlineInAppViewType = 'synerise_flutter_sdk/inline_in_app_view';
const String _inlineInAppViewChannelPrefix =
    'synerise_flutter_sdk/inline_in_app_view';

const String _commandRender = 'render';
const String _commandRelease = 'release';
const String _commandSetPlacementKey = 'setPlacementKey';
const String _commandSetIdentifier = 'setIdentifier';
const String _commandIsRendered = 'isRendered';
const String _commandGetData = 'getData';

const double _androidPlatformViewCreationHeight = 1;

const String _callbackProcessingStarted = 'onProcessingStarted';
const String _callbackLoaded = 'onLoaded';
const String _callbackUpdated = 'onUpdated';
const String _callbackFailed = 'onFailed';
const String _callbackRemove = 'onRemove';
const String _callbackSizeChanged = 'onSizeChanged';

/// Imperatively drives a mounted [InlineInAppView]: triggers an on-demand render, releases the
/// inline in-app while the widget stays mounted, or queries the current campaign.
class InlineInAppViewController {
  MethodChannel? _channel;
  bool _renderPending = false;

  void _attach(MethodChannel channel) {
    _channel = channel;
    if (_renderPending) {
      _renderPending = false;
      channel.invokeMethod(_commandRender);
    }
  }

  void _detach() {
    _channel = null;
    _renderPending = false;
  }

  /// Triggers an ON_DEMAND render for the current placement. If the native view is not attached
  /// yet, the render is deferred and applied as soon as the view becomes ready.
  Future<void> render() async {
    final MethodChannel? channel = _channel;
    if (channel == null) {
      _renderPending = true;
      return;
    }
    await channel.invokeMethod(_commandRender);
  }

  /// Tears the inline in-app down (destroys the WebView / clears data) while the
  /// widget stays mounted.
  Future<void> release() async {
    await _channel?.invokeMethod(_commandRelease);
  }

  /// Resolves `true` when the view currently shows a rendered campaign; `false` when the widget is
  /// not mounted or holds no rendered campaign.
  Future<bool> isRendered() async {
    final MethodChannel? channel = _channel;
    if (channel == null) {
      return false;
    }
    // The iOS bridge may box the flag as a number rather than a boolean, so accept both shapes.
    final Object? reply = await channel.invokeMethod<Object>(_commandIsRendered);
    return reply == true || (reply is num && reply != 0);
  }

  /// Resolves the data of the campaign currently shown in the view; `null` when the widget is not
  /// mounted or holds no rendered campaign.
  Future<InlineInAppMessageData?> getData() async {
    final MethodChannel? channel = _channel;
    if (channel == null) {
      return null;
    }
    final Map? data = await channel.invokeMethod<Map>(_commandGetData);
    if (data == null) {
      return null;
    }
    return InlineInAppMessageData.fromMap(Map<String, dynamic>.from(data));
  }
}

/// A native inline in-app message embedded in the Flutter tree (Android and iOS).
/// Mirrors the native `InlineInAppView`: setting [placementKey] registers the
/// placement and, once on-screen, an AUTOMATIC campaign renders itself; ON_DEMAND
/// campaigns render via an [InlineInAppViewController].
class InlineInAppView extends StatefulWidget {
  final String placementKey;
  final String? identifier;

  /// Set by the SDK when it hands over an already rendered view through
  /// `InjectorInlineInAppMessageListener.onInlineInAppAvailable`. Mounting a widget with this id
  /// shows that exact view instead of rendering the placement again. Leave `null` otherwise.
  final String? adoptViewId;
  final InlineInAppViewController? controller;
  final void Function()? onProcessingStarted;
  final InlineInAppViewLoadedCallback? onLoaded;
  final InlineInAppViewLoadedCallback? onUpdated;
  final InlineInAppViewFailedCallback? onFailed;
  final InlineInAppViewLoadedCallback? onRemove;
  final InlineInAppViewSizeChangedCallback? onSizeChanged;

  const InlineInAppView({
    super.key,
    required this.placementKey,
    this.identifier,
    this.adoptViewId,
    this.controller,
    this.onProcessingStarted,
    this.onLoaded,
    this.onUpdated,
    this.onFailed,
    this.onRemove,
    this.onSizeChanged,
  });

  @override
  State<InlineInAppView> createState() => _InlineInAppViewState();
}

class _InlineInAppViewState extends State<InlineInAppView> {
  MethodChannel? _channel;

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _buildAndroidView();
      case TargetPlatform.iOS:
        return _buildIosView();
      default:
        return const SizedBox.shrink();
    }
  }

  Map<String, dynamic> get _creationParams => <String, dynamic>{
        'placementKey': widget.placementKey,
        'identifier': widget.identifier,
        'adoptViewId': widget.adoptViewId,
      };

  Widget _buildIosView() {
    return UiKitView(
      viewType: _inlineInAppViewType,
      creationParams: _creationParams,
      creationParamsCodec: const StandardMessageCodec(),
      onPlatformViewCreated: _onPlatformViewCreated,
    );
  }

  Widget _buildAndroidView() {
    final Size creationSize = Size(MediaQuery.of(context).size.width, _androidPlatformViewCreationHeight);
    return PlatformViewLink(
      viewType: _inlineInAppViewType,
      surfaceFactory: (context, controller) {
        return AndroidViewSurface(
          controller: controller as AndroidViewController,
          gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
          hitTestBehavior: PlatformViewHitTestBehavior.opaque,
        );
      },
      onCreatePlatformView: (PlatformViewCreationParams params) {
        final AndroidViewController controller =
            PlatformViewsService.initSurfaceAndroidView(
          id: params.id,
          viewType: _inlineInAppViewType,
          layoutDirection: TextDirection.ltr,
          creationParams: _creationParams,
          creationParamsCodec: const StandardMessageCodec(),
          onFocus: () => params.onFocusChanged(true),
        )
          ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
          ..addOnPlatformViewCreatedListener(_onPlatformViewCreated)
          ..create(size: creationSize);
        return controller;
      },
    );
  }

  @override
  void didUpdateWidget(InlineInAppView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.placementKey != widget.placementKey) {
      _channel?.invokeMethod(_commandSetPlacementKey, widget.placementKey);
    }
    if (oldWidget.identifier != widget.identifier) {
      _channel?.invokeMethod(_commandSetIdentifier, widget.identifier);
    }
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._detach();
      if (_channel != null) {
        widget.controller?._attach(_channel!);
      }
    }
  }

  @override
  void dispose() {
    widget.controller?._detach();
    _channel?.setMethodCallHandler(null);
    super.dispose();
  }

  void _onPlatformViewCreated(int viewId) {
    final MethodChannel channel =
        MethodChannel('$_inlineInAppViewChannelPrefix/$viewId');
    channel.setMethodCallHandler(_handleViewCallback);
    _channel = channel;
    widget.controller?._attach(channel);
  }

  Future<dynamic> _handleViewCallback(MethodCall call) async {
    if (call.method == _callbackProcessingStarted) {
      widget.onProcessingStarted?.call();
      return;
    }

    final Map<String, dynamic> arguments = call.arguments != null
        ? Map<String, dynamic>.from(call.arguments)
        : <String, dynamic>{};
    final InlineInAppMessageData data = InlineInAppMessageData.fromMap(
        Map<String, dynamic>.from(arguments['data']));

    switch (call.method) {
      case _callbackLoaded:
        widget.onLoaded?.call(data);
        return;
      case _callbackUpdated:
        widget.onUpdated?.call(data);
        return;
      case _callbackFailed:
        final String error = arguments['error'] ?? '';
        widget.onFailed?.call(data, error);
        return;
      case _callbackRemove:
        widget.onRemove?.call(data);
        return;
      case _callbackSizeChanged:
        widget.onSizeChanged?.call(data, InlineInAppSize.fromMap(arguments));
        return;
    }
  }
}
