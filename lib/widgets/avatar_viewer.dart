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
    this.modelAsset = 'assets/models/avatar_default.glb',
    this.backgroundColor = const Color(0xFFF5F7FA),
    this.autoRotate = true,
    this.cameraOrbit,
    this.cameraTarget,
    this.fieldOfView,
    this.interactionPrompt = true,
    this.enableIdleAnimation = true,
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
      transform-origin: center bottom;
      will-change: transform;
      contain: layout style paint;
    }
  ''';

  String get _relatedJs {
    final idleCode = widget.enableIdleAnimation
        ? '''
      let t = 0;
      function idle() {
        t += 0.016;
        const breathe = 1 + Math.sin(t * 3.0) * 0.004;
        const sway = Math.sin(t * 0.8) * 0.3;
        mv.style.transform = 'scaleY(' + breathe + ') rotate(' + sway + 'deg)';
        requestAnimationFrame(idle);
      }
      requestAnimationFrame(idle);
    '''
        : '';

    return '''
      const mv = document.querySelector('#avatar');
      mv.addEventListener('load', () => {
        $idleCode
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
          autoRotateDelay: 2000,
          rotationPerSecond: '10deg',
          cameraControls: true,
          disableZoom: false,
          cameraOrbit: widget.cameraOrbit ?? '0deg 85deg 3.5m',
          cameraTarget: widget.cameraTarget ?? '0m 0.85m 0m',
          fieldOfView: widget.fieldOfView ?? '36deg',
          minCameraOrbit: 'auto auto 2.0m',
          maxCameraOrbit: 'auto auto 8m',
          backgroundColor: widget.backgroundColor,
          autoPlay: true,
          loading: Loading.eager,
          reveal: Reveal.auto,
          interpolationDecay: 100,
          shadowIntensity: 0,
          debugLogging: false,
          interactionPrompt: widget.interactionPrompt
              ? InteractionPrompt.auto
              : InteractionPrompt.none,
          touchAction: TouchAction.panY,
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
            duration: const Duration(milliseconds: 500),
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
                      'Loading avatar...',
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
