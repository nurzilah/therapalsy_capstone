import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:therapalsy_capstone/app/modules/home/controllers/home_controller.dart';
import 'package:therapalsy_capstone/app/modules/models/article_model.dart';
import 'package:therapalsy_capstone/app/widgets/pie_chart_widget.dart';
import 'package:therapalsy_capstone/app/widgets/bar_chart_widget.dart';
import 'package:therapalsy_capstone/app/modules/streamlit/views/streamlit_view.dart';
import '../../deteksi/views/deteksi_view.dart';
import '../../profile/views/profile_view.dart';
import '../../progress/views/progress_view.dart';
import '../../terapi/views/terapi_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController controller = Get.put(HomeController());
  final Color mainGreen = const Color(0xFF316B5C);
  final double cardHeight = 290;
  final double cardRadius = 22;
  final PageController _pageController = PageController(viewportFraction: 0.95);
  int _currentPage = 0;

  final List<_HomeCardData> cards = [
    _HomeCardData(
      bgColor: const Color(0xFFF7C6C6),
      image: 'assets/images/dashboard.png',
      title: "Lets Try\nFace exercise\nfor Bell’s Palsy\nnow!",
      subtitle: "10 minutes",
      buttonText: "LETS TRY !",
      onPressed: () => Get.to(() => TerapiView()),
    ),
    _HomeCardData(
      bgColor: const Color(0xFFF7C6C6),
      image: 'assets/images/face1.png',
      title: "Detect your face\nand start your\nrecovery journey\nnow!",
      subtitle: "Fast Scan",
      buttonText: "DETECT MY FACE",
      onPressed: () => Get.offAll(() => const DeteksiView()),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 25),
          children: [
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Text(
                'Welcome to Therapalsy !',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: mainGreen,
                ),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: cardHeight + 16,
              child: PageView.builder(
                controller: _pageController,
                itemCount: cards.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 22 : 12,
                    right: index == cards.length - 1 ? 22 : 12,
                  ),
                  child: _HomePinkCard(
                    data: cards[index],
                    height: cardHeight,
                    borderRadius: cardRadius,
                    mainGreen: mainGreen,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(child: _PageIndicator(count: cards.length, currentIndex: _currentPage)),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Text(
                "About Bell’s Palsy",
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: mainGreen,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Obx(() => controller.articles.isEmpty
              ? const Center(child: Text("No articles found."))
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    children: controller.articles.map((article) {
                      final preview = article.definisi.length > 80
                          ? '${article.definisi.substring(0, 80)}...\nbaca selengkapnya?'
                          : article.definisi;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: InkWell(
                          onTap: () {
                            // Sesuaikan kalau mau detail page
                            Get.toNamed('/article', arguments: article);
                          },
                          child: _FaqCard(
                            title: article.title,
                            content: preview,
                            mainGreen: mainGreen,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )),

            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Text(
                "Top 5 Most Viewed Videos",
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: mainGreen,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 22),
              child: PieChartWidget(),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Text(
                "Top 10 Bell’s Palsy Channels",
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: mainGreen,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 22),
              child: BarChartWidget(),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.web),
                label: const Text('Buka Analisis Streamlit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                onPressed: () => Get.to(() => const StreamlitView()),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: _HomeBottomNav(mainGreen: mainGreen),
    );
  }
}

class _HomeCardData {
  final Color bgColor;
  final String image;
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onPressed;

  _HomeCardData({
    required this.bgColor,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onPressed,
  });
}

class _HomePinkCard extends StatelessWidget {
  final _HomeCardData data;
  final double height;
  final double borderRadius;
  final Color mainGreen;

  const _HomePinkCard({
    required this.data,
    required this.height,
    required this.borderRadius,
    required this.mainGreen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: data.bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            left: 115,
            top: 20,
            bottom: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(borderRadius),
                bottomRight: Radius.circular(borderRadius),
              ),
              child: Image.asset(
                data.image,
                width: 300,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (data.subtitle == "10 minutes")
                      const Icon(Icons.access_time, color: Colors.white, size: 18),
                    if (data.subtitle == "10 minutes") const SizedBox(width: 6),
                    Text(
                      data.subtitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: data.onPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      elevation: 0,
                    ),
                    child: Text(
                      data.buttonText,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const _PageIndicator({required this.count, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: index == currentIndex ? const Color(0xFF316B5C) : Colors.grey[300],
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}

class _FaqCard extends StatelessWidget {
  final String title;
  final String content;
  final Color mainGreen;

  const _FaqCard({required this.title, required this.content, required this.mainGreen});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: mainGreen.withOpacity(0.22), width: 1.5),
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: mainGreen,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            content,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 13,
              fontWeight: FontWeight.w400,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeBottomNav extends StatelessWidget {
  final Color mainGreen;
  const _HomeBottomNav({required this.mainGreen});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: mainGreen,
      unselectedItemColor: Colors.black54,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.crop_free), label: 'Detection'),
        BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Progress'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
      currentIndex: 0,
      onTap: (index) {
        switch (index) {
          case 0:
            Get.to(() => const HomeView());
            break;
          case 1:
            Get.to(() => const DeteksiView());
            break;
          case 2:
            Get.to(() => const ProgressView());
            break;
          case 3:
            Get.to(() => ProfileView());
            break;
        }
      },
    );
  }
}
