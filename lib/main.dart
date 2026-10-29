import 'package:avatar_glow/avatar_glow.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

const List<String> kategoriList = ['Keluarga', 'Teman', 'Kerja', 'Sekolah', 'Lainnya'];

class Kontak {
  final String nama, telepon, email, kategori;
  final DateTime ditambahkan;
  Kontak(this.nama, this.telepon, this.email, this.kategori, this.ditambahkan);
}

final Faker _faker = Faker();
final List<Kontak> semuaKontak = List.generate(
  20,
      (i) => Kontak(
    _faker.person.name(),
    '08${_faker.randomGenerator.integer(999999999, min: 100000000)}',
    _faker.internet.email(),
    kategoriList[i % kategoriList.length],
    _faker.date.dateTime(minYear: 2025, maxYear: 2026),
  ),
);

final DateFormat _fmt = DateFormat('dd MMMM yyyy', 'id_ID');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Kontak App',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
    locale: const Locale('id', 'ID'),
    supportedLocales: const [Locale('id', 'ID')],
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: const HomeShell(),
  );
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;
  static const _judul = ['Kontak', 'Cari', 'Profil'];

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(_judul[_index])),
    body: IndexedStack(
      index: _index,
      children: const [KontakPage(), CariPage(), ProfilPage()],
    ),
    bottomNavigationBar: ConvexAppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      initialActiveIndex: _index,
      items: const [
        TabItem(icon: Icons.contacts, title: 'Kontak'),
        TabItem(icon: Icons.search, title: 'Cari'),
        TabItem(icon: Icons.person, title: 'Profil'),
      ],
      onTap: (i) => setState(() => _index = i),
    ),
  );
}


class KontakTile extends StatelessWidget {
  final Kontak k;
  const KontakTile(this.k, {super.key});
  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    child: ListTile(
      leading: CircleAvatar(child: Text(k.nama[0])),
      title: Text(k.nama, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('${k.telepon}\n${k.email}\n'
          'Ditambahkan pada ${_fmt.format(k.ditambahkan)}'),
      isThreeLine: true,
      trailing: Chip(label: Text(k.kategori), visualDensity: VisualDensity.compact),
    ),
  );
}


class KontakPage extends StatelessWidget {
  const KontakPage({super.key});
  @override
  Widget build(BuildContext context) => ListView.builder(
    itemCount: semuaKontak.length,
    itemBuilder: (_, i) => KontakTile(semuaKontak[i]),
  );
}

class CariPage extends StatefulWidget {
  const CariPage({super.key});
  @override
  State<CariPage> createState() => _CariPageState();
}

class _CariPageState extends State<CariPage> {
  String? _kategori;

  @override
  Widget build(BuildContext context) {
    final hasil = _kategori == null
        ? <Kontak>[]
        : semuaKontak.where((k) => k.kategori == _kategori).toList();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: DropdownSearch<String>(
            items: kategoriList,
            selectedItem: _kategori,
            popupProps: const PopupProps.menu(
              showSearchBox: true,
              searchFieldProps: TextFieldProps(
                decoration: InputDecoration(hintText: 'Cari kategori...'),
              ),
            ),
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: 'Kategori kontak',
                border: OutlineInputBorder(),
              ),
            ),
            onChanged: (v) => setState(() => _kategori = v),
          ),
        ),
        Expanded(
          child: _kategori == null
              ? const Center(child: Text('Pilih kategori untuk menampilkan kontak'))
              : ListView.builder(
            itemCount: hasil.length,
            itemBuilder: (_, i) => KontakTile(hasil[i]),
          ),
        ),
      ],
    );
  }
}

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AvatarGlow(
          glowColor: Theme.of(context).colorScheme.primary,
          duration: const Duration(seconds: 2),
          repeat: true,
          child: const CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
          ),
        ),
        const SizedBox(height: 24),
        const Text('Zulki Mujitahid',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text('NIM 4124043'),
        const Text('zulkitahit@gmail.com'),
      ],
    ),
  );
}