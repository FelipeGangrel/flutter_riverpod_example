import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  return runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class FakeHttpClient {
  Future<String> get(String url) async {
    await Future.delayed(const Duration(seconds: 1));
    return 'Response from $url';
  }
}

final fakeHttpClientProvider = Provider((ref) => FakeHttpClient());

// We can pass whe url for the responseProvider by using the .family modifier

// If we pass the same url more than once, we are not going to see the progress
// bar, for the value is cached

// To override this behaviour, we can use the .autoDispose modifier
final responseProvider =
    FutureProvider.autoDispose.family<String, String>((ref, url) async {
  final httpClient = ref.read(fakeHttpClientProvider);
  return httpClient.get(url);
});

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyWidget(),
    );
  }
}

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riverpod example'),
      ),
      body: Container(
        child: Center(
          child: Consumer(
            builder: (context, watch, child) {
              final responseAsyncValue =
                  watch(responseProvider('https://testev2.com.br'));
              return responseAsyncValue.map(
                data: (data) => Text(data.value),
                loading: (loading) => CircularProgressIndicator(),
                error: (error) => Text(
                  error.toString(),
                  style: TextStyle(color: Colors.red),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
