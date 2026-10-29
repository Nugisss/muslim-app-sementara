import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoKajianDetailScreen extends StatefulWidget {
  const VideoKajianDetailScreen({required this.video, super.key});

  final Map<String, String> video;

  @override
  State<VideoKajianDetailScreen> createState() =>
      _VideoKajianDetailScreenState();
}

class _VideoKajianDetailScreenState extends State<VideoKajianDetailScreen> {
  YoutubePlayerController? _playerController;

  @override
  void initState() {
    super.initState();
    final videoId = _videoIdFromUrl(widget.video['url'] ?? '');
    if (videoId != null) {
      _playerController = YoutubePlayerController.fromVideoId(
        videoId: videoId,
        params: const YoutubePlayerParams(
          showControls: true,
          showFullscreenButton: true,
        ),
      );
    }
  }

  @override
  void dispose() {
    _playerController?.close();
    super.dispose();
  }

  String? _videoIdFromUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return null;

    if (uri.host == 'youtu.be' || uri.host.endsWith('.youtu.be')) {
      final id = uri.pathSegments.isEmpty ? null : uri.pathSegments.first;
      return id == null || id.isEmpty ? null : id;
    }

    if (uri.host == 'youtube.com' || uri.host.endsWith('.youtube.com')) {
      final id = uri.queryParameters['v'];
      return id == null || id.isEmpty ? null : id;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF176B58);
    final playerController = _playerController;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F5),
      appBar: AppBar(
        backgroundColor: green,
        foregroundColor: Colors.white,
        title: const Text(
          'Detail Kajian',
          style: TextStyle(fontFamily: 'PoppinsSemiBold', fontSize: 18),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 28),
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: playerController == null
                ? Image.asset(
                    widget.video['thumbnail']!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const ColoredBox(
                        color: Color(0xFFE7F3ED),
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: green,
                            size: 40,
                          ),
                        ),
                      );
                    },
                  )
                : YoutubePlayer(
                    controller: playerController,
                    aspectRatio: 16 / 9,
                    autoFullScreen: false,
                  ),
          ),
          if (playerController == null)
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Text(
                'Tautan video tidak valid sehingga video tidak dapat diputar.',
                style: TextStyle(
                  color: Color(0xFF9B3D32),
                  fontFamily: 'PoppinsRegular',
                  fontSize: 12,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.video['title']!,
                  style: const TextStyle(
                    color: Color(0xFF26332F),
                    fontFamily: 'PoppinsSemiBold',
                    fontSize: 21,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.video['ustadz']!,
                  style: const TextStyle(
                    color: green,
                    fontFamily: 'PoppinsMedium',
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.video['account']!,
                  style: const TextStyle(
                    color: Color(0xFF66736E),
                    fontFamily: 'PoppinsRegular',
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  'Tentang kajian',
                  style: TextStyle(
                    color: Color(0xFF26332F),
                    fontFamily: 'PoppinsSemiBold',
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.video['description']!,
                  style: const TextStyle(
                    color: Color(0xFF53615B),
                    fontFamily: 'PoppinsRegular',
                    fontSize: 13,
                    height: 1.7,
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
