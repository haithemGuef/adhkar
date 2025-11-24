import 'package:flutter/material.dart';
import 'package:adhkar/adhkar_viewer.dart';
import 'package:get/get.dart';

class AdhkarHomePage extends StatefulWidget {
  const AdhkarHomePage({super.key});

  @override
  State<AdhkarHomePage> createState() => _AdhkarHomePageState();
}

class _AdhkarHomePageState extends State<AdhkarHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final Color morningColor = const Color(0xff01443D);
  final Color eveningColor = const Color(0xff928952);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void goToNextTab() {
    if (_tabController.index < _tabController.length - 1) {
      _tabController.animateTo(_tabController.index + 1);
    }
  }

  void goToPreviousTab() {
    if (_tabController.index > 0) {
      _tabController.animateTo(_tabController.index - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmall = screenWidth < 360;

    Color indicatorColor =
        _tabController.index == 0 ? morningColor : eveningColor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: morningColor,
        title: Text(
          "أذكار الصباح والمساء",
          style: TextStyle(
            color: Colors.white,
            fontSize: isSmall ? 18 : 24,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: Colors.grey[200],
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              labelStyle: TextStyle(fontSize: isSmall ? 14 : 18),
              indicator: BoxDecoration(
                color: indicatorColor,
                borderRadius: BorderRadius.circular(10),
              ),
              indicatorPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              tabs: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isSmall ? 4 : 12),
                  child: const Tab(text: "      الصباح      "),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isSmall ? 4 : 12),
                  child: const Tab(text: "      المساء      "),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                AdhkarViewer(
                  type: AdhkarType.morning,
                  backgroundColor: morningColor,
                ),
                AdhkarViewer(
                  type: AdhkarType.evening,
                  backgroundColor: eveningColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}