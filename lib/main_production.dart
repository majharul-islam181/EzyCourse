import 'app/bootstrap.dart';
import 'flavors/production.dart';

Future<void> main() async {
  await bootstrap(configureProduction);
}
