import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'bible/bible_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            _buildStatsSection(context),
            _buildOptionsSection(context),
            _buildPrayerListSection(context),
            _buildHighlightsSection(context),
            const SizedBox(height: 100), // Espaço para o menu de navegação
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
                    color: Colors.grey,
                    size: 28,
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
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
                    color: Color(0xFF616161),
                    size: 28,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Positioned(
            top: -30,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  shape: const CircleBorder(),
                  elevation: 0,
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
            const SizedBox(height: 20),
            // Foto de perfil grande centralizada
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: const CircleAvatar(
                    radius: 60, // Foto de perfil maior
                    backgroundImage: AssetImage('assets/images/profile.png'),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 20,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            // Nome do usuário
            const Text(
              'Beto',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            // Estatísticas
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStat(context, '16', 'Sequência'),
                Container(
                  height: 40,
                  width: 1,
                  color: Colors.white.withOpacity(0.3),
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                ),
                _buildStat(context, '2', 'Semanas'),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(BuildContext context, String value, String label) {
    return Row(
      children: [
        Icon(
          label == 'Sequência' ? Icons.flash_on : Icons.calendar_today,
          color: Colors.white,
          size: 24,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return const SizedBox.shrink();
  }

  Widget _buildOptionsSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          // Primeira linha - Bookmarks e Highlights
          Row(
            children: [
              Expanded(
                child: _buildOptionBox(
                  context,
                  Icons.bookmark,
                  'Favoritos',
                  () {
                    // Ação para favoritos
                  },
                ),
              ),
              Expanded(
                child: _buildOptionBox(
                  context,
                  Icons.edit,
                  'Destaques',
                  () {
                    // Ação para destaques
                  },
                ),
              ),
            ],
          ),
          const Divider(height: 1),
          // Segunda linha - Notes e Friends
          Row(
            children: [
              Expanded(
                child: _buildOptionBox(
                  context,
                  Icons.note,
                  'Notas',
                  () {
                    // Ação para notas
                  },
                ),
              ),
              Expanded(
                child: _buildOptionBox(
                  context,
                  Icons.people,
                  'Amigos',
                  () {
                    // Ação para amigos
                  },
                ),
              ),
            ],
          ),
          const Divider(height: 1),
          // Terceira linha - Badges e um espaço em branco
          Row(
            children: [
              Expanded(
                child: _buildOptionBox(
                  context,
                  Icons.card_giftcard,
                  'Conquistas',
                  () {
                    // Ação para conquistas
                  },
                ),
              ),
              Expanded(
                child: _buildOptionBox(
                  context,
                  Icons.school,
                  'Estudos',
                  () {
                    // Ação para estudos
                  },
                ),
              ),
            ],
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }

  Widget _buildOptionBox(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Row(
          children: [
            Icon(icon, size: 26, color: Colors.black87),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerListSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lista de Oração',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[100],
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 30,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 15),
                const Expanded(
                  child: Text(
                    'Adicione uma oração. Mantenha privada ou compartilhe com amigos.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
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

  Widget _buildHighlightsSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.bookmark, size: 18, color: Colors.grey),
              SizedBox(width: 8),
              Text(
                'Você destacou',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Text(
                'Ver todos',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildHighlightCard(
            context,
            reference: 'Mateus 6:33',
            text: '33 Busque, pois, em primeiro lugar o Reino de Deus.',
            version: 'NVI',
            timeAgo: '9h',
          ),
          const SizedBox(height: 15),
          _buildHighlightCard(
            context,
            reference: 'Salmos 23:1',
            text: '1 O Senhor é o meu pastor, nada me faltará.',
            version: 'NVI',
            timeAgo: '1d',
          ),
          const SizedBox(height: 15),
          _buildHighlightCard(
            context,
            reference: 'João 3:16',
            text: '16 Porque Deus tanto amou o mundo que deu o seu Filho Unigênito, para que todo o que nele crer não pereça, mas tenha a vida eterna.',
            version: 'NVI',
            timeAgo: '2d',
          ),
          const SizedBox(height: 15),
          _buildHighlightCard(
            context,
            reference: 'Filipenses 4:13',
            text: '13 Tudo posso naquele que me fortalece.',
            version: 'NVI',
            timeAgo: '3d',
          ),
          const SizedBox(height: 15),
          _buildHighlightCard(
            context,
            reference: 'Jeremias 29:11',
            text: '11 Porque eu bem sei os planos que tenho a vosso respeito, diz o Senhor; planos de paz, e não de mal, para vos dar um futuro e uma esperança.',
            version: 'ACF',
            timeAgo: '5d',
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightCard(
    BuildContext context, {
    required String reference,
    required String text,
    required String version,
    required String timeAgo,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                reference,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  version,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                timeAgo,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              height: 1.4,
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.share, color: Colors.grey),
                onPressed: () {},
                iconSize: 20,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 20),
              IconButton(
                icon: const Icon(Icons.bookmark_border, color: Colors.grey),
                onPressed: () {},
                iconSize: 20,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 