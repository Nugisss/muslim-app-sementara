import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ZakatScreen extends StatefulWidget {
  const ZakatScreen({super.key});

  @override
  State<ZakatScreen> createState() => _ZakatScreenState();
}

class _ZakatScreenState extends State<ZakatScreen> {
  static const _green = Color(0xFF176B58);
  static const _text = Color(0xFF26332F);
  static const _background = Color(0xFFF7F8F5);
  static const _moneyNisab = 85000000.0;

  final _wealthController = TextEditingController();
  final _goldPriceController = TextEditingController();
  final _goldGramsController = TextEditingController();
  final _silverGramsController = TextEditingController();
  final _silverPriceController = TextEditingController();
  final _livestockCountController = TextEditingController();
  final _cropWeightController = TextEditingController();
  bool _goldHaulCompleted = false;
  bool _silverHaulCompleted = false;
  bool _livestockHaulCompleted = false;
  _ZakatCategory _selectedCategory = _ZakatCategory.money;
  _LivestockType _livestockType = _LivestockType.goatSheep;
  _CropType _cropType = _CropType.rice;
  _IrrigationType _irrigationType = _IrrigationType.irrigated;

  @override
  void dispose() {
    _wealthController.dispose();
    _goldPriceController.dispose();
    _goldGramsController.dispose();
    _silverGramsController.dispose();
    _silverPriceController.dispose();
    _livestockCountController.dispose();
    _cropWeightController.dispose();
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
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildIntroCard(),
                const SizedBox(height: 24),
                _buildSectionTitle('Jenis zakat'),
                const SizedBox(height: 12),
                _buildZakatTypes(),
                const SizedBox(height: 24),
                _buildCalculator(),
                const SizedBox(height: 16),
                _buildDisclaimer(),
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
          image: AssetImage('assets/images/bg_header_zakat.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.1),
              Colors.black.withValues(alpha: 0.58),
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
                      'Zakat',
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
                      'Bersihkan harta,',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'PoppinsSemiBold',
                        fontSize: 25,
                      ),
                    ),
                    Text(
                      'sempurnakan kepedulian',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'PoppinsSemiBold',
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Kenali zakat dan hitung perkiraan zakat maal.',
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

  Widget _buildIntroCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            height: 56,
            width: 56,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFE7F3ED),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Image.asset(
              'assets/images/ic_menu_zakat.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Zakat membawa keberkahan',
                  style: TextStyle(
                    color: _text,
                    fontFamily: 'PoppinsSemiBold',
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Pelajari jenis zakat dan sesuaikan perhitungan dengan ketentuan yang berlaku.',
                  style: TextStyle(
                    color: Color(0xFF797979),
                    fontFamily: 'PoppinsRegular',
                    fontSize: 10,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: _text,
        fontFamily: 'PoppinsSemiBold',
        fontSize: 17,
      ),
    );
  }

  Widget _buildZakatTypes() {
    const types = [
      _ZakatType(
        title: 'Zakat Fitrah',
        description: 'Ditunaikan menjelang Idulfitri untuk setiap jiwa yang memenuhi kewajiban.',
        icon: Icons.volunteer_activism_rounded,
        color: Color(0xFFFFF0E7),
      ),
      _ZakatType(
        title: 'Zakat Maal',
        description: 'Zakat atas harta yang memenuhi nisab dan haul sesuai jenis hartanya.',
        icon: Icons.account_balance_wallet_rounded,
        color: Color(0xFFE7F3ED),
      ),
      _ZakatType(
        title: 'Zakat Penghasilan',
        description: 'Perhitungannya mengikuti ketentuan dan panduan lembaga zakat setempat.',
        icon: Icons.work_outline_rounded,
        color: Color(0xFFE9F2FF),
      ),
    ];

    return Column(
      children: types
          .map(
            (type) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(17),
              ),
              child: Row(
                children: [
                  Container(
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      color: type.color,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(type.icon, color: _green, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          type.title,
                          style: const TextStyle(
                            color: _text,
                            fontFamily: 'PoppinsSemiBold',
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          type.description,
                          style: const TextStyle(
                            color: Color(0xFF797979),
                            fontFamily: 'PoppinsRegular',
                            fontSize: 10,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildCalculator() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kalkulator zakat',
            style: TextStyle(
              color: _text,
              fontFamily: 'PoppinsSemiBold',
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Pilih jenis harta untuk melihat nisab dan perkiraan zakatnya.',
            style: TextStyle(
              color: Color(0xFF797979),
              fontFamily: 'PoppinsRegular',
              fontSize: 10,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _ZakatCategory.values.map((category) {
              return ChoiceChip(
                label: Text(category.label),
                selected: category == _selectedCategory,
                selectedColor: const Color(0xFFE7F3ED),
                labelStyle: TextStyle(
                  color: category == _selectedCategory ? _green : _text,
                  fontFamily: 'PoppinsMedium',
                  fontSize: 11,
                ),
                onSelected: (_) => setState(() => _selectedCategory = category),
              );
            }).toList(),
          ),
          const SizedBox(height: 18),
          switch (_selectedCategory) {
            _ZakatCategory.money => _buildMoneyCalculator(),
            _ZakatCategory.gold => _buildMetalCalculator(isGold: true),
            _ZakatCategory.silver => _buildMetalCalculator(isGold: false),
            _ZakatCategory.livestock => _buildLivestockCalculator(),
            _ZakatCategory.crops => _buildCropCalculator(),
          },
        ],
      ),
    );
  }

  Widget _buildMoneyCalculator() {
    final wealth = _parseAmount(_wealthController.text);
    final meetsNisab = wealth >= _moneyNisab;
    final zakatDue = meetsNisab ? wealth * 0.025 : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNisabInfo(
          'Patokan nisab uang yang digunakan ${_formatRupiah(_moneyNisab)}, '
          'setara nilai 85 gram emas. Zakat dihitung 2,5% jika harta mencapai '
          'nisab dan telah dimiliki satu haul (tahun hijriah).',
        ),
        const SizedBox(height: 14),
        _buildAmountField(
          controller: _wealthController,
          label: 'Harta yang dimiliki (Rp)',
          hint: 'Masukkan jumlah harta',
        ),
        const SizedBox(height: 8),
        _buildResultCard(
          title: wealth <= 0
              ? 'Masukkan jumlah harta'
              : !meetsNisab
              ? 'Belum mencapai nisab'
              : 'Perkiraan zakat uang',
          amount: meetsNisab ? _formatRupiah(zakatDue) : null,
          detail: wealth > 0
              ? 'Harta ${_formatRupiah(wealth)} dari nisab '
                    '${_formatRupiah(_moneyNisab)}.'
              : 'Nisab uang setara nilai 85 gram emas.',
        ),
      ],
    );
  }

  Widget _buildMetalCalculator({required bool isGold}) {
    final gramsController = isGold
        ? _goldGramsController
        : _silverGramsController;
    final priceController = isGold
        ? _goldPriceController
        : _silverPriceController;
    final grams = _parseAmount(gramsController.text);
    final price = _parseAmount(priceController.text);
    final nisabGrams = isGold ? 85.0 : 595.0;
    final meetsNisab = grams >= nisabGrams;
    final haulCompleted = isGold ? _goldHaulCompleted : _silverHaulCompleted;
    final dueGrams = meetsNisab && haulCompleted ? grams * 0.025 : 0.0;
    final metalName = isGold ? 'emas' : 'perak';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNisabInfo(
          isGold
              ? 'Nisab emas 85 gram. Jika telah dimiliki satu haul, zakatnya '
                    '2,5% dari jumlah emas.'
              : 'Nisab perak 595 gram. Jika telah dimiliki satu haul, zakatnya '
                    '2,5% dari jumlah perak.',
        ),
        const SizedBox(height: 14),
        _buildDecimalField(
          controller: gramsController,
          label: 'Berat $metalName (gram)',
          hint: isGold ? 'Contoh: 100' : 'Contoh: 600',
        ),
        const SizedBox(height: 12),
        _buildAmountField(
          controller: priceController,
          label: 'Harga $metalName per gram (Rp, opsional)',
          hint: 'Untuk melihat nilai zakat dalam rupiah',
        ),
        const SizedBox(height: 8),
        _buildHaulCheckbox(
          value: haulCompleted,
          onChanged: (value) {
            if (isGold) {
              _goldHaulCompleted = value;
            } else {
              _silverHaulCompleted = value;
            }
          },
        ),
        const SizedBox(height: 8),
        _buildResultCard(
          title: grams <= 0
              ? 'Masukkan berat $metalName'
              : !meetsNisab
              ? 'Belum mencapai nisab'
              : !haulCompleted
              ? 'Nisab tercapai; haul belum terpenuhi'
              : 'Perkiraan zakat $metalName',
          amount: meetsNisab && haulCompleted
              ? '${_formatDecimal(dueGrams)} gram'
              : null,
          detail: grams > 0
              ? 'Berat ${_formatDecimal(grams)} gram dari nisab '
                    '${_formatDecimal(nisabGrams)} gram.'
              : 'Zakat emas dan perak sebesar 2,5% jika nisab dan haul terpenuhi.',
          supportingText: dueGrams > 0 && price > 0
              ? 'Setara sekitar ${_formatRupiah(dueGrams * price)}.'
              : null,
        ),
      ],
    );
  }

  Widget _buildLivestockCalculator() {
    final count = _parseAmount(_livestockCountController.text).floor();
    final isCattle = _livestockType == _LivestockType.cattle;
    final nisab = isCattle ? 30 : 40;
    final meetsNisab = count >= nisab;
    final dues = meetsNisab && _livestockHaulCompleted
        ? _livestockDue(count, _livestockType)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNisabInfo(
          isCattle
              ? 'Nisab sapi/kerbau 30 ekor. Zakat ternak memiliki hitungan '
                    'khusus, bukan 2,5% dari jumlah ekor.'
              : 'Nisab kambing/domba 40 ekor. Zakat ternak memiliki hitungan '
                    'khusus, bukan 2,5% dari jumlah ekor.',
        ),
        const SizedBox(height: 14),
        DropdownButtonFormField<_LivestockType>(
          initialValue: _livestockType,
          decoration: _dropdownDecoration('Jenis ternak'),
          items: _LivestockType.values
              .map(
                (type) => DropdownMenuItem(
                  value: type,
                  child: Text(type.label),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) setState(() => _livestockType = value);
          },
        ),
        const SizedBox(height: 12),
        _buildDecimalField(
          controller: _livestockCountController,
          label: 'Jumlah ternak (ekor)',
          hint: 'Masukkan jumlah ekor',
          allowDecimal: false,
        ),
        const SizedBox(height: 8),
        _buildHaulCheckbox(
          value: _livestockHaulCompleted,
          onChanged: (value) => _livestockHaulCompleted = value,
          label: 'Ternak dimiliki satu haul dan digembalakan',
        ),
        const SizedBox(height: 8),
        _buildResultCard(
          title: count <= 0
              ? 'Masukkan jumlah ternak'
              : !meetsNisab
              ? 'Belum mencapai nisab'
              : !_livestockHaulCompleted
              ? 'Nisab tercapai; haul belum dikonfirmasi'
              : 'Perkiraan zakat ternak',
          amount: dues?.label,
          detail: 'Jumlah $count ekor; nisab ${_formatInteger(nisab)} ekor.',
          supportingText: dues?.description,
        ),
      ],
    );
  }

  Widget _buildCropCalculator() {
    final weight = _parseAmount(_cropWeightController.text);
    final isRice = _cropType == _CropType.rice;
    final nisabKg = isRice ? 520.0 : 653.0;
    final meetsNisab = weight >= nisabKg;
    final rate = switch (_irrigationType) {
      _IrrigationType.rainFed => 0.10,
      _IrrigationType.irrigated => 0.05,
      _IrrigationType.mixed => 0.075,
    };
    final due = meetsNisab ? weight * rate : 0.0;
    final unit = isRice ? 'kg beras' : 'kg gabah';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNisabInfo(
          isRice
              ? 'Nisab hasil panen setara 5 wasaq, diperkirakan 520 kg beras '
                    'bersih. Zakat dikeluarkan saat panen; tidak menunggu haul.'
              : 'Nisab hasil panen setara 5 wasaq, diperkirakan 653 kg gabah '
                    'kering giling. Zakat dikeluarkan saat panen; tidak menunggu haul.',
        ),
        const SizedBox(height: 14),
        DropdownButtonFormField<_CropType>(
          initialValue: _cropType,
          decoration: _dropdownDecoration('Satuan hasil panen'),
          items: _CropType.values
              .map(
                (type) => DropdownMenuItem(
                  value: type,
                  child: Text(type.label),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) setState(() => _cropType = value);
          },
        ),
        const SizedBox(height: 12),
        _buildDecimalField(
          controller: _cropWeightController,
          label: 'Berat hasil panen ($unit)',
          hint: 'Masukkan berat hasil panen',
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<_IrrigationType>(
          initialValue: _irrigationType,
          decoration: _dropdownDecoration('Sumber pengairan'),
          items: _IrrigationType.values
              .map(
                (type) => DropdownMenuItem(
                  value: type,
                  child: Text(type.label),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) setState(() => _irrigationType = value);
          },
        ),
        const SizedBox(height: 8),
        _buildResultCard(
          title: weight <= 0
              ? 'Masukkan berat hasil panen'
              : !meetsNisab
              ? 'Belum mencapai nisab panen'
              : 'Perkiraan zakat hasil panen',
          amount: meetsNisab ? '${_formatDecimal(due)} $unit' : null,
          detail:
              'Hasil panen ${_formatDecimal(weight)} $unit dari nisab '
              '${_formatDecimal(nisabKg)} $unit.',
          supportingText: meetsNisab
              ? 'Kadar ${_formatPercent(rate)} sesuai pengairan '
                    '${_irrigationType.label.toLowerCase()}.'
              : 'Kadar zakat panen 5%–10% bergantung pada pengairan.',
        ),
      ],
    );
  }

  Widget _buildNisabInfo(String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F6F2),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: _green, size: 18),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF52625A),
                fontFamily: 'PoppinsRegular',
                fontSize: 10,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHaulCheckbox({
    required bool value,
    required ValueChanged<bool> onChanged,
    String label = 'Harta dimiliki selama satu haul (tahun hijriah)',
  }) {
    return Material(
      color: Colors.transparent,
      child: CheckboxListTile(
        value: value,
        onChanged: (checked) => setState(() => onChanged(checked ?? false)),
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: _green,
        title: Text(
          label,
          style: const TextStyle(
            color: _text,
            fontFamily: 'PoppinsRegular',
            fontSize: 10,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard({
    required String title,
    required String detail,
    String? amount,
    String? supportingText,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE7F3ED),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: _green,
              fontFamily: 'PoppinsSemiBold',
              fontSize: 11,
            ),
          ),
          if (amount != null) ...[
            const SizedBox(height: 5),
            Text(
              amount,
              style: const TextStyle(
                color: _text,
                fontFamily: 'PoppinsSemiBold',
                fontSize: 18,
              ),
            ),
          ],
          const SizedBox(height: 5),
          Text(
            detail,
            style: const TextStyle(
              color: Color(0xFF52625A),
              fontFamily: 'PoppinsRegular',
              fontSize: 10,
              height: 1.5,
            ),
          ),
          if (supportingText != null) ...[
            const SizedBox(height: 4),
            Text(
              supportingText,
              style: const TextStyle(
                color: Color(0xFF52625A),
                fontFamily: 'PoppinsRegular',
                fontSize: 10,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAmountField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: (value) => setState(() {}),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixText: 'Rp ',
        labelStyle: const TextStyle(
          color: Color(0xFF68736D),
          fontFamily: 'PoppinsRegular',
          fontSize: 10,
        ),
        hintStyle: const TextStyle(
          color: Color(0xFFADB4B0),
          fontFamily: 'PoppinsRegular',
          fontSize: 10,
        ),
        prefixStyle: const TextStyle(
          color: Color(0xFF68736D),
          fontFamily: 'PoppinsRegular',
          fontSize: 12,
        ),
        filled: true,
        fillColor: const Color(0xFFF8F9F7),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDecimalField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool allowDecimal = true,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: allowDecimal),
      inputFormatters: allowDecimal
          ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))]
          : [FilteringTextInputFormatter.digitsOnly],
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(
          color: Color(0xFF68736D),
          fontFamily: 'PoppinsRegular',
          fontSize: 10,
        ),
        hintStyle: const TextStyle(
          color: Color(0xFFADB4B0),
          fontFamily: 'PoppinsRegular',
          fontSize: 10,
        ),
        filled: true,
        fillColor: const Color(0xFFF8F9F7),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  InputDecoration _dropdownDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Color(0xFF68736D),
        fontFamily: 'PoppinsRegular',
        fontSize: 10,
      ),
      filled: true,
      fillColor: const Color(0xFFF8F9F7),
      contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 4),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: BorderSide.none,
      ),
    );
  }

  _LivestockDue? _livestockDue(int count, _LivestockType type) {
    if (type == _LivestockType.goatSheep) {
      final due = switch (count) {
        < 40 => 0,
        <= 120 => 1,
        <= 200 => 2,
        <= 300 => 3,
        _ => (count + 99) ~/ 100,
      };
      return _LivestockDue(
        label: '$due ekor kambing/domba',
        description: 'Hitungan mengikuti nisab ternak kambing/domba.',
      );
    }

    var bestTabi = 0;
    var bestMusinnah = 0;
    var bestCovered = 0;
    for (var musinnah = 0; musinnah <= count ~/ 40; musinnah++) {
      for (var tabi = 0; tabi <= count ~/ 30; tabi++) {
        final covered = musinnah * 40 + tabi * 30;
        if (covered <= count && count - covered < 30 && covered > bestCovered) {
          bestCovered = covered;
          bestTabi = tabi;
          bestMusinnah = musinnah;
        }
      }
    }

    final parts = <String>[
      if (bestTabi > 0) '$bestTabi ekor tabi (umur 1 tahun)',
      if (bestMusinnah > 0) '$bestMusinnah ekor musinnah (umur 2 tahun)',
    ];
    return _LivestockDue(
      label: parts.join(' + '),
      description: 'Hitungan mengikuti kombinasi kelipatan 30 dan 40 ekor.',
    );
  }

  Widget _buildDisclaimer() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5D9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: Color(0xFF946B18),
            size: 18,
          ),
          SizedBox(width: 9),
          Expanded(
            child: Text(
              'Hasil ini adalah perkiraan. Patokan nisab uang Rp85.000.000 setara nilai 85 gram emas dan perlu disesuaikan dengan harga emas terkini. Nisab panen bergantung pada konversi hasil dan ketentuan setempat. Syarat haul serta perhitungan jenis harta dapat berbeda menurut panduan fikih atau otoritas zakat. Untuk kepastian, konsultasikan dengan amil atau lembaga zakat tepercaya.',
              style: TextStyle(
                color: Color(0xFF705A2D),
                fontFamily: 'PoppinsRegular',
                fontSize: 10,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _parseAmount(String value) => double.tryParse(value) ?? 0;

  String _formatDecimal(num amount) {
    final rounded = amount.toStringAsFixed(2);
    return rounded.replaceAll(RegExp(r'\.?0+$'), '');
  }

  String _formatInteger(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );
  }

  String _formatPercent(double rate) => '${(rate * 100).toStringAsFixed(1)}%';

  String _formatRupiah(num amount) {
    final rounded = amount.round().toString();
    final formatted = rounded.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );
    return 'Rp $formatted';
  }
}

enum _ZakatCategory {
  money('Uang'),
  gold('Emas'),
  silver('Perak'),
  livestock('Ternak'),
  crops('Panen');

  const _ZakatCategory(this.label);

  final String label;
}

enum _LivestockType {
  goatSheep('Kambing/domba'),
  cattle('Sapi/kerbau');

  const _LivestockType(this.label);

  final String label;
}

enum _CropType {
  rice('Beras'),
  paddy('Gabah kering giling');

  const _CropType(this.label);

  final String label;
}

enum _IrrigationType {
  rainFed('Air hujan/alami'),
  irrigated('Irigasi berbiaya'),
  mixed('Campuran');

  const _IrrigationType(this.label);

  final String label;
}

class _LivestockDue {
  const _LivestockDue({required this.label, required this.description});

  final String label;
  final String description;
}

class _ZakatType {
  const _ZakatType({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color color;
}
