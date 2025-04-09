import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:list_crud/src/model/inser_user/insert_user_request.dart';
import 'package:list_crud/src/model/update_user/update_user_request.dart';
import '../urls/urls.dart';

class ApiClient {
  ApiClient() {
    initClientListCrudDev();
  }

  Dio dioListCrud = Dio();

  BaseOptions _baseOptionsListCrud = BaseOptions();

   ///client dev
  initClientListCrudDev() async {

    _baseOptionsListCrud = BaseOptions(
      baseUrl: UrlsListCrud.baseUrlDev,
      connectTimeout: const Duration(seconds: 5000),
      receiveTimeout: const Duration(seconds: 3000),
      followRedirects: true,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',

      },
      responseType: ResponseType.json,
      receiveDataWhenStatusError: true,
    );

    dioListCrud = Dio(_baseOptionsListCrud);
    dioListCrud.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final HttpClient client =
            HttpClient(context: SecurityContext(withTrustedRoots: false));
        client.badCertificateCallback =
            ((X509Certificate cert, String host, int port) => true);
        return client;
      },
    );


    dioListCrud.interceptors.add(InterceptorsWrapper(
      onRequest: (reqOptions, handler) {
        return handler.next(reqOptions);
      },
      onError: (DioException dioError, handler) {
        return handler.next(dioError);
      },
    ));
  }



  /// USER LIST CLIENT
  Future<Response> listUser(int page, int perPage) {
    return dioListCrud.get(
        '${UrlsListCrud.USER}?page=$page&per_page=$perPage',
    );
  }

  /// INSERT USER CLIENT
  Future<Response> insertUserClient(InsertUserRequest insertUserRequest) {
    return dioListCrud.post(
      UrlsListCrud.USER,
      data: insertUserRequest,
      options: Options(
          headers: {
        "Authorization": "Bearer 090a4d13b368ea5cbc5c1f05cd08a2b0cb5cd4234b51f1b2aa2a8e6a4edaf183",
      }),
    );
  }


  /// UPDATE USER CLIENT
  Future<Response> updateUserClient(int id, UpdateUserRequest updateUserRequest) {
    return dioListCrud.put(
      '${UrlsListCrud.USER}/$id',
      data: updateUserRequest,
      options: Options(
        headers: {
          "Authorization": "Bearer 090a4d13b368ea5cbc5c1f05cd08a2b0cb5cd4234b51f1b2aa2a8e6a4edaf183",
        },
      ),
    );
  }


  /// DELETE USER CLIENT
  Future<Response> deleteUserClient(int id, ) {
    return dioListCrud.delete(
      '${UrlsListCrud.USER}/$id',
      options: Options(
        headers: {
          "Authorization": "Bearer 090a4d13b368ea5cbc5c1f05cd08a2b0cb5cd4234b51f1b2aa2a8e6a4edaf183",
        },
      ),
    );
  }

  /// User Details CLIENT
  Future<Response> userDetailsClient(int id, ) {
    return dioListCrud.get(
      '${UrlsListCrud.USER}/$id',
      options: Options(
        headers: {
          "Authorization": "Bearer 090a4d13b368ea5cbc5c1f05cd08a2b0cb5cd4234b51f1b2aa2a8e6a4edaf183",
        },
      ),
    );
  }



}
