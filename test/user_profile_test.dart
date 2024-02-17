import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clone_instagram/user_profile.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clone_instagram/screens/profil_page.dart';
import 'package:firebase_core/firebase_core.dart';
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
void main() {
  group('UserProfile', () {
    final userProfile = UserProfile();

    test('getRandomUsername returns a valid username', () {
      final username = userProfile.getRandomUsername();
      expect(username, isNotNull);
      expect(username, isNotEmpty);
      expect(username, startsWith('user'));
    });

    test('getRandomUserProfileImage returns a valid image URL', () {
      final imageUrl = userProfile.getRandomUserProfileImage();
      expect(imageUrl, isNotNull);
      expect(imageUrl, isNotEmpty);
      expect(imageUrl, startsWith('https://picsum.photos/200?random='));
    });

    test('getRandomDescription returns a valid description', () {
      final description = userProfile.getRandomDescription();
      expect(description, isNotNull);
      expect(description, isNotEmpty);
      expect(description, startsWith('Description '));
    });

    test('getRandomImagesPost returns a valid list of image URLs', () {
      final imagesPost = userProfile.getRandomImagesPost();
      expect(imagesPost, isNotNull);
      expect(imagesPost, isNotEmpty);
      for (var imageUrl in imagesPost) {
        expect(imageUrl, startsWith('https://picsum.photos/200?random='));
      }
    });

    test('getRandomNumPosts returns a valid number of posts', () {
      final numPosts = userProfile.getRandomNumPosts();
      expect(numPosts, isNotNull);
      expect(numPosts, greaterThanOrEqualTo(0));
      expect(numPosts, lessThanOrEqualTo(1000));
    });

    test('getRandomNumFollowers returns a valid number of followers', () {
      final numFollowers = userProfile.getRandomNumFollowers();
      expect(numFollowers, isNotNull);
      expect(numFollowers, greaterThanOrEqualTo(0));
      expect(numFollowers, lessThanOrEqualTo(1000));
    });

    test('getRandomNumFollowing returns a valid number of following', () {
      final numFollowing = userProfile.getRandomNumFollowing();
      expect(numFollowing, isNotNull);
      expect(numFollowing, greaterThanOrEqualTo(0));
      expect(numFollowing, lessThanOrEqualTo(1000));
    });
  });

}
