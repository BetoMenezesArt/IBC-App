import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'bible/bible_page.dart';
import 'profile_page.dart';
import 'dart:async';

class BottomBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // Clipper for the bottom bar
    Path path = Path();
    path.lineTo(0, 0);
    path.lineTo((size.width / 2) - 40, 0);
    path.quadraticBezierTo((size.width / 2) - 25, -20, size.width / 2, -30);
    path.quadraticBezierTo(
      (size.width / 2) + 25,
      -20,
      (size.width / 2) + 40,
      0,
    );
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.profileImageProvider});

  final ImageProvider<Object>? profileImageProvider;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _pageTimer;

  @override
  void initState() {
    super.initState();
    // Inicia o timer para alterar as páginas automaticamente
    _startPageTimer();
  }

  @override
  void dispose() {
    _pageTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startPageTimer() {
    _pageTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients) {
        if (_currentPage < 2) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            _buildLastServicesSection(context),
            _buildNewsSlider(context),
            _buildAgendaSection(context),
            const SizedBox(height: 100), // Extra space for bottom navigation
          ],
        ),
      ),
      bottomNavigationBar: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 70.0,
            decoration: BoxDecoration(
            color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.18),
                  spreadRadius: 1,
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.home_outlined,
                    color: Color(0xFF616161),
                    size: 28,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(
                    Icons.people_outline,
                    color: Colors.grey,
                    size: 28,
                  ),
                  onPressed: () {
                    // Ação para a página de rede social
                  },
                ),
                const SizedBox(width: 60),
                IconButton(
                  icon: const Icon(
                    Icons.church_outlined,
                    color: Colors.grey,
                    size: 28,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(
                    Icons.person_outline,
                    color: Colors.grey,
                    size: 28,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: -30,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 90,
                height: 90,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.18),
                      spreadRadius: 1,
                      blurRadius: 8,
                  ),
                ],
              ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/bible');
                    },
                    customBorder: const CircleBorder(),
                    child: const Icon(Icons.menu_book, size: 40, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/images/worship_background.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.6),
            BlendMode.darken,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Logo at the top center
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 25),
              child: SvgPicture.asset(
                'assets/images/logo.svg',
                width: 120,
                height: 120,
              ),
            ),

            // Profile section - horizontal layout
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start, // Left-aligned
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile photo
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 42, // Larger profile picture
                          backgroundImage:
                              widget.profileImageProvider ??
                              const AssetImage('assets/images/profile.png'),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            size: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 20),

                  // Welcome text
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Olá, Beto',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28, // Larger font
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Desejamos graça e paz para seu dia.',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Stats cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatsCard(
                      icon: Icons.flash_on,
                      value: '71',
                      label: 'dias',
                      subtitle: 'de check-ins no app',
                      iconSize: 60,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatsCard(
                      icon: Icons.menu_book,
                      value: '682',
                      label: 'horas',
                      subtitle: 'de leitura bíblica',
                      iconSize: 60
                    ,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard({
    required IconData icon,
    required String value,
    required String label,
    required String subtitle,
    double iconSize = 24,
  }) {
    return Container(
      width: 170, // Proporção semelhante à imagem
      height: 80, // Altura semelhante à imagem
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.black87, size: 32),
          const SizedBox(width: 12),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                  Text(
                    value,
                        style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 32,
                          fontWeight: FontWeight.bold,
                      height: 1,
                        ),
                      ),
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      label,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.5,
                        height: 1,
                      ),
                        ),
                      ),
                    ],
                  ),
              const SizedBox(height: 2),
                Text(
                  subtitle,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  height: 1.1,
                ),
                maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
          ),
        ],
      ),
    );
  }

  Widget _buildLastServicesSection(BuildContext context) {
    return _buildSection(
      title: 'Últimos cultos',
      actionText: 'Ver todos',
      sectionIcon: Icons.mic,
      items: [
        ServiceItem(
          thumbnail: 'assets/worship1.jpg',
          title: 'Discipulado',
          date: 'OUTUBRO 24, 2025',
        ),
        ServiceItem(
          thumbnail: 'assets/worship2.jpg',
          title: 'Vida em Cristo',
          date: 'OUTUBRO 17, 2025',
        ),
        ServiceItem(
          thumbnail: 'assets/worship3.jpg',
          title: 'Fé e Obras',
          date: 'OUTUBRO 10, 2025',
        ),
        ServiceItem(
          thumbnail: 'assets/worship4.jpg',
          title: 'Evangelismo',
          date: 'OUTUBRO 3, 2025',
        ),
      ],
      builder:
          (item) => _buildServiceCard(
            context,
            title: item.title,
            date: item.date,
            thumbnailUrl: item.thumbnail,
          ),
      cardHeight: 160, // Taller cards
    );
  }

  Widget _buildNewsSlider(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 12),
          child: Row(
            children: [
              const Icon(Icons.newspaper, size: 18, color: Colors.grey),
              const SizedBox(width: 8),
              const Text(
                'Notícias',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                'Ver todas',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 280,
          width: MediaQuery.of(context).size.width,
          child: PageView.builder(
            controller: _pageController,
            itemCount: 3,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return _buildNewsCard(
                context,
                title: index == 0
                    ? 'Campanha de Arrecadação'
                    : index == 1
                        ? 'Retiro de Jovens'
                        : 'Nova Série de Estudos',
                subtitle: index == 0
                    ? 'Ajude-nos a arrecadar alimentos para famílias necessitadas'
                    : index == 1
                        ? 'Inscrições abertas para o retiro que acontecerá em dezembro'
                        : 'Participe dos novos estudos bíblicos sobre o livro de Romanos',
                imagePath: 'assets/news${index + 1}.jpg',
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) => _buildIndicator(index == _currentPage)),
          ),
        ),
      ],
    );
  }

  Widget _buildNewsCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String imagePath,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Imagem de fundo
          SizedBox(
            height: 280,
            width: double.infinity,
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Fallback para quando a imagem não puder ser carregada
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: imagePath.contains('news1')
                          ? [Colors.blue.shade400, Colors.blue.shade700]
                          : imagePath.contains('news2')
                              ? [Colors.orange.shade300, Colors.deepOrange.shade600]
                              : [Colors.green.shade400, Colors.green.shade700],
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                );
              },
            ),
          ),
          // Desenho de onda na parte inferior
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: const Size(double.infinity, 60),
              painter: WavePainter(
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          // Gradiente escuro na parte inferior para melhorar legibilidade do texto
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 160,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ),
          // Conteúdo de texto
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildAgendaSection(BuildContext context) {
    return _buildSection(
      title: 'Agenda',
      actionText: 'Ver todos',
      sectionIcon: Icons.calendar_today,
      items: [
        EventItem(
          day: '19',
          title: 'Culto de Domingo',
          time: 'OUT 19 - 2025 - 9:15AM',
          thumbnailUrl: 'assets/event1.jpg',
        ),
        EventItem(
          day: '12',
          title: 'Grupo de Mulheres',
          time: 'OUT 12 - 2025 - 3:00PM',
          thumbnailUrl: 'assets/event2.jpg',
        ),
        EventItem(
          day: '18',
          title: 'Jovens em Ação',
          time: 'OUT 18 - 2025 - 7:00PM',
          thumbnailUrl: 'assets/event3.jpg',
        ),
        EventItem(
          day: '22',
          title: 'Estudo Bíblico',
          time: 'OUT 22 - 2025 - 7:30PM',
          thumbnailUrl: 'assets/event4.jpg',
        ),
      ],
      builder:
          (item) => _buildEventCard(
            context,
            day: item.day,
            title: item.title,
            time: item.time,
            thumbnailUrl: item.thumbnailUrl,
          ),
      cardHeight: 160, // Taller cards
    );
  }

  Widget _buildSection<T>({
    required String title,
    required String actionText,
    required List<T> items,
    required Widget Function(T) builder,
    IconData? sectionIcon,
    double cardHeight = 140,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                if (sectionIcon != null)
                  Icon(sectionIcon, size: 18, color: Colors.grey),
                if (sectionIcon != null) const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  actionText,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: cardHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, index) => builder(items[index]),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const ClampingScrollPhysics(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context, {
    required String title,
    required String date,
    required String thumbnailUrl,
  }) {
    return Container(
      width: 160, // Wider cards
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12), // Rounder corners
            child: Stack(
              children: [
                Image.asset(
                  thumbnailUrl,
                  width: double.infinity,
                  height: 100, // Taller images
                  fit: BoxFit.cover,
                ),
                Positioned.fill(
                  child: Container(color: Colors.black.withOpacity(0.3)),
                ),
                Positioned.fill(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 24, // Larger icon
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 3),
          Text(
            date,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(
    BuildContext context, {
    required String day,
    required String title,
    required String time,
    required String thumbnailUrl,
  }) {
    return Container(
      width: 160, // Wider cards
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12), // Rounder corners
            child: Stack(
              children: [
                Image.asset(
                  thumbnailUrl,
                  width: double.infinity,
                  height: 100, // Taller images
                  fit: BoxFit.cover,
                ),
                Positioned(
                  left: 10,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      day,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18, // Larger font
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 3),
          Text(
            time,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class ServiceItem {
  final String thumbnail;
  final String title;
  final String date;

  ServiceItem({
    required this.thumbnail,
    required this.title,
    required this.date,
  });
}

class EventItem {
  final String day;
  final String title;
  final String time;
  final String thumbnailUrl;

  EventItem({
    required this.day,
    required this.title,
    required this.time,
    required this.thumbnailUrl,
  });
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1;
    
    final spacingX = size.width / 10;
    final spacingY = size.height / 10;
    
    // Linhas horizontais
    for (var i = 0; i < 10; i++) {
      canvas.drawLine(
        Offset(0, i * spacingY),
        Offset(size.width, i * spacingY),
        paint,
      );
    }
    
    // Linhas verticais
    for (var i = 0; i < 10; i++) {
      canvas.drawLine(
        Offset(i * spacingX, 0),
        Offset(i * spacingX, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class WavePainter extends CustomPainter {
  final Color color;
  
  WavePainter({required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
      
    final path = Path();
    
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.25, size.height * 0.5,
      size.width * 0.5, size.height * 0.7
    );
    path.quadraticBezierTo(
      size.width * 0.75, size.height * 0.9,
      size.width, size.height * 0.7
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
