import 'package:flutter/material.dart';

// Définition de la classe ProfilePage qui hérite de StatefulWidget
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

// Définition de la classe _ProfilePageState qui hérite de State<ProfilePage>
class _ProfilePageState extends State<ProfilePage> {
  // Déclaration de la variable isDiscoverPeopleVisible
  bool isDiscoverPeopleVisible = false;

  // Méthode pour construire l'interface utilisateur
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(), // Appel de la méthode _buildAppBar
      body: _buildBody(), // Appel de la méthode _buildBody
      bottomNavigationBar: _buildBottomNavigationBar(), // Appel de la méthode _buildBottomNavigationBar
    );
  }

  // Méthode pour construire la AppBar
  AppBar _buildAppBar() {
    return AppBar(
      title: DropdownButton<String>(
        value: 'hovsep404',
        items: ['hovsep404', 'OtherUsername'].map((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        onChanged: (_) {},
      ),
      actions: [
        IconButton(icon: const Icon(Icons.menu,color: Colors.black), onPressed: () {}),
        IconButton(icon: const Icon(Icons.add_box,color: Colors.black), onPressed: () {}),
      ],
    );
  }

// Méthode pour construire le corps de la page
Widget _buildBody() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          _buildProfileSection(),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Hello world :3',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          _buildButtonSection(),
          Visibility(visible: isDiscoverPeopleVisible, child: _buildDiscoverPeople()),
          _buildTabBar(),
          _buildTabBarView(),
        ],
      ),
    );
  }

  // Méthode pour construire la section du profil
  Widget _buildProfileSection() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const CircleAvatar(radius: 45, backgroundImage: NetworkImage('https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcRUIIySyAaGSzpAyuQdq6IjdVV5w0jKdpToY01jaH-OXFYadDWg')),
          _buildProfileInfo('Posts', '24'),
          _buildProfileInfo('Followers', '404'),
          _buildProfileInfo('Following', '505'),
        ],
      ),
    );
  }

  // Méthode pour construire la section des boutons
  Widget _buildButtonSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildButton('Edit Profile'),
        _buildButton('Share Profile'),
        IconButton(
          icon: const Icon(Icons.person_add,color: Colors.black),
          onPressed: () => setState(() => isDiscoverPeopleVisible = !isDiscoverPeopleVisible),
        ),
      ],
    );
  }

  // Méthode pour construire le style d'un bouton
  TextButton _buildButton(String text) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.grey.shade300,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      child: Text(text, style: const TextStyle(color: Colors.black)),
    );
  }

  // Méthode pour construire les informations du profil
  Widget _buildProfileInfo(String title, String value) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  // Méthode pour construire la section "Découvrir des personnes"
  Widget _buildDiscoverPeople() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 24,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                CircleAvatar(radius: 45, backgroundImage: NetworkImage('https://picsum.photos/200?random=${index + 1}')),
                Text('@example${index + 1}'),
                TextButton(onPressed: () {}, child: const Text('Follow')),
              ],
            ),
          );
        },
      ),
    );
  }

  // Méthode pour construire la TabBar
  TabBar _buildTabBar() {
    return const TabBar(
      indicatorSize: TabBarIndicatorSize.tab,
      tabs: [
        Tab(icon: Icon(Icons.photo_library_outlined,color: Colors.black)),
        Tab(icon: Icon(Icons.person_outline,color: Colors.black)),
      ],
    );
  }

  // Méthode pour construire la vue de la TabBar
  Widget _buildTabBarView() {
    return Expanded(
      child: TabBarView(
        children: [
          _buildImageGrid(),
          const Icon(Icons.sentiment_satisfied_alt,color: Colors.black),
        ],
      ),
    );
  }

  // Méthode pour construire la grille d'images
  GridView _buildImageGrid() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(48, (index) {
        return Padding(
          padding: const EdgeInsets.all(1.0),
          child: Image.network('https://picsum.photos/200?random=$index'),
        );
      }),
    );
  }

  // Méthode pour construire la BottomNavigationBar
  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.black,), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search,color: Colors.black), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.add_box,color: Colors.black), label: 'Upload'),
        BottomNavigationBarItem(icon: Icon(Icons.smart_display_outlined,color: Colors.black), label: 'Likes'),
        BottomNavigationBarItem(
          label: "",
          icon: CircleAvatar(
            backgroundColor: Colors.black,
            radius: 13,
            child: CircleAvatar(
              backgroundImage: NetworkImage('https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcRUIIySyAaGSzpAyuQdq6IjdVV5w0jKdpToY01jaH-OXFYadDWg'),
              radius: 11,
            ),
          ),
        ),
      ],
    );
  }
}