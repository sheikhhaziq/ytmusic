import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:http_cache_drift_store/http_cache_drift_store.dart';
import 'package:ytmusic/ytmusic.dart';

class YTClient {
  YTConfig config;
  late CookieJar _cookieJar;
  late Dio _dio;
  String? cacheDatabasePath;
  final void Function(YTConfig)? onConfigUpdate;
  YTClient(
    this.config,
    cookies, {
    this.onConfigUpdate,
    this.cacheDatabasePath,
  }) {
    _setupDio();
    _addCacheInterceptor();
    _setupCookies(cookies);
  }

  _setupCookies(String? cookies) {
    _cookieJar = CookieJar();
    if (cookies != null) {
      for (final cookieString in cookies.split("; ")) {
        final cookie = Cookie.fromSetCookieValue(cookieString);
        _cookieJar.saveFromResponse(Uri.parse(_dio.options.baseUrl), [cookie]);
      }
    }
  }

  _setupDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: "https://music.youtube.com/",
        headers: {
          "User-Agent":
              "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:88.0) Gecko/20100101 Firefox/88.0",
          "Accept-Language": "en-US,en;q=0.5",
          "Accept-Enconding": "gzip",
          "Accept": "application/json, text/plain, */*",
          "Content-Type": 'application/json',
        },
        // extra: {'withCredentials': true},
      ),
    );
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final cookies = await _cookieJar.loadForRequest(
            Uri.parse(options.baseUrl),
          );
          final cookieString = cookies
              .map((cookie) => '${cookie.name}=${cookie.value}')
              .join('; ');
          if (cookieString.isNotEmpty) {
            options.headers['cookie'] = cookieString;
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          final cookieStrings = response.headers['set-cookie'] ?? [];
          for (final cookieString in cookieStrings) {
            final cookie = Cookie.fromSetCookieValue(cookieString);
            _cookieJar.saveFromResponse(
              Uri.parse(response.requestOptions.baseUrl),
              [cookie],
            );
          }
          return handler.next(response);
        },
      ),
    );
  }

  _addCacheInterceptor() {
    if (cacheDatabasePath != null) {
      print('cache path: $cacheDatabasePath');
      _dio.interceptors.add(
        DioCacheInterceptor(
          options: CacheOptions(
            store: DriftCacheStore(
              databasePath: cacheDatabasePath!,
              logStatements: true,
            ),
            // hitCacheOnErrorCodes: [500, 502, 503],
            hitCacheOnNetworkFailure: true,
            maxStale: Duration(days: 7),
            allowPostMethod: true,
            policy: CachePolicy.request,
            priority: CachePriority.high,
          ),
        ),
      );
    }
  }

  static Future<YTConfig?> fetchConfig() async {
    try {
      final response = await Dio(
        BaseOptions(
          baseUrl: "https://music.youtube.com/",
          headers: {
            "User-Agent":
                "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:88.0) Gecko/20100101 Firefox/88.0",
            "Accept-Language": "en-US,en;q=0.5",
            "Accept-Enconding": "gzip",
            "Accept": "application/json, text/plain, */*",
            "Content-Type": 'application/json',
          },
        ),
      ).get('/');
      final html = response.data;
      return YTConfig(
        visitorData: _extractValue(html, r'"VISITOR_DATA":"(.*?)"'),
        location: _extractValue(html, r'"GL":"(.*?)"'),
        language: _extractValue(html, r'"HL":"(.*?)"'),
      );
    } catch (e) {
      print('Error fetching data: ${e.toString()}');
      return null;
    }
  }

  static String _extractValue(String html, String regex) {
    final match = RegExp(regex).firstMatch(html);
    return match != null ? match.group(1)! : '';
  }

  Future<dynamic> constructRequest(
    String endpoint, {
    Map<String, dynamic> body = const {},
    Map<String, String> query = const {},
  }) async {
    final headers = <String, String>{
      "User-Agent":
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 Safari/537.36 Edg/105.0.1343.42",
      "accept": "*/*",
      "accept-encoding": "gzip, deflate",
      "content-type": "application/json",
      "content-encoding": "gzip",
      "Origin": "https://music.youtube.com",
      "cookie": "CONSENT=YES+1",
      "Accept-Language": "en",
      "X-Goog-Visitor-Id": config.visitorData,
    };
    if (config.visitorData.trim().isEmpty) {
      final c = await fetchConfig();
      if (c != null) {
        config = c;
        if (onConfigUpdate != null) {
          onConfigUpdate!(c);
        }
      }
    }

    final searchParams = Uri.parse("?").replace(
      queryParameters: {
        ...query,
        "alt": "json",
        "key": "AIzaSyC9XL3ZjWddXya6X74dJoCTL-WEYFDNX30",
      },
    );
    final DateTime now = DateTime.now();
    final String year = now.year.toString();
    final String month = now.month.toString().padLeft(2, '0');
    final String day = now.day.toString().padLeft(2, '0');
    final String date = year + month + day;
    final context = {
      "context": {
        "client": {
          "clientName": "WEB_REMIX",
          "clientVersion": '1.$date.01.00',
          "gl": config.location,
          "hl": config.language,
          "visitorData": config.visitorData,
        },

        "user": {},
      },
      ...body,
    };
    try {
      final response = await _dio.post(
        "youtubei/v1/$endpoint${searchParams.toString()}",
        data: context,
        options: Options(headers: headers),
      );
      final jsonData = response.data;

      if (jsonData.containsKey("responseContext")) {
        return jsonData;
      } else {
        return jsonData;
      }
    } on DioException catch (e) {
      throw "Error${e.message}";
    }
  }
}
