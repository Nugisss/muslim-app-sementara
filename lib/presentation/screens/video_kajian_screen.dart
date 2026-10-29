import 'package:flutter/material.dart';
import 'package:muslim_app/data/video_data.dart';
import 'package:muslim_app/presentation/screens/video_kajian_detail_screen.dart';

class VideoKajianScreen extends StatefulWidget {
  const VideoKajianScreen({super.key});

  @override
  State<VideoKajianScreen> createState() => _VideoKajianScreenState();
}

class _VideoKajianScreenState extends State<VideoKajianScreen> {
  static const _green = Color(0xFF176B58);
  static const _background = Color(0xFFF7F8F5);
  static const _text = Color(0xFF26332F);
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredVideos = videos.where((video) {
      final query = _searchQuery.toLowerCase();
      return video['title']!.toLowerCase().contains(query) ||
          video['ustadz']!.toLowerCase().contains(query) ||
          video['account']!.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: _green,
        foregroundColor: Colors.white,
        title: const Text(
          'Video Kajian',
          style: TextStyle(fontFamily: 'PoppinsSemiBold', fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value.trim()),
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Cari judul, ustadz, atau kanal',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredVideos.isEmpty
                ? const Center(
                    child: Text(
                      'Video kajian tidak ditemukan.',
                      style: TextStyle(
                        color: _text,
                        fontFamily: 'PoppinsRegular',
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                    itemCount: filteredVideos.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final video = filteredVideos[index];
                      return _VideoCard(
                        video: video,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (context) =>
                                  VideoKajianDetailScreen(video: video),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _VideoCard extends StatelessWidget {
  const _VideoCard({required this.video, required this.onTap});

  final Map<String, String> video;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    video['thumbnail']!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const ColoredBox(
                        color: Color(0xFFE7F3ED),
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: Color(0xFF176B58),
                            size: 36,
                          ),
                        ),
                      );
                    },
                  ),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.58),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video['title']!,
                    style: const TextStyle(
                      color: Color(0xFF26332F),
                      fontFamily: 'PoppinsSemiBold',
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    video['ustadz']!,
                    style: const TextStyle(
                      color: Color(0xFF66736E),
                      fontFamily: 'PoppinsRegular',
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.play_circle_outline_rounded,
                        color: Color(0xFF176B58),
                        size: 17,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          video['account']!,
                          style: const TextStyle(
                            color: Color(0xFF176B58),
                            fontFamily: 'PoppinsMedium',
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Color(0xFF89948F),
                        size: 14,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
