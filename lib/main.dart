import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const CardActionApp());

class CardActionApp extends StatelessWidget {
  const CardActionApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Card Action Alpha',
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff24507a)), useMaterial3: true),
    home: const GameScreen(),
  );
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final random = Random();
  late List<List<int>> hands;
  late List<List<bool>> visible;
  int turn = 0;
  int discard = 0;
  int? drawn;
  String notice = 'نسخة تجريبية محلية على جهاز واحد. الأكشن واللعب الشبكي غير مكتملين.';

  @override
  void initState() {
    super.initState();
    reset();
  }

  int nextCard() => random.nextInt(15) - 2;

  void reset() {
    hands = List.generate(2, (_) => List.generate(12, (_) => nextCard()));
    visible = List.generate(2, (_) {
      final cards = List.filled(12, false);
      final a = random.nextInt(12);
      var b = random.nextInt(11);
      if (b >= a) b++;
      cards[a] = true;
      cards[b] = true;
      return cards;
    });
    discard = nextCard();
    turn = 0;
    drawn = null;
  }

  void exchange(int index) {
    setState(() {
      final replacement = drawn ?? discard;
      final old = hands[turn][index];
      hands[turn][index] = replacement;
      visible[turn][index] = true;
      discard = old;
      drawn = null;
      turn = (turn + 1) % hands.length;
    });
  }

  void revealInstead(int index) {
    if (drawn == null || visible[turn][index]) return;
    setState(() {
      discard = drawn!;
      drawn = null;
      visible[turn][index] = true;
      turn = (turn + 1) % hands.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final score = List.generate(2, (p) {
      var total = 0;
      for (var i = 0; i < 12; i++) {
        if (visible[p][i]) total += hands[p][i];
      }
      return total;
    });
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('Card Action • Alpha'), actions: [
          IconButton(onPressed: () => setState(reset), icon: const Icon(Icons.refresh), tooltip: 'لعبة جديدة'),
        ]),
        backgroundColor: const Color(0xfff3eddd),
        body: SafeArea(child: ListView(padding: const EdgeInsets.all(16), children: [
          Text(notice, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Text('الدور: لاعب ${turn + 1}', style: Theme.of(context).textTheme.headlineSmall),
          Text('النقاط المكشوفة: لاعب 1 = ${score[0]} | لاعب 2 = ${score[1]}'),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 12,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: .77),
            itemBuilder: (context, i) => InkWell(
              onTap: () => exchange(i),
              onLongPress: () => revealInstead(i),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: visible[turn][i] ? const Color(0xfff8fbff) : const Color(0xff28568c),
                  border: Border.all(color: const Color(0xffc29b5e), width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(visible[turn][i] ? '${hands[turn][i]}' : '✦',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold,
                    color: visible[turn][i] ? const Color(0xff213047) : Colors.white)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('ورقة المهملات: $discard', style: const TextStyle(fontSize: 18)),
          if (drawn != null) Text('الورقة المسحوبة: $drawn', style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: drawn == null ? () => setState(() => drawn = nextCard()) : null,
            child: const Text('اسحب ورقة'),
          ),
          const Text('اضغط على ورقة لتبديلها بورقة المهملات أو المسحوبة. بعد السحب، اضغط مطولًا على ورقة مغلقة لرمي المسحوبة وكشف الورقة.'),
          const SizedBox(height: 16),
          const Text('هذه تجربة واجهة وليست تطبيق SKYJO Action الكامل. لا تتضمن النجوم أو بطاقات الأكشن أو الاتصال بين الأجهزة.'),
        ])),
      ),
    );
  }
}
