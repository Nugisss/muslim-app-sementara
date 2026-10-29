import 'package:flutter/material.dart';
import 'package:muslim_app/data/doa_data.dart';

class DoaScreen extends StatefulWidget {
  const DoaScreen({super.key});

  @override
  State<DoaScreen> createState() => _DoaScreenState();
}

class _DoaScreenState extends State<DoaScreen> {
  static const _categories = [
    _DoaCategory(
      title: 'Makanan & Minuman',
      subtitle: 'Doa sebelum dan sesudah makan',
      image: 'assets/images/ic_doa_makanan_minuman.png',
      color: Color(0xFFFFF0E7),
    ),
    _DoaCategory(
      title: 'Pagi & Malam',
      subtitle: 'Awali dan akhiri hari dengan doa',
      image: 'assets/images/ic_doa_pagi_malam.png',
      color: Color(0xFFE9F2FF),
    ),
    _DoaCategory(
      title: 'Rumah',
      subtitle: 'Doa untuk aktivitas di rumah',
      image: 'assets/images/ic_doa_rumah.png',
      color: Color(0xFFE9F5EC),
    ),
    _DoaCategory(
      title: 'Perjalanan',
      subtitle: 'Doa saat bepergian',
      image: 'assets/images/ic_doa_perjalanan.png',
      color: Color(0xFFFFF5D9),
    ),
    _DoaCategory(
      title: 'Sholat',
      subtitle: 'Doa wudhu dan masuk masjid',
      image: 'assets/images/ic_doa_sholat.png',
      color: Color(0xFFF0EBFF),
    ),
    _DoaCategory(
      title: 'Etika Baik',
      subtitle: 'Doa dalam berbagai keadaan',
      image: 'assets/images/ic_doa_etika_baik.png',
      color: Color(0xFFFFE9EE),
    ),
  ];

  String _query = '';

  @override
  Widget build(BuildContext context) {
    final visibleCategories = _categories
        .where(
          (category) =>
              category.title.toLowerCase().contains(_query.toLowerCase()),
        )
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F5),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const Text(
                  'Temukan doa sesuai kebutuhanmu',
                  style: TextStyle(
                    color: Color(0xFF26332F),
                    fontFamily: 'PoppinsSemiBold',
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 14),
                _buildSearchField(),
                const SizedBox(height: 18),
                if (visibleCategories.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 36),
                    child: Center(
                      child: Text(
                        'Kategori doa tidak ditemukan.',
                        style: TextStyle(
                          color: Color(0xFF797979),
                          fontFamily: 'PoppinsRegular',
                        ),
                      ),
                    ),
                  )
                else
                  ...visibleCategories.map(_buildCategoryCard),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 245,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg_header_doa.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.12),
              Colors.black.withValues(alpha: 0.55),
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
                      'Doa Harian',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'PoppinsSemiBold',
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Doa yang menemani',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'PoppinsSemiBold',
                        fontSize: 25,
                      ),
                    ),
                    Text(
                      'setiap langkah harimu',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'PoppinsSemiBold',
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Pilih kategori dan temukan doa yang kamu cari.',
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

  Widget _buildSearchField() {
    return TextField(
      onChanged: (value) => setState(() => _query = value.trim()),
      decoration: InputDecoration(
        hintText: 'Cari kategori doa',
        hintStyle: const TextStyle(
          color: Color(0xFF979D99),
          fontFamily: 'PoppinsRegular',
          fontSize: 13,
        ),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: Color(0xFF176B58),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildCategoryCard(_DoaCategory category) {
    final doaCount = getDoaList(category.title).length;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => _openCategory(category),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  height: 62,
                  width: 62,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: category.color,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Image.asset(category.image, fit: BoxFit.contain),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.title,
                        style: const TextStyle(
                          color: Color(0xFF26332F),
                          fontFamily: 'PoppinsSemiBold',
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        category.subtitle,
                        style: const TextStyle(
                          color: Color(0xFF797979),
                          fontFamily: 'PoppinsRegular',
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '$doaCount doa',
                        style: const TextStyle(
                          color: Color(0xFF176B58),
                          fontFamily: 'PoppinsMedium',
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF176B58),
                  size: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openCategory(_DoaCategory category) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => _DoaCategoryScreen(category: category),
      ),
    );
  }
}

class _DoaCategoryScreen extends StatelessWidget {
  const _DoaCategoryScreen({required this.category});

  final _DoaCategory category;

  @override
  Widget build(BuildContext context) {
    final duas = getDoaList(category.title);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F8F5),
        foregroundColor: const Color(0xFF26332F),
        elevation: 0,
        title: Text(
          category.title,
          style: const TextStyle(
            fontFamily: 'PoppinsSemiBold',
            fontSize: 17,
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        itemCount: duas.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _DoaCard(
          doa: duas[index],
          number: index + 1,
        ),
      ),
    );
  }
}

class _DoaCard extends StatelessWidget {
  const _DoaCard({required this.doa, required this.number});

  final Map<String, String> doa;
  final int number;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => _showDoaDetail(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 34,
                    width: 34,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7F3ED),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Text(
                      '$number',
                      style: const TextStyle(
                        color: Color(0xFF176B58),
                        fontFamily: 'PoppinsSemiBold',
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      doa['title'] ?? '',
                      style: const TextStyle(
                        color: Color(0xFF26332F),
                        fontFamily: 'PoppinsSemiBold',
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.open_in_full_rounded,
                    color: Color(0xFF9AA39E),
                    size: 17,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                doa['arabicText'] ?? '',
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  color: Color(0xFF176B58),
                  fontSize: 23,
                  height: 1.8,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                doa['translation'] ?? '',
                style: const TextStyle(
                  color: Color(0xFF555F5A),
                  fontFamily: 'PoppinsRegular',
                  fontSize: 12,
                  height: 1.6,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDoaDetail(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.72,
        minChildSize: 0.45,
        maxChildSize: 0.92,
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF7F8F5),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(22, 12, 22, 30),
            children: [
              Center(
                child: Container(
                  height: 4,
                  width: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD5DAD7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                doa['title'] ?? '',
                style: const TextStyle(
                  color: Color(0xFF26332F),
                  fontFamily: 'PoppinsSemiBold',
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 22),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  doa['arabicText'] ?? '',
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    color: Color(0xFF176B58),
                    fontSize: 27,
                    height: 2,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Arti doa',
                style: TextStyle(
                  color: Color(0xFF26332F),
                  fontFamily: 'PoppinsSemiBold',
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                doa['translation'] ?? '',
                style: const TextStyle(
                  color: Color(0xFF555F5A),
                  fontFamily: 'PoppinsRegular',
                  fontSize: 13,
                  height: 1.7,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Referensi',
                style: TextStyle(
                  color: Color(0xFF26332F),
                  fontFamily: 'PoppinsSemiBold',
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                doa['reference'] ?? '',
                style: const TextStyle(
                  color: Color(0xFF797979),
                  fontFamily: 'PoppinsRegular',
                  fontSize: 12,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DoaCategory {
  const _DoaCategory({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.color,
  });

  final String title;
  final String subtitle;
  final String image;
  final Color color;
}
