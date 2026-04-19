import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../theme/app_colors.dart';

class AvatarViewer extends StatefulWidget {
  final String modelAsset;
  final Color backgroundColor;
  final bool autoRotate;
  final String? cameraOrbit;
  final String? cameraTarget;
  final String? fieldOfView;
  final bool interactionPrompt;
  final bool enableIdleAnimation;

  const AvatarViewer({
    super.key,
    this.modelAsset = 'assets/mii_male/stage_1.glb',
    this.backgroundColor = const Color(0xFFFFFBF5),
    this.autoRotate = false,
    this.cameraOrbit,
    this.cameraTarget,
    this.fieldOfView,
    this.interactionPrompt = true,
    this.enableIdleAnimation = false,
  });

  @override
  State<AvatarViewer> createState() => _AvatarViewerState();
}

class _AvatarViewerState extends State<AvatarViewer> {
  bool _isModelLoaded = false;

  void _onModelLoaded() {
    if (!mounted) return;
    setState(() => _isModelLoaded = true);
  }

  String get _relatedCss => '''
    model-viewer#avatar {
      width: 100%;
      height: 100%;
      transform-origin: center center;
      will-change: transform;
      contain: layout style paint;
      --poster-color: transparent;
      outline: none;
      cursor: default;
      pointer-events: none;
    }
  ''';

  String get _relatedJs {
    return '''
      const mv = document.querySelector('#avatar');
      mv.addEventListener('load', () => {
        if (window.FlutterBridge) FlutterBridge.postMessage('model-loaded');
      });
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ModelViewer(
          id: 'avatar',
          src: widget.modelAsset,
          alt: 'GrowMe Avatar',
          autoRotate: widget.autoRotate,
          cameraControls: false,
          disablePan: true,
          disableZoom: false,
          cameraOrbit: widget.cameraOrbit ?? '0deg 85deg 105%',
          cameraTarget: widget.cameraTarget ?? 'auto auto auto',
          fieldOfView: widget.fieldOfView ?? '45deg',
          minCameraOrbit: 'auto auto 80%',
          maxCameraOrbit: 'auto auto 150%',
          backgroundColor: widget.backgroundColor,
          autoPlay: false,
          loading: Loading.eager,
          reveal: Reveal.auto,
          interpolationDecay: 200,
          shadowIntensity: 0.6,
          shadowSoftness: 0.8,
          debugLogging: false,
          interactionPrompt: widget.interactionPrompt
              ? InteractionPrompt.auto
              : InteractionPrompt.none,
          touchAction: TouchAction.none,
          relatedCss: _relatedCss,
          relatedJs: _relatedJs,
          javascriptChannels: {
            JavascriptChannel(
              'FlutterBridge',
              onMessageReceived: (msg) {
                if (msg.message == 'model-loaded') _onModelLoaded();
              },
            ),
          },
        ),
        // Loading overlay — fades out when model is ready
        IgnorePointer(
          ignoring: _isModelLoaded,
          child: AnimatedOpacity(
            opacity: _isModelLoaded ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 600),
            child: Container(
              color: widget.backgroundColor,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 44,
                      height: 44,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.secondary,
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'アバター読み込み中...',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
