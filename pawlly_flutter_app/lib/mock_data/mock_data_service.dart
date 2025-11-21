// Mock Data Service - Provides local data instead of backend API calls
import 'dart:convert';
import '../models/base_response_model.dart';

class MockDataService {
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal();

  // Mock user data
  static const String mockUserToken = 'mock_token_12345';
  static const String mockUserId = '1';
  
  // Mock responses for various endpoints
  static Map<String, dynamic> getMockResponse(String endpoint, {Map? requestData}) {
    // Return mock success responses for different endpoints
    switch (endpoint) {
      case 'login':
        return {
          'status': true,
          'message': 'Login successful (Mock Data)',
          'data': {
            'user_data': {
              'id': mockUserId,
              'email': requestData?['email'] ?? 'demo@pawlly.com',
              'first_name': 'Demo',
              'last_name': 'User',
              'api_token': mockUserToken,
              'profile_image': '',
              'user_type': 'user',
              'is_social_login': false,
              'login_type': 'email',
            }
          }
        };
      
      case 'register':
        return {
          'status': true,
          'message': 'Registration successful (Mock Data)',
          'data': {
            'user_data': {
              'id': mockUserId,
              'email': requestData?['email'] ?? 'new@pawlly.com',
              'first_name': requestData?['first_name'] ?? 'New',
              'last_name': requestData?['last_name'] ?? 'User',
              'api_token': mockUserToken,
              'profile_image': '',
              'user_type': 'user',
              'is_social_login': false,
              'login_type': 'email',
            }
          }
        };
      
      case 'dashboard-detail':
        return {
          'status': true,
          'message': 'Success',
          'data': {
            'slider': [],
            'category': [],
            'service': [],
            'featured_product': [],
            'blog': [],
            'notification_unread_count': 0,
          }
        };
      
      case 'pet-list':
        return {
          'status': true,
          'message': 'Success',
          'data': {
            'pet_list': []
          }
        };
      
      case 'booking-list':
        return {
          'status': true,
          'message': 'Success',
          'data': {
            'booking_list': []
          }
        };
      
      case 'notification-list':
        return {
          'status': true,
          'message': 'Success',
          'data': {
            'notification': []
          }
        };

      case 'app-configuration':
        return {
          'status': true,
          'message': 'Success',
          'data': {
            'configurations': {
              'APP_NAME': 'Pawlly',
              'CURRENCY_COUNTRY_CODE': 'US',
              'CURRENCY_CODE': 'USD',
              'CURRENCY_SYMBOL': '\$',
            }
          }
        };
      
      default:
        return {
          'status': true,
          'message': 'Success (Mock Data)',
          'data': {}
        };
    }
  }

  // Simulate network delay
  static Future<Map<String, dynamic>> getMockResponseAsync(
    String endpoint, {
    Map? requestData,
    int delayMs = 500,
  }) async {
    await Future.delayed(Duration(milliseconds: delayMs));
    return getMockResponse(endpoint, requestData: requestData);
  }
}
