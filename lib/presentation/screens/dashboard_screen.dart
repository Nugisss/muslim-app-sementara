import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const Color _green = Color(0xFF176B58);
  static const Color _background = Color(0xFFF7F8F5);
  static const Color _text = Color(0xFF26332F);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final greeting = _greetingFor(now.hour);
    final headerImage = _headerImageFor(now.hour);

    return Scaffold(
      backgroundColor: _background,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildHeader(greeting, headerImage, now),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Menu utama',
                  style: TextStyle(
                    color: _text,
                    fontFamily: 'PoppinsSemiBold',
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 14),
                _buildMenuGrid(context),
                const SizedBox(height: 26),
                _buildPrayerCard(context),
                const SizedBox(height: 26),
                _buildInspirationGallery(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String greeting, String image, DateTime now) {
    return Container(
      height: 276,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.12),
              Colors.black.withValues(alpha: 0.48),
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 14, 22, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.mosque_rounded, color: Colors.white),
                    const SizedBox(width: 8),
                    const Text(
                      'Muslim App',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'PoppinsSemiBold',
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.notifications_none_rounded,
                      color: Colors.white,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatDate(now),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontFamily: 'PoppinsMedium',
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      greeting,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'PoppinsSemiBold',
                        fontSize: 27,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Semoga harimu dipenuhi keberkahan.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.92),
                        fontFamily: 'PoppinsRegular',
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    const items = [
      _DashboardMenuItem(
        title: 'Jadwal Sholat',
        image: 'assets/images/ic_menu_jadwal_sholat.png',
        route: '/jadwal-sholat',
        color: Color(0xFFE7F3ED),
      ),
      _DashboardMenuItem(
        title: 'Doa Harian',
        image: 'assets/images/ic_menu_doa.png',
        route: '/doa',
        color: Color(0xFFFFF0E7),
      ),
      _DashboardMenuItem(
        title: 'Zakat',
        image: 'assets/images/ic_menu_zakat.png',
        route: '/zakat',
        color: Color(0xFFF1EDFF),
      ),
      _DashboardMenuItem(
        title: 'Video Kajian',
        image: 'assets/images/ic_menu_video_kajian.png',
        route: '/video-kajian',
        color: Color(0xFFE8F1FF),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.65,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => Navigator.pushNamed(context, item.route),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: item.color,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.all(9),
                    child: Image.asset(item.image, fit: BoxFit.contain),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.title,
                      style: const TextStyle(
                        color: _text,
                        fontFamily: 'PoppinsMedium',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPrayerCard(BuildContext context) {
    return Material(
      color: _green,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.pushNamed(context, '/jadwal-sholat'),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(9),
                child: Image.asset(
                  'assets/images/img_clock.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jaga waktu sholatmu',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'PoppinsSemiBold',
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Lihat jadwal sholat hari ini',
                      style: TextStyle(
                        color: Color(0xFFD8EEE6),
                        fontFamily: 'PoppinsRegular',
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInspirationGallery() {
    const images = [
      'assets/images/img_inspiration.png',
      'assets/images/img_inspiration_2.jpeg',
      'assets/images/img_inspiration_3.jpeg',
      'assets/images/img_inspiration_4.jpeg',
      'assets/images/img_inspiration_5.jpeg',
      'assets/images/img_inspiration_6.jpeg',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Inspirasi untukmu',
          style: TextStyle(
            color: _text,
            fontFamily: 'PoppinsSemiBold',
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 170,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: SizedBox(
                  width: 260,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        images[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const ColoredBox(
                            color: Color(0xFFE7F3ED),
                            child: Center(
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                color: _green,
                                size: 32,
                              ),
                            ),
                          );
                        },
                      ),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Color(0xCC163F35)],
                          ),
                        ),
                      ),
                      const Positioned(
                        left: 16,
                        right: 16,
                        bottom: 14,
                        child: Text(
                          'Luangkan waktu untuk mengingat kebaikan hari ini',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'PoppinsMedium',
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _greetingFor(int hour) {
    if (hour < 11) return 'Assalamualaikum,\nSelamat pagi';
    if (hour < 15) return 'Assalamualaikum,\nSelamat siang';
    if (hour < 18) return 'Assalamualaikum,\nSelamat sore';
    return 'Assalamualaikum,\nSelamat malam';
  }

  String _headerImageFor(int hour) {
    if (hour < 11) return 'assets/images/bg_header_dashboard_morning.png';
    if (hour < 18) return 'assets/images/bg_header_dashboard_afternoon.png';
    return 'assets/images/bg_header_dashboard_night.png';
  }

  String _formatDate(DateTime date) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    const weekdays = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    return '${weekdays[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

class _DashboardMenuItem {
  const _DashboardMenuItem({
    required this.title,
    required this.image,
    required this.route,
    required this.color,
  });

  final String title;
  final String image;
  final String route;
  final Color color;
}
