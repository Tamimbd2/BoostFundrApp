import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../api_constants.dart';

class DealsProvider extends GetConnect {
  final storage = GetStorage();

  @override
  void onInit() {
    httpClient.baseUrl = ApiConstants.baseUrl;
    httpClient.timeout = const Duration(seconds: 60);
  }

  Future<Response> getAllDeals() async {
    final token = storage.read('token');
    return get(
      ApiConstants.dealsAll,
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
        'content-type': 'application/json',
      },
    );
  }

  Future<Response> getDealsFeed() async {
    final token = storage.read('token');
    return get(
      ApiConstants.dealsFeedList,
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
        'content-type': 'application/json',
      },
    );
  }

  Future<Response> getDealById(String id) async {
    final token = storage.read('token');
    return get(
      '${ApiConstants.dealFeed}/$id',
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
        'content-type': 'application/json',
      },
    );
  }

  Future<Response> createDeal(FormData data) async {
    final token = storage.read('token');
    return post(
      '/deals',
      data,
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
  }

  Future<Response> updateDeal(String id, dynamic data) async {
    final token = storage.read('token');
    return patch(
      '/deals/$id',
      data,
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
  }

  Future<Response> getMyDeals() async {
    final token = storage.read('token');
    return get(
      ApiConstants.myDeals,
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
        'content-type': 'application/json',
      },
    );
  }

  Future<Response> toggleBookmark(String id) async {
    final token = storage.read('token');
    return post(
      '/bookmarks/$id',
      {},
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
        'content-type': 'application/json',
      },
    );
  }

  Future<Response> getBookmarks() async {
    final token = storage.read('token');
    return get(
      '/bookmarks',
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
        'content-type': 'application/json',
      },
    );
  }
}
