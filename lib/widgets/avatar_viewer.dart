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
    }
  ''';

  String get _relatedJs {
    if (!widget.enableIdleAnimation) {
      return '''
        const mv = document.querySelector('#avatar');
        mv.addEventListener('load', () => {
          if (window.FlutterBridge) FlutterBridge.postMessage('model-loaded');
        });
      ''';
    }

    return '''
      const mv = document.querySelector('#avatar');

      mv.addEventListener('load', () => {
        // Entrance: gentle fade-up
        mv.style.opacity = '0';
        mv.style.transform = 'translateY(20px)';
        mv.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
        setTimeout(() => {
          mv.style.opacity = '1';
          mv.style.transform = 'translateY(0)';
        }, 80);
        setTimeout(() => {
          mv.style.transition = '';
          tryBoneWave();
          startIdleFloat();
        }, 800);

        if (window.FlutterBridge) FlutterBridge.postMessage('model-loaded');
      });

      /* ---- Try to find arm bones and play a wave "hi" ---- */
      function tryBoneWave() {
        try {
          // Access Three.js scene from model-viewer internals
          var scene = null;
          var symbols = Object.getOwnPropertySymbols(mv);
          for (var i = 0; i < symbols.length; i++) {
            var v = mv[symbols[i]];
            if (v && v.scene) { scene = v.scene; break; }
            if (v && v.modelContainer) { scene = v.modelContainer; break; }
          }
          if (!scene) return;

          // Collect arm / hand bones
          var rArm = null;
          var rForearm = null;
          scene.traverse(function(n) {
            if (!n.isBone) return;
            var nm = n.name.toLowerCase();
            if (!rArm && nm.match(/right.*(upper.*arm|arm.*upper|shoulder)/))
              rArm = n;
            if (!rForearm && nm.match(/right.*(fore.*arm|lower.*arm|hand)/))
              rForearm = n;
          });

          if (!rArm && !rForearm) return;
          var bone = rArm || rForearm;
          var origZ = bone.rotation.z;
          var origX = bone.rotation.x;

          // Raise arm
          var raiseT = 0;
          function raise() {
            raiseT += 0.04;
            if (raiseT <= 1) {
              bone.rotation.z = origZ + (-1.3 - origZ) * easeOut(raiseT);
              requestAnimationFrame(raise);
            } else {
              waveHand(bone, origZ);
            }
          }

          // Wave back and forth 3 times then lower
          function waveHand(b, oz) {
            var wt = 0;
            function wv() {
              wt += 0.06;
              if (wt < Math.PI * 3) {
                b.rotation.z = -1.3 + Math.sin(wt) * 0.35;
                if (rForearm && rForearm !== b)
                  rForearm.rotation.z = Math.sin(wt * 1.5) * 0.25;
                requestAnimationFrame(wv);
              } else {
                lowerArm(b, oz);
              }
            }
            wv();
          }

          // Lower arm back
          function lowerArm(b, oz) {
            var lt = 0;
            function lw() {
              lt += 0.03;
              if (lt <= 1) {
                b.rotation.z = -1.3 + (oz - (-1.3)) * easeIn(lt);
                requestAnimationFrame(lw);
              } else {
                b.rotation.z = oz;

                // Repeat wave every 8-12s
                setTimeout(function() { raiseT = 0; raise(); },
                  8000 + Math.random() * 4000);
              }
            }
            lw();
          }

          function easeOut(x) { return 1 - Math.pow(1 - x, 3); }
          function easeIn(x)  { return x * x; }

          raise();
        } catch(e) { /* bones not accessible – graceful fallback */ }
      }

      /* ---- Gentle idle float (NO body deformation) ---- */
      function startIdleFloat() {
        var t = 0;
        function tick() {
          t += 0.016;
          var floatY = Math.sin(t * 1.0) * 2.0;
          var tilt   = Math.sin(t * 0.5) * 0.4;
          mv.style.transform =
            'translateY(' + floatY + 'px) rotate(' + tilt + 'deg)';
          requestAnimationFrame(tick);
        }
        requestAnimationFrame(tick);
      }
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
          autoRotateDelay: 1500,
          rotationPerSecond: '10deg',
          cameraControls: true,
          disablePan: true,
          disableZoom: false,
          cameraOrbit: widget.cameraOrbit ?? '0deg 85deg 105%',
          cameraTarget: widget.cameraTarget ?? 'auto auto auto',
          fieldOfView: widget.fieldOfView ?? '45deg',
          minCameraOrbit: 'auto auto 80%',
          maxCameraOrbit: 'auto auto 150%',
          backgroundColor: widget.backgroundColor,
          autoPlay: true,
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
