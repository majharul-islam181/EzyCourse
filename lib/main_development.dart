import 'app/bootstrap.dart';
import 'flavors/development.dart';

Future<void> main() async {
  await bootstrap(configureDevelopment);
}
