import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class AvatarViewer extends StatelessWidget {
  final String modelAsset;
  final Color backgroundColor;
  final bool autoRotate;
  final String? cameraOrbit;

  const AvatarViewer({
    super.key,
    this.modelAsset = 'assets/models/avatar_default.glb',
    this.backgroundColor = const Color(0xFFF5F7FA),
    this.autoRotate = true,
    this.cameraOrbit,
  });

  @override
  Widget build(BuildContext context) {
    return ModelViewer(
      src: modelAsset,
      alt: 'GrowMe Avatar',
      autoRotate: autoRotate,
      autoRotateDelay: 0,
      rotationPerSecond: '10deg',
      cameraControls: true,
      disableZoom: false,
      cameraOrbit: cameraOrbit ?? '0deg 80deg 2.5m',
      minCameraOrbit: 'auto auto 1.5m',
      maxCameraOrbit: 'auto auto 5m',
      backgroundColor: backgroundColor,
    );
  }
}
