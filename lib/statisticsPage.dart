import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';
import 'dart:math';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  // 일별 감정 리스트
  List<String> emotions = [];
  // 월 감정별 개수
  Map<String, int> countEmoMonth = {"best": 0, "happy": 0, "sad": 0, "tired": 0, "annoying": 0};
  // 주 감정별 개수
  List<Map<String, int>> countEmoWeek = [
    {"best": 0, "happy": 0, "sad": 0, "tired": 0, "annoying": 0},
    {"best": 0, "happy": 0, "sad": 0, "tired": 0, "annoying": 0},
    {"best": 0, "happy": 0, "sad": 0, "tired": 0, "annoying": 0},
    {"best": 0, "happy": 0, "sad": 0, "tired": 0, "annoying": 0}
  ];
  // 요일 감정별 개수
  List<List<String>> countEmoDayWeekList = [];
  List<Map<String, int>> countEmoDayWeek = [
    {"best": 0, "happy": 0, "sad": 0, "tired": 0, "annoying": 0},
    {"best": 0, "happy": 0, "sad": 0, "tired": 0, "annoying": 0},
    {"best": 0, "happy": 0, "sad": 0, "tired": 0, "annoying": 0},
    {"best": 0, "happy": 0, "sad": 0, "tired": 0, "annoying": 0},
    {"best": 0, "happy": 0, "sad": 0, "tired": 0, "annoying": 0},
    {"best": 0, "happy": 0, "sad": 0, "tired": 0, "annoying": 0},
    {"best": 0, "happy": 0, "sad": 0, "tired": 0, "annoying": 0}
  ];

  // DB접근 -> 감정 리스트 반환
  Future<void> getEmotions() async {

    countEmoMonth = {"best": 0, "happy": 0, "sad": 0, "tired": 0, "annoying": 0};
    countEmoWeek = [
      {"best": 0, "happy": 0, "sad": 0, "tired": 0, "annoying": 0},
      {"best": 0, "happy": 0, "sad": 0, "tired": 0, "annoying": 0},
      {"best": 0, "happy": 0, "sad": 0, "tired": 0, "annoying": 0},
      {"best": 0, "happy": 0, "sad": 0, "tired": 0, "annoying": 0}
    ];
    countEmoDayWeekList = [];
    countEmoDayWeek = [
      {"best": 0, "happy": 0, "sad": 0, "tired": 0, "annoying": 0},
      {"best": 0, "happy": 0, "sad": 0, "tired": 0, "annoying": 0},
      {"best": 0, "happy": 0, "sad": 0, "tired": 0, "annoying": 0},
      {"best": 0, "happy": 0, "sad": 0, "tired": 0, "annoying": 0},
      {"best": 0, "happy": 0, "sad": 0, "tired": 0, "annoying": 0},
      {"best": 0, "happy": 0, "sad": 0, "tired": 0, "annoying": 0},
      {"best": 0, "happy": 0, "sad": 0, "tired": 0, "annoying": 0}
    ];

    countEmoMonth = counterEmo(emotions, 0, emotions.length);
    countEmoWeek[0] = counterEmo(emotions, 0, 7);
    countEmoWeek[1] = counterEmo(emotions, 7, 14);
    countEmoWeek[2] = counterEmo(emotions, 14, 21);
    countEmoWeek[3] = counterEmo(emotions, 21, 28);
    countEmoDayWeekList = counterEmoDayWeek(emotions, 1);
    countEmoDayWeek[0] = counterEmo(countEmoDayWeekList[0], 0, countEmoDayWeekList[0].length);
    countEmoDayWeek[1] = counterEmo(countEmoDayWeekList[1], 0, countEmoDayWeekList[1].length);
    countEmoDayWeek[2] = counterEmo(countEmoDayWeekList[2], 0, countEmoDayWeekList[2].length);
    countEmoDayWeek[3] = counterEmo(countEmoDayWeekList[3], 0, countEmoDayWeekList[3].length);
    countEmoDayWeek[4] = counterEmo(countEmoDayWeekList[4], 0, countEmoDayWeekList[4].length);
    countEmoDayWeek[5] = counterEmo(countEmoDayWeekList[5], 0, countEmoDayWeekList[5].length);
    countEmoDayWeek[6] = counterEmo(countEmoDayWeekList[6], 0, countEmoDayWeekList[6].length);

  }

  // 감정 리스트 -> 감정별 개수
  Map<String, int> counterEmo(emotions, start, end) {
    Map<String, int> countEmo = {"best": 0, "happy": 0, "sad": 0, "tired": 0, "annoying": 0};

    for(int i = start; i < end; i++) {
      switch (emotions[i]) {
        case "best":
          countEmo["best"] = countEmo["best"]! + 1;
          break;
        case "happy":
          countEmo["happy"] = countEmo["happy"]! + 1;
          break;
        case "sad":
          countEmo["sad"] = countEmo["sad"]! + 1;
          break;
        case "tired":
          countEmo["tired"] = countEmo["tired"]! + 1;
          break;
        case "annoying":
          countEmo["annoying"] = countEmo["annoying"]! + 1;
          break;
        default:
          break;
      }
    }
    return countEmo;
  }

  List<List<String>> counterEmoDayWeek(emotions, DOTW) {
    List<List<String>> countEmoDayWeek = [
      [],
      [],
      [],
      [],
      [],
      [],
      []
    ];
    Map<double, int> week = {0.0: 0, 1.0: 1, 2.0: 2, 3.0: 3, 4.0: 4, 5.0: 5, 6.0: 6};
    int dotw = week[DOTW]! ?? 0;

    for(int i = 0; i < 30; i++){
      if(emotions[i] != ""){
        countEmoDayWeek[dotw].add(emotions[i]);
      }

      dotw = dotw + 1;
      if (dotw > 6) {
        dotw = dotw - 7;
      }
    }
    return countEmoDayWeek;
  }

  String getKeyOfMaxValue(Map<String, int> map) {
    int value = 0;
    String key = "";

    map.forEach((k,v){
      if(v > value) {
        value = v;
        key = k;
      }
    });

    return key;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEmotions();
  }

  @override
  Widget build(BuildContext context) {
    emotions = ModalRoute.of(context)!.settings.arguments as List<String>;
    getEmotions();

    return Scaffold(
      appBar: AppBar(
        title: Text("Statistics"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            BarChartSample1(countEmoDayWeek: countEmoDayWeek),
            SizedBox(height: 40,),
            LineChartSample1(countEmoWeek: countEmoWeek),
            SizedBox(height: 40,),
            PieChartSample3(countEmoMonth: countEmoMonth),
            SizedBox(height: 40,),
            const Text(
              'Emotion of The Month',
              style: TextStyle(
                color: Color(0xff0f4a3c),
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            AvatarGlow(
              glowColor: Colors.blueGrey,
              endRadius: 150.0,
              duration: Duration(milliseconds: 2000),
              repeat: true,
              showTwoGlows: true,
              repeatPauseDuration: Duration(milliseconds: 100),
              child: Material(     // Replace this child with your own
                elevation: 8.0,
                shape: CircleBorder(),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  child: Image.asset(
                    'assets/images/dog_16.jpeg',
                    height: 50,
                  ),
                  radius: 50.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class BarChartSample1 extends StatefulWidget {
  BarChartSample1({super.key, required this.countEmoDayWeek});

  final List<Map<String, int>> countEmoDayWeek;

  List<Color> get availableColors => const <Color>[
    Colors.purpleAccent,
    Colors.yellow,
    Colors.lightBlue,
    Colors.orange,
    Colors.pink,
    Colors.redAccent,
  ];


  @override
  State<StatefulWidget> createState() => BarChartSample1State();
}

class BarChartSample1State extends State<BarChartSample1> {
  final Color barBackgroundColor = const Color(0xff72d8bf);
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;

  bool isPlaying = false;

  String getKeyOfMaxValue(Map<String, int> map) {
    int value = 0;
    String key = "";

    map.forEach((k,v){
      if(v > value) {
        value = v;
        key = k;
      }
    });

    return key;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          color: Colors.blueGrey,
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const Text(
                      'November',
                      style: TextStyle(
                        color: Color(0xff0f4a3c),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    const Text(
                      'Days of the Week',
                      style: TextStyle(
                        color: Color(0xff379982),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 38,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: BarChart(
                          mainBarData()
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: const Color(0xff0f4a3c),
                    ),
                    onPressed: () {
                      setState(() {
                        isPlaying = !isPlaying;
                        if (isPlaying) {
                          refreshState();
                        }
                      });
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
      int x,
      double y, {
        bool isTouched = false,
        Color barColor = Colors.white,
        double width = 22,
        List<int> showTooltips = const [],
      }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? Colors.yellow : barColor,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: Colors.yellow)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 5,
            color: barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
    switch (i) {
      case 0:
        return makeGroupData(0, widget.countEmoDayWeek[0]![getKeyOfMaxValue(widget.countEmoDayWeek[0]!)]!.toDouble(), isTouched: i == touchedIndex);
      case 1:
        return makeGroupData(1, widget.countEmoDayWeek[1]![getKeyOfMaxValue(widget.countEmoDayWeek[1]!)]!.toDouble(), isTouched: i == touchedIndex);
      case 2:
        return makeGroupData(2, widget.countEmoDayWeek[2]![getKeyOfMaxValue(widget.countEmoDayWeek[2]!)]!.toDouble(), isTouched: i == touchedIndex);
      case 3:
        return makeGroupData(3, widget.countEmoDayWeek[3]![getKeyOfMaxValue(widget.countEmoDayWeek[3]!)]!.toDouble(), isTouched: i == touchedIndex);
      case 4:
        return makeGroupData(4, widget.countEmoDayWeek[4]![getKeyOfMaxValue(widget.countEmoDayWeek[4]!)]!.toDouble(), isTouched: i == touchedIndex);
      case 5:
        return makeGroupData(5, widget.countEmoDayWeek[5]![getKeyOfMaxValue(widget.countEmoDayWeek[5]!)]!.toDouble(), isTouched: i == touchedIndex);
      case 6:
        return makeGroupData(6, widget.countEmoDayWeek[6]![getKeyOfMaxValue(widget.countEmoDayWeek[6]!)]!.toDouble(), isTouched: i == touchedIndex);
      default:
        return throw Error();
    }
  });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.blueGrey,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {

            String tex = getKeyOfMaxValue(widget.countEmoDayWeek[group.x]);
            return BarTooltipItem(
              '$tex\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: (rod.toY.toInt() - 1).toString(),
                  style: const TextStyle(
                    color: Colors.yellow,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      gridData: FlGridData(show: false),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('M', style: style);
        break;
      case 1:
        text = const Text('T', style: style);
        break;
      case 2:
        text = const Text('W', style: style);
        break;
      case 3:
        text = const Text('T', style: style);
        break;
      case 4:
        text = const Text('F', style: style);
        break;
      case 5:
        text = const Text('S', style: style);
        break;
      case 6:
        text = const Text('S', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

  BarChartData randomData() {
    return BarChartData(
      barTouchData: BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(
              0,
              Random().nextInt(15).toDouble() + 6,
              barColor: widget.availableColors[
              Random().nextInt(widget.availableColors.length)],
            );
          case 1:
            return makeGroupData(
              1,
              Random().nextInt(15).toDouble() + 6,
              barColor: widget.availableColors[
              Random().nextInt(widget.availableColors.length)],
            );
          case 2:
            return makeGroupData(
              2,
              Random().nextInt(15).toDouble() + 6,
              barColor: widget.availableColors[
              Random().nextInt(widget.availableColors.length)],
            );
          case 3:
            return makeGroupData(
              3,
              Random().nextInt(15).toDouble() + 6,
              barColor: widget.availableColors[
              Random().nextInt(widget.availableColors.length)],
            );
          case 4:
            return makeGroupData(
              4,
              Random().nextInt(15).toDouble() + 6,
              barColor: widget.availableColors[
              Random().nextInt(widget.availableColors.length)],
            );
          case 5:
            return makeGroupData(
              5,
              Random().nextInt(15).toDouble() + 6,
              barColor: widget.availableColors[
              Random().nextInt(widget.availableColors.length)],
            );
          case 6:
            return makeGroupData(
              6,
              Random().nextInt(15).toDouble() + 6,
              barColor: widget.availableColors[
              Random().nextInt(widget.availableColors.length)],
            );
          default:
            return throw Error();
        }
      }),
      gridData: FlGridData(show: false),
    );
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
      animDuration + const Duration(milliseconds: 50),
    );
    if (isPlaying) {
      await refreshState();
    }
  }
}


class _LineChart extends StatelessWidget {
  const _LineChart({required this.countEmoWeek});

  final List<Map<String, int>> countEmoWeek;

  String getKeyOfMaxValue(Map<String, int> map) {
    int value = 0;
    String key = "";

    map.forEach((k,v){
      if(v > value) {
        value = v;
        key = k;
      }
    });

    return key;
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      sampleData1,
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData1 => LineChartData(
    lineTouchData: lineTouchData1,
    gridData: gridData,
    titlesData: titlesData1,
    borderData: borderData,
    lineBarsData: lineBarsData1,
    minX: 0,
    maxX: 5,
    maxY: 7,
    minY: 0,
  );

  LineTouchData get lineTouchData1 => LineTouchData(
    handleBuiltInTouches: true,
    touchTooltipData: LineTouchTooltipData(
      tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
      getTooltipItems: (List<LineBarSpot> lineBarsSpot) {

        return lineBarsSpot.map((lineBarSpot) {
          print(lineBarSpot.x.toInt() - 1);
          String tex = getKeyOfMaxValue(countEmoWeek[lineBarSpot.x.toInt() - 1]);
          print(tex);
          return LineTooltipItem(
            '$tex',
            const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          );
        }).toList();
      },
    ),
  );

  FlTitlesData get titlesData1 => FlTitlesData(
    bottomTitles: AxisTitles(
      sideTitles: bottomTitles,
    ),
    rightTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    leftTitles: AxisTitles(
      sideTitles: leftTitles(),
    ),
  );

  List<LineChartBarData> get lineBarsData1 => [
    lineChartBarData1_1,
    lineChartBarData1_2,
    lineChartBarData1_3,
    lineChartBarData1_4,
    lineChartBarData1_5,
  ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0';
        break;
      case 1:
        text = '1';
        break;
      case 2:
        text = '2';
        break;
      case 3:
        text = '3';
        break;
      case 4:
        text = '4';
        break;
      case 5:
        text = '5';
        break;
      case 6:
        text = '6';
        break;
      case 7:
        text = '7';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
    getTitlesWidget: leftTitleWidgets,
    showTitles: true,
    interval: 1,
    reservedSize: 40,
  );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text('1w', style: style);
        break;
      case 2:
        text = const Text('2w', style: style);
        break;
      case 3:
        text = const Text('3w', style: style);
        break;
      case 4:
        text = const Text('4w', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
    showTitles: true,
    reservedSize: 32,
    interval: 1,
    getTitlesWidget: bottomTitleWidgets,
  );

  FlGridData get gridData => FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
    show: true,
    border: const Border(
      bottom: BorderSide(color: Color(0xff4e4965), width: 4),
      left: BorderSide(color: Colors.transparent),
      right: BorderSide(color: Colors.transparent),
      top: BorderSide(color: Colors.transparent),
    ),
  );

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
    isCurved: false,
    color: Color(0xff378982),
    barWidth: 4,
    isStrokeCapRound: true,
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
    spots: [
      FlSpot(1, countEmoWeek[0]["best"]!.toDouble()),
      FlSpot(2, countEmoWeek[1]["best"]!.toDouble()),
      FlSpot(3, countEmoWeek[2]["best"]!.toDouble()),
      FlSpot(4, countEmoWeek[3]["best"]!.toDouble()),
    ],
  );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
    isCurved: false,
    color: Color(0xff370982),
    barWidth: 4,
    isStrokeCapRound: true,
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(
      show: false,
      color: const Color(0x00aa4cfc),
    ),
    spots: [
      FlSpot(1, countEmoWeek[0]["sad"]!.toDouble()),
      FlSpot(2, countEmoWeek[1]["sad"]!.toDouble()),
      FlSpot(3, countEmoWeek[2]["sad"]!.toDouble()),
      FlSpot(4, countEmoWeek[3]["sad"]!.toDouble()),
    ],
  );
  LineChartBarData get lineChartBarData1_3 => LineChartBarData(
    isCurved: false,
    color: Color(0xff378272),
    barWidth: 4,
    isStrokeCapRound: true,
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
    spots: [
      FlSpot(1, countEmoWeek[0]["tired"]!.toDouble()),
      FlSpot(2, countEmoWeek[1]["tired"]!.toDouble()),
      FlSpot(3, countEmoWeek[2]["tired"]!.toDouble()),
      FlSpot(4, countEmoWeek[3]["tired"]!.toDouble()),
    ],
  );

  LineChartBarData get lineChartBarData1_4 => LineChartBarData(
    isCurved: false,
    color: Color(0xff379962),
    barWidth: 4,
    isStrokeCapRound: true,
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
    spots: [
      FlSpot(1, countEmoWeek[0]["annoying"]!.toDouble()),
      FlSpot(2, countEmoWeek[1]["annoying"]!.toDouble()),
      FlSpot(3, countEmoWeek[2]["annoying"]!.toDouble()),
      FlSpot(4, countEmoWeek[3]["annoying"]!.toDouble()),
    ],
  );

  LineChartBarData get lineChartBarData1_5 => LineChartBarData(
    isCurved: false,
    color: Color(0xff379982),
    barWidth: 4,
    isStrokeCapRound: true,
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
    spots: [
      FlSpot(1, countEmoWeek[0]["happy"]!.toDouble()),
      FlSpot(2, countEmoWeek[1]["happy"]!.toDouble()),
      FlSpot(3, countEmoWeek[2]["happy"]!.toDouble()),
      FlSpot(4, countEmoWeek[3]["happy"]!.toDouble()),
    ],
  );
}

class LineChartSample1 extends StatefulWidget {
  LineChartSample1({super.key, required this.countEmoWeek});
  List<Map<String, int>> countEmoWeek;

  @override
  State<StatefulWidget> createState() => LineChartSample1State();
}

class LineChartSample1State extends State<LineChartSample1> {
  late bool isShowingMainData;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AspectRatio(
        aspectRatio: 9 / 16,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(18)),
            color: Colors.blueGrey,
          ),
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(
                    height: 37,
                  ),const Text(
                    'November',
                    style: TextStyle(
                      color: Color(0xff379982),
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const Text(
                    'Weekly Emotion',
                    style: TextStyle(
                      color: Color(0xff0f4a3c),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 37,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16, left: 6),
                      child: _LineChart(countEmoWeek: widget.countEmoWeek),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Colors.white.withOpacity(isShowingMainData ? 1.0 : 0.5),
                ),
                onPressed: () {
                  setState(() {
                    isShowingMainData = !isShowingMainData;
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PieChartSample3 extends StatefulWidget {
  PieChartSample3({super.key, required this.countEmoMonth});

  final Map<String, int> countEmoMonth;

  @override
  State<StatefulWidget> createState() => PieChartSample3State();
}

class PieChartSample3State extends State<PieChartSample3> {
  int touchedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.9,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          color: Colors.blueGrey,
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 37,
                ),
                const Text(
                  'November',
                  style: TextStyle(
                    color: Color(0xff379982),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Monthly Emotion',
                  style: TextStyle(
                    color: Color(0xff0f4a3c),
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback: (FlTouchEvent event, pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                touchedIndex = -1;
                                return;
                              }
                              touchedIndex =
                                  pieTouchResponse.touchedSection!.touchedSectionIndex;
                            });
                          },
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        sectionsSpace: 0,
                        centerSpaceRadius: 0,
                        sections: showingSections(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(widget.countEmoMonth.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 110.0 : 100.0;
      final widgetSize = isTouched ? 55.0 : 40.0;

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: widget.countEmoMonth["best"]!.toDouble(),
            title: !isTouched ? '' : 'best',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
            badgeWidget: _Badge(
              'assets/ophthalmology-svgrepo-com.svg',
              size: widgetSize,
              borderColor: const Color(0xff0293ee),
            ),
            badgePositionPercentageOffset: .98,
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: widget.countEmoMonth["happy"]!.toDouble(),
            title: !isTouched ? '' : 'happy',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
            badgeWidget: _Badge(
              'assets/librarian-svgrepo-com.svg',
              size: widgetSize,
              borderColor: const Color(0xfff8b250),
            ),
            badgePositionPercentageOffset: .98,
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff845bef),
            value: widget.countEmoMonth["sad"]!.toDouble(),
            title: !isTouched ? '' : 'sad',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
            badgeWidget: _Badge(
              'assets/fitness-svgrepo-com.svg',
              size: widgetSize,
              borderColor: const Color(0xff845bef),
            ),
            badgePositionPercentageOffset: .98,
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xff13d38e),
            value: widget.countEmoMonth["tired"]!.toDouble(),
            title: !isTouched ? '' : 'tired',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
            badgeWidget: _Badge(
              'assets/worker-svgrepo-com.svg',
              size: widgetSize,
              borderColor: const Color(0xff13d38e),
            ),
            badgePositionPercentageOffset: .98,
          );
        case 4:
          return PieChartSectionData(
            color: const Color(0xff892312),
            value: widget.countEmoMonth["annoying"]!.toDouble(),
            title: !isTouched ? '' : 'annoying',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
            badgeWidget: _Badge(
              'assets/worker-svgrepo-com.svg',
              size: widgetSize,
              borderColor: const Color(0xff13d38e),
            ),
            badgePositionPercentageOffset: .98,
          );
        default:
          throw Exception('Oh no');
      }
    });
  }
}

class _Badge extends StatelessWidget {
  const _Badge(
      this.svgAsset, {
        required this.size,
        required this.borderColor,
      });
  final String svgAsset;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: Text("hi")
      ),
    );
  }
}