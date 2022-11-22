import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

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

  List<Map<String, int>> getCountEmoWeek() {
    return countEmoWeek;
  }

  // DB접근 -> 감정 리스트 반환
  Future getEmotions() async {
    // read all documents from collection
    final db = FirebaseFirestore.instance;

    QuerySnapshot querySnapshot = await db.collection("diarys").orderBy("day").get();
    List<Map<String, dynamic>> allData = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    if(allData.isNotEmpty) {
      for(int i = 0; i < allData.length; i++) {
        emotions.add(allData[i]["emotion"]);
      }
    }

    countEmoMonth = counterEmo(emotions, 0, emotions.length);
    countEmoWeek[0] = counterEmo(emotions, 0, 7);
    countEmoWeek[1] = counterEmo(emotions, 7, 14);
    countEmoWeek[2] = counterEmo(emotions, 14, 21);
    countEmoWeek[3] = counterEmo(emotions, 21, 28);

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




  @override
  Widget build(BuildContext context) {
    // 감정 정보 세팅
    getEmotions();

    return Scaffold(
      appBar: AppBar(
        title: Text("Statistics"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1.0,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(18)),

                ),
                child: Stack(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const SizedBox(
                          height: 37,
                        ),
                        const Text(
                          'November',
                          style: TextStyle(
                            color: Color(0xff827daa),
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        const Text(
                          'Monthly Emotion',
                          style: TextStyle(
                            color: Colors.black,
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
                            child: _LineChart(countEmoWeek: countEmoWeek),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40,),

          ],
        ),
      ),
    );
  }
}


class _LineChart extends StatelessWidget {
  const _LineChart({required this.countEmoWeek});

  final List<Map<String, int>> countEmoWeek;

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
    handleBuiltInTouches: false,
    touchTooltipData: LineTouchTooltipData(
      tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
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
      color: Color(0xff75729e),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
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
      color: Color(0xff72719b),
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
    color: const Color(0xff4af699),
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
    color: const Color(0xffaa4cfc),
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
    color: const Color(0xff27b6fc),
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
    color: Colors.red,
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
    color: Colors.yellow,
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




















