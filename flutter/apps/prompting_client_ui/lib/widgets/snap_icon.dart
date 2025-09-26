import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jovial_svg/jovial_svg.dart';
import 'package:prompting_client/prompting_client.dart';
import 'package:ubuntu_logger/ubuntu_logger.dart';

final _log = Logger('snap_icon');

class SnapIcon extends StatelessWidget {
  const SnapIcon({required this.snapIcon, this.dimension = 48, super.key});

  final SnapIconData snapIcon;
  final double dimension;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: dimension,
      child: switch (snapIcon.mimeType) {
        'image/svg+xml' => ScalableImageWidget(
            si: ScalableImage.fromSvgString(
              utf8.decode(snapIcon.bytes),
              warnF: _log.debug,
            ),
          ),
        _ => Image.memory(
            snapIcon.bytes,
            width: dimension,
            height: dimension,
            errorBuilder: (_, e, __) {
              _log.error('Error decoding snap icon: {e}');
              return SizedBox.shrink();
            },
          ),
      },
    );
  }
}
