import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  return runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

final greetingProvider = Provider((ref) => 'Hello Riverpod!');

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
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riverpod example'),
      ),
      body: Center(
        // We wrap our text widget with a consumer
        // This way we only rebuild the Text widget when the provider
        // changes its value
        child: Consumer(
          builder: (context, watch, child) {
            final greeting = watch(greetingProvider);
            return Text(greeting);
          },
        ),
      ),
    );
  }
}
