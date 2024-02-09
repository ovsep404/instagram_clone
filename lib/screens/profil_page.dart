import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:clone_instagram/user_profile.dart';

// Définition de la classe ProfilePage qui est un StatefulWidget
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

// Définition de la classe _ProfilePageState qui est l'état de ProfilePage
class _ProfilePageState extends State<ProfilePage> {
  // Déclaration des variables
  bool isDiscoverPeopleVisible = false;
  String? currentUsername;
  UserProfile userProfile = UserProfile();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  // Méthode appelée lorsque l'objet est inséré dans l'arbre
  @override
  void initState() {
    super.initState();
    _selectRandomUser(); // Sélection d'un utilisateur aléatoire au démarrage
  }

  // Méthode pour sélectionner un utilisateur aléatoire
  Future<void> _selectRandomUser() async {
    // Récupération de tous les utilisateurs de la base de données
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    // Création d'une liste de noms d'utilisateurs à partir des données récupérées
    final usernames = snapshot.docs.map((doc) => doc['username']).toList();
    // Sélection d'un index aléatoire
    var random = Random();
    int randomIndex = random.nextInt(usernames.length);
    // Sélection du nom d'utilisateur correspondant à l'index aléatoire
    currentUsername = usernames[randomIndex];
    // Récupération des données de l'utilisateur sélectionné
    FirebaseFirestore.instance.collection('users').doc(currentUsername).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        // Si l'utilisateur existe, mise à jour de userProfile avec les données de l'utilisateur
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        userProfile = UserProfile(
          username: data['username'],
          profileImageUrl: data['profileImageUrl'],
          imagesPost: data['imagesPost'],
          description: data['description'],
          numPosts: data['numPosts'],
          numFollowers: data['numFollowers'],
          numFollowing: data['numFollowing'],
        );
        // Mise à jour de l'interface utilisateur
        setState(() {});
      } else {
        print('Document does not exist on the database');
      }
    });
  }
  // Méthode pour construire l'interface utilisateur
@override
Widget build(BuildContext context) {
  return RefreshIndicator(
    key: _refreshIndicatorKey,
    onRefresh: _refresh,
    child: Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    ),
  );
}


// Méthode pour construire la AppBar
AppBar _buildAppBar() {
  return AppBar(
    // Utilisation de StreamBuilder pour écouter les mises à jour de la collection 'users' dans Firestore
    title: StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // Si les données ne sont pas encore chargées, affichez 'Loading...'
        if (!snapshot.hasData) return const Text('Chargement...');
        // Création d'une liste de noms d'utilisateurs à partir des données récupérées
        final usernames = snapshot.data!.docs.map((doc) => doc['username']).toList();
        // Si currentUsername est null ou n'est pas dans la liste des noms d'utilisateurs, sélectionnez le premier nom d'utilisateur
        currentUsername = currentUsername == null || !usernames.contains(currentUsername) ? usernames.first : currentUsername;
        // Création d'un DropdownButton pour sélectionner un nom d'utilisateur
        return DropdownButton<String>(
          value: currentUsername,
          items: usernames.map((username) {
            return DropdownMenuItem<String>(
              value: username,
              child: Text(username),
            );
          }).toList(),
          // Lorsqu'un nouvel utilisateur est sélectionné, mettez à jour currentUsername et récupérez les données de l'utilisateur sélectionné
          onChanged: (String? newValue) {
            setState(() {
              currentUsername = newValue;
              // Récupération des données de l'utilisateur sélectionné à partir de Firebase
              FirebaseFirestore.instance.collection('users').doc(newValue).get().then((DocumentSnapshot documentSnapshot) {
                if (documentSnapshot.exists) {
                  // Si l'utilisateur existe, mettez à jour l'interface utilisateur avec les données de l'utilisateur sélectionné
                  Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
                  userProfile = UserProfile(
                    username: data['username'],
                    profileImageUrl: data['profileImageUrl'],
                    imagesPost: data['imagesPost'],
                    description: data['description'],
                    numPosts: data['numPosts'],
                    numFollowers: data['numFollowers'],
                    numFollowing: data['numFollowing'],
                  );
                  setState(() {});
                } else {
                  print('Le document n\'existe pas dans la base de données');
                }
              });
            });
          },
        );
      },
    ),
    // Ajout de boutons d'action à la AppBar
    actions: [
      IconButton(icon: const Icon(Icons.menu,color: Colors.black), onPressed: () {}),
      IconButton(icon: const Icon(Icons.add_box,color: Colors.black), onPressed: () {}),
      IconButton(
          icon: const Icon(Icons.refresh),
          tooltip: 'Rafraîchir',
          onPressed: () {
            _refreshIndicatorKey.currentState?.show();
          }),
    ],
  );
}

// Méthode pour rafraîchir les données de l'utilisateur
Future<Null> _refresh() {
  return UserProfile.createAndAddUserProfile().then((_) {
    setState(() {});
  });
}
// Méthode pour construire le corps de la page
Widget _buildBody() {
  return RefreshIndicator(
    onRefresh: UserProfile.createAndAddUserProfile,
    child: DefaultTabController(
      length: 2,
      child: Column(
        children: [
          _buildProfileSection(),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                userProfile.description,
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
          CircleAvatar(radius: 45, backgroundImage: NetworkImage(userProfile.profileImageUrl)),
          _buildProfileInfo('Posts', userProfile.numPosts.toString()),
          _buildProfileInfo('Followers', userProfile.numFollowers.toString()),
          _buildProfileInfo('Following', userProfile.numFollowing.toString()),
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
  List<String> images = userProfile.imagesPost.split(',');
  return GridView.count(
    crossAxisCount: 3,
    children: List.generate(images.length, (index) {
      return Padding(
        padding: const EdgeInsets.all(1.0),
        child: Image.network(images[index]),
      );
    }),
  );
}

  // Méthode pour construire la BottomNavigationBar
BottomNavigationBar _buildBottomNavigationBar() {
  return BottomNavigationBar(
    showSelectedLabels: false,
    showUnselectedLabels: false,
    items: [
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
            backgroundImage: NetworkImage(userProfile.profileImageUrl),
            radius: 11,
          ),
        ),
      ),
    ],
  );
}
}