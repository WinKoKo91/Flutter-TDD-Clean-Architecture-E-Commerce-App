import 'package:eshop/core/constant/string.dart';
import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../../models/category/category_model.dart';

abstract class CategoryRemoteDataSource {
  /// Calls the base-url/categories endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<CategoryModel>> getCategories();
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final http.Client client;
  CategoryRemoteDataSourceImpl({required this.client});

  @override
  Future<List<CategoryModel>> getCategories() =>
      _getCategoryFromUrl('$baseUrl/categories');

  Future<List<CategoryModel>> _getCategoryFromUrl(String url) async {
    final response = await client.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return categoryModelFromJson(response.body);
    } else {
      throw ServerException();
    }
  }
}
