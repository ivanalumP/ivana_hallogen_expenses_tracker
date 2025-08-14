import 'package:dio/dio.dart';
import '../models/expense_category.dart';
import '../models/expense_categories_response.dart';
import '../models/api_response.dart';
import '../models/paginated_response.dart';
import '../../domain/repositories/expense_category_repository.dart';

class ExpenseCategoryRepositoryImpl implements ExpenseCategoryRepository {
  final Dio _dio;

  ExpenseCategoryRepositoryImpl(this._dio);

  @override
  Future<List<ExpenseCategory>> getExpenseCategories() async {
    try {
      final response = await _dio.get(
        'https://media.halogen.my/experiment/mobile/expenseCategories.json',
      );

      if (response.statusCode == 200) {
        // Parse the response with the new structure
        final responseData = ExpenseCategoriesResponse.fromJson(response.data);

        // Validate that we have categories
        if (responseData.expenseCategories.isEmpty) {
          throw Exception('No expense categories found in the response');
        }

        return responseData.expenseCategories;
      } else {
        throw Exception(
            'Failed to load expense categories: HTTP ${response.statusCode}');
      }
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
          throw Exception(
              'Request timeout. Please check your internet connection.');
        case DioExceptionType.connectionError:
          throw Exception('No internet connection. Please check your network.');
        case DioExceptionType.badResponse:
          throw Exception('Server error: ${e.response?.statusCode}');
        default:
          throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      if (e.toString().contains('null is not a subtype of num')) {
        throw Exception(
            'Invalid data format: Some categories have missing or invalid percentage values');
      }
      throw Exception('Unexpected error: $e');
    }
  }

  /// Enhanced method that returns a paginated response
  @override
  Future<PaginatedResponse<ExpenseCategory>> getExpenseCategoriesPaginated({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        'https://media.halogen.my/experiment/mobile/expenseCategories.json',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        // Parse the response with the new structure
        final responseData = ExpenseCategoriesResponse.fromJson(response.data);
        final categories = responseData.expenseCategories;

        // Validate that we have categories
        if (categories.isEmpty) {
          throw Exception('No expense categories found in the response');
        }

        // Create a paginated response with calculated pagination
        return PaginatedResponse.withCalculatedPagination(
          data: categories,
          page: page,
          limit: limit,
          total: categories
              .length, // In a real API, this would come from the response
          success: true,
          message: 'Categories loaded successfully',
        );
      } else {
        throw Exception(
            'Failed to load expense categories: HTTP ${response.statusCode}');
      }
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
          throw Exception(
              'Request timeout. Please check your internet connection.');
        case DioExceptionType.connectionError:
          throw Exception('No internet connection. Please check your network.');
        case DioExceptionType.badResponse:
          throw Exception('Server error: ${e.response?.statusCode}');
        default:
          throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      if (e.toString().contains('null is not a subtype of num')) {
        throw Exception(
            'Invalid data format: Some categories have missing or invalid percentage values');
      }
      throw Exception('Unexpected error: $e');
    }
  }

  /// Method that returns an API response wrapper
  @override
  Future<ApiResponse<List<ExpenseCategory>>>
      getExpenseCategoriesWithResponse() async {
    try {
      final response = await _dio.get(
        'https://media.halogen.my/experiment/mobile/expenseCategories.json',
      );

      if (response.statusCode == 200) {
        // Parse the response with the new structure
        final responseData = ExpenseCategoriesResponse.fromJson(response.data);
        final categories = responseData.expenseCategories;

        // Validate that we have categories
        if (categories.isEmpty) {
          return ApiResponse.error(
            error: 'No expense categories found in the response',
            message: 'The response contains no categories',
            statusCode: response.statusCode!,
          );
        }

        return ApiResponse.success(
          data: categories,
          message: 'Categories loaded successfully',
          statusCode: response.statusCode!,
        );
      } else {
        return ApiResponse.error(
          error: 'Failed to load expense categories',
          message: 'HTTP ${response.statusCode}',
          statusCode: response.statusCode!,
        );
      }
    } on DioException catch (e) {
      String errorMessage;
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
          errorMessage =
              'Request timeout. Please check your internet connection.';
          break;
        case DioExceptionType.connectionError:
          errorMessage = 'No internet connection. Please check your network.';
          break;
        case DioExceptionType.badResponse:
          errorMessage = 'Server error: ${e.response?.statusCode}';
          break;
        default:
          errorMessage = 'Network error: ${e.message}';
      }

      return ApiResponse.error(
        error: errorMessage,
        message: 'Network request failed',
        statusCode: e.response?.statusCode ?? 0,
      );
    } catch (e) {
      if (e.toString().contains('null is not a subtype of num')) {
        return ApiResponse.error(
          error:
              'Invalid data format: Some categories have missing or invalid percentage values',
          message: 'Data parsing failed',
          statusCode: 500,
        );
      }
      return ApiResponse.error(
        error: 'Unexpected error: $e',
        message: 'An unexpected error occurred',
        statusCode: 500,
      );
    }
  }
}
