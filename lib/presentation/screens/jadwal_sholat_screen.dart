import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class JadwalSholatScreen extends StatefulWidget {
  const JadwalSholatScreen({super.key});

  @override
  State<JadwalSholatScreen> createState() => _JadwalSholatScreenState();
}

class _JadwalSholatScreenState extends State<JadwalSholatScreen> {
  static const _green = Color(0xFF176B58);
  static const _background = Color(0xFFF7F8F5);
  static const _prayers = [
    _Prayer(
      name: 'Subuh',
      apiKey: 'Fajr',
      asset: 'assets/images/img_clock.png',
    ),
    _Prayer(
      name: 'Dzuhur',
      apiKey: 'Dhuhr',
      asset: 'assets/images/img_clock.png',
    ),
    _Prayer(name: 'Ashar', apiKey: 'Asr', asset: 'assets/images/img_clock.png'),
    _Prayer(
      name: 'Maghrib',
      apiKey: 'Maghrib',
      asset: 'assets/images/img_clock.png',
    ),
    _Prayer(name: 'Isya', apiKey: 'Isha', asset: 'assets/images/img_clock.png'),
  ];

  Timer? _clockTimer;
  bool _isLoading = false;
  String? _errorMessage;
  _PrayerSchedule? _schedule;

  @override
  void initState() {
    super.initState();
    _clockTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted && _schedule != null) setState(() {});
    });
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildLocationCard(),
                const SizedBox(height: 18),
                if (_isLoading)
                  _buildLoadingState()
                else if (_errorMessage != null)
                  _buildErrorState()
                else if (_schedule == null)
                  _buildEmptyState()
                else ...[
                  _buildNextPrayerCard(_schedule!),
                  const SizedBox(height: 22),
                  _buildScheduleTitle(),
                  const SizedBox(height: 12),
                  ..._prayers.map((prayer) => _buildPrayerRow(prayer)),
                  const SizedBox(height: 12),
                  Text(
                    'Metode perhitungan: Kementerian Agama Republik Indonesia (Kemenag). '
                    'Waktu dapat berbeda dari jadwal masjid setempat.',
                    style: TextStyle(
                      color: Colors.black.withValues(alpha: 0.52),
                      fontFamily: 'PoppinsRegular',
                      fontSize: 10,
                      height: 1.5,
                    ),
                  ),
                ],
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final now = DateTime.now();
    return Container(
      height: 245,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg_header_jadwal_sholat.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.10),
              Colors.black.withValues(alpha: 0.56),
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
                    IconButton(
                      onPressed: () => Navigator.maybePop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Jadwal Sholat',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'PoppinsSemiBold',
                        fontSize: 17,
                      ),
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
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Jaga waktu ibadah',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'PoppinsSemiBold',
                        fontSize: 25,
                      ),
                    ),
                    const Text(
                      'Temukan jadwal sholat di sekitarmu.',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'PoppinsRegular',
                        fontSize: 12,
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

  Widget _buildLocationCard() {
    final schedule = _schedule;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFE7F3ED),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.location_on_rounded,
              color: _green,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  schedule == null ? 'Lokasi perangkat' : schedule.timezone,
                  style: const TextStyle(
                    color: Color(0xFF26332F),
                    fontFamily: 'PoppinsSemiBold',
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  schedule == null
                      ? 'Gunakan lokasi saat ini untuk mencari jadwal'
                      : '${schedule.latitude.toStringAsFixed(3)}, '
                            '${schedule.longitude.toStringAsFixed(3)}',
                  style: const TextStyle(
                    color: Color(0xFF797979),
                    fontFamily: 'PoppinsRegular',
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: schedule == null ? 'Gunakan lokasi saya' : 'Perbarui',
            onPressed: _isLoading ? null : _loadSchedule,
            icon: _isLoading
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh_rounded, color: _green),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return _buildMessageCard(
      icon: Icons.my_location_rounded,
      title: 'Jadwal sesuai lokasimu',
      description:
          'Izinkan akses lokasi untuk mengambil jadwal sholat hari ini. '
          'Koordinat akan dikirim ke AlAdhan untuk menghitung jadwal.',
      buttonLabel: 'Gunakan lokasi saya',
      onPressed: _loadSchedule,
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        children: [
          CircularProgressIndicator(color: _green),
          SizedBox(height: 14),
          Text(
            'Mengambil jadwal sholat...',
            style: TextStyle(
              color: Color(0xFF555F5A),
              fontFamily: 'PoppinsMedium',
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return _buildMessageCard(
      icon: Icons.location_off_rounded,
      title: 'Jadwal belum tersedia',
      description: _errorMessage!,
      buttonLabel: 'Coba lagi',
      onPressed: _loadSchedule,
    );
  }

  Widget _buildMessageCard({
    required IconData icon,
    required String title,
    required String description,
    required String buttonLabel,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(icon, color: _green, size: 34),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF26332F),
              fontFamily: 'PoppinsSemiBold',
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF797979),
              fontFamily: 'PoppinsRegular',
              fontSize: 11,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 14),
          FilledButton(
            onPressed: onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: _green,
              foregroundColor: Colors.white,
            ),
            child: Text(
              buttonLabel,
              style: const TextStyle(
                fontFamily: 'PoppinsMedium',
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextPrayerCard(_PrayerSchedule schedule) {
    final nextPrayer = _nextPrayer(schedule);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _green,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SHOLAT BERIKUTNYA',
                  style: TextStyle(
                    color: Color(0xFFD8EEE6),
                    fontFamily: 'PoppinsMedium',
                    fontSize: 10,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  nextPrayer.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'PoppinsSemiBold',
                    fontSize: 22,
                  ),
                ),
                Text(
                  nextPrayer.isTomorrow
                      ? 'Besok, pukul ${nextPrayer.time}'
                      : 'Pukul ${nextPrayer.time}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'PoppinsRegular',
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.access_time_rounded,
            color: Colors.white,
            size: 32,
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleTitle() {
    return const Text(
      'Waktu sholat hari ini',
      style: TextStyle(
        color: Color(0xFF26332F),
        fontFamily: 'PoppinsSemiBold',
        fontSize: 17,
      ),
    );
  }

  Widget _buildPrayerRow(_Prayer prayer) {
    final time = _schedule!.timings[prayer.apiKey];
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            height: 38,
            width: 38,
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: const Color(0xFFE7F3ED),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(prayer.asset, fit: BoxFit.contain),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              prayer.name,
              style: const TextStyle(
                color: Color(0xFF26332F),
                fontFamily: 'PoppinsMedium',
                fontSize: 13,
              ),
            ),
          ),
          Text(
            time ?? '--:--',
            style: const TextStyle(
              color: _green,
              fontFamily: 'PoppinsSemiBold',
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  _NextPrayer _nextPrayer(_PrayerSchedule schedule) {
    final now = DateTime.now();
    for (final prayer in _prayers) {
      final time = schedule.timings[prayer.apiKey];
      if (time == null) continue;
      final parts = time.split(':');
      final prayerTime = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );
      if (prayerTime.isAfter(now)) {
        return _NextPrayer(name: prayer.name, time: time);
      }
    }

    return _NextPrayer(
      name: _prayers.first.name,
      time: schedule.tomorrowFajr ?? '--:--',
      isTomorrow: true,
    );
  }

  Future<void> _loadSchedule() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final position = await _getCurrentPosition();
      final today = DateTime.now();
      final tomorrow = today.add(const Duration(days: 1));
      final schedules = await Future.wait([
        _fetchSchedule(position, date: today),
        _fetchSchedule(position, date: tomorrow),
      ]);
      final schedule = schedules.first.copyWith(
        tomorrowFajr: schedules.last.timings['Fajr'],
      );
      if (!mounted) return;
      setState(() {
        _schedule = schedule;
        _isLoading = false;
      });
    } on _LocationException catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = error.message;
        _isLoading = false;
      });
    } on TimeoutException {
      if (!mounted) return;
      setState(() {
        _errorMessage = kIsWeb
            ? 'Permintaan lokasi terlalu lama. Izinkan lokasi di browser, '
                  'dan buka aplikasi melalui HTTPS atau localhost.'
            : 'Pengambilan lokasi atau jadwal terlalu lama. Periksa izin '
                  'lokasi dan koneksi internet lalu coba lagi.';
        _isLoading = false;
      });
    } on FormatException {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Data jadwal dari layanan tidak dapat dibaca.';
        _isLoading = false;
      });
    } on http.ClientException catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage =
            'Koneksi ke layanan jadwal gagal: $error. Periksa internet lalu coba lagi.';
        _isLoading = false;
      });
    } on _ScheduleException catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = error.message;
        _isLoading = false;
      });
    } on PlatformException catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage =
            'Layanan lokasi gagal (${error.code}). Periksa izin lokasi dan '
            'konfigurasi platform aplikasi.';
        _isLoading = false;
      });
    } on MissingPluginException {
      if (!mounted) return;
      setState(() {
        _errorMessage =
            'Plugin lokasi belum tersedia. Jalankan ulang aplikasi setelah '
            'memasang dependensi.';
        _isLoading = false;
      });
    } finally {
      if (mounted && _isLoading) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<Position> _getCurrentPosition() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw const _LocationException(
          'Layanan lokasi perangkat sedang mati. Aktifkan lokasi lalu coba lagi.',
        );
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied && !kIsWeb) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied && !kIsWeb) {
        throw const _LocationException(
          'Izin lokasi belum diberikan. Izinkan akses lokasi untuk mendapatkan jadwal.',
        );
      }
      if (permission == LocationPermission.deniedForever) {
        throw const _LocationException(
          'Izin lokasi ditolak. Aktifkan izin lokasi aplikasi melalui '
          'pengaturan perangkat atau izin situs di browser.',
        );
      }

      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 20),
        ),
      ).timeout(const Duration(seconds: 25));
    } on LocationServiceDisabledException {
      throw const _LocationException(
        'Layanan lokasi perangkat sedang mati. Aktifkan lokasi lalu coba lagi.',
      );
    } on PermissionDeniedException {
      throw const _LocationException(
        'Izin lokasi tidak tersedia. Periksa izin aplikasi lalu coba lagi.',
      );
    } on PermissionDefinitionsNotFoundException {
      throw const _LocationException(
        'Konfigurasi izin lokasi tidak ditemukan. Periksa konfigurasi platform aplikasi.',
      );
    } on InvalidPermissionException {
      throw const _LocationException(
        'Izin lokasi tidak valid. Periksa pengaturan izin aplikasi.',
      );
    } on ActivityMissingException {
      throw const _LocationException(
        'Aktivitas aplikasi tidak tersedia untuk meminta lokasi.',
      );
    } on PositionUpdateException catch (error) {
      throw _LocationException(
        kIsWeb
            ? 'Lokasi browser gagal diperoleh. Pastikan aplikasi dibuka melalui '
                  'HTTPS atau localhost dan izin lokasi browser aktif. $error'
            : 'Lokasi perangkat gagal diperoleh: $error',
      );
    }
  }

  Future<_PrayerSchedule> _fetchSchedule(
    Position position, {
    required DateTime date,
  }) async {
    final datePath =
        '${date.day.toString().padLeft(2, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-${date.year}';
    final uri = Uri.https(
      'api.aladhan.com',
      '/v1/timings/$datePath',
      {
        'latitude': position.latitude.toString(),
        'longitude': position.longitude.toString(),
        'method': '20',
      },
    );
    final response = await http.get(uri).timeout(const Duration(seconds: 20));
    if (response.statusCode != 200) {
      throw _ScheduleException(
        'Layanan jadwal sholat membalas ${response.statusCode}.',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic> ||
        decoded['code'] != 200 ||
        decoded['data'] is! Map<String, dynamic>) {
      throw const FormatException('Respons jadwal tidak valid.');
    }

    final data = decoded['data'] as Map<String, dynamic>;
    final timings = data['timings'];
    final meta = data['meta'];
    if (timings is! Map<String, dynamic> || meta is! Map<String, dynamic>) {
      throw const FormatException('Waktu sholat tidak tersedia.');
    }

    final parsedTimings = <String, String>{};
    for (final prayer in _prayers) {
      final value = timings[prayer.apiKey];
      if (value is! String) {
        throw FormatException('Waktu ${prayer.name} tidak tersedia.');
      }
      final match = RegExp(r'^(\d{1,2}:\d{2})').firstMatch(value.trim());
      if (match == null) {
        throw FormatException('Format waktu ${prayer.name} tidak valid.');
      }
      parsedTimings[prayer.apiKey] = match.group(1)!;
    }

    return _PrayerSchedule(
      latitude: position.latitude,
      longitude: position.longitude,
      timezone: meta['timezone'] is String
          ? meta['timezone'] as String
          : 'Lokasi saat ini',
      timings: parsedTimings,
    );
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

class _Prayer {
  const _Prayer({
    required this.name,
    required this.apiKey,
    required this.asset,
  });

  final String name;
  final String apiKey;
  final String asset;
}

class _PrayerSchedule {
  const _PrayerSchedule({
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.timings,
    this.tomorrowFajr,
  });

  final double latitude;
  final double longitude;
  final String timezone;
  final Map<String, String> timings;
  final String? tomorrowFajr;

  _PrayerSchedule copyWith({String? tomorrowFajr}) {
    return _PrayerSchedule(
      latitude: latitude,
      longitude: longitude,
      timezone: timezone,
      timings: timings,
      tomorrowFajr: tomorrowFajr,
    );
  }
}

class _NextPrayer {
  const _NextPrayer({
    required this.name,
    required this.time,
    this.isTomorrow = false,
  });

  final String name;
  final String time;
  final bool isTomorrow;
}

class _LocationException implements Exception {
  const _LocationException(this.message);

  final String message;
}

class _ScheduleException implements Exception {
  const _ScheduleException(this.message);

  final String message;
}
