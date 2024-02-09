import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  String username;
  String profileImageUrl;
  String imagesPost;
  String description;
  int numPosts;
  int numFollowers;
  int numFollowing;

  UserProfile({
    this.username = '',
    this.profileImageUrl = '',
    this.imagesPost = '',
    this.description = '',
    this.numPosts = 0,
    this.numFollowers = 0,
    this.numFollowing = 0,
  });

  // Convert UserProfile to Map
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'profileImageUrl': profileImageUrl,
      'imagesPost': imagesPost,
      'description': description,
      'numPosts': numPosts,
      'numFollowers': numFollowers,
      'numFollowing': numFollowing,
    };
  }

  String getRandomUserProfileImage() {
    var random = Random();
    return 'https://picsum.photos/200?random=${random.nextInt(1000)}';
  }

  String getRandomUsername() {
    var random = Random();
    return 'user${random.nextInt(1000)}';
  }

  String getRandomDescription() {
    var random = Random();
    return 'Description ${random.nextInt(1000)}';
  }

List<String> getRandomImagesPost() {
  var random = Random();
  return List<String>.generate(random.nextInt(100) + 1,
      (index) => 'https://picsum.photos/200?random=${random.nextInt(100) + 1}');
}

  int getRandomNumPosts() {
    var random = Random();
    return random.nextInt(1000);
  }

  int getRandomNumFollowers() {
    var random = Random();
    return random.nextInt(1000);
  }

  int getRandomNumFollowing() {
    var random = Random();
    return random.nextInt(1000);
  }

  static Future<void> createAndAddUserProfile() async {
    print("createAndAddUserProfile called");
    UserProfile userProfile = UserProfile();
    userProfile.username = userProfile.getRandomUsername();
    userProfile.profileImageUrl = userProfile.getRandomUserProfileImage();
    userProfile.imagesPost = userProfile.getRandomImagesPost().join(',');
    userProfile.description = userProfile.getRandomDescription();
    userProfile.numPosts = userProfile.getRandomNumPosts();
    userProfile.numFollowers = userProfile.getRandomNumFollowers();
    userProfile.numFollowing = userProfile.getRandomNumFollowing();

    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return users
        .doc(userProfile.username)
        .set(userProfile.toMap())
        .then((value) {
      print("User Added");
      return Future.value();
    }).catchError((error) {
      print("Failed to add user: $error");
      return Future.error(error);
    });
  }
}