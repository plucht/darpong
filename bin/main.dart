import 'package:start/start.dart';

main() {
  start(host: '0.0.0.0', port: 3001).then((Server app) {
    app.static('../build/web');
  });
}