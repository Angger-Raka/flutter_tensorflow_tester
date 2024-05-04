import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import './screen/screen.dart';

final routes = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/camera-tester',
      builder: (context, state) {
        final cameras = state.extra as List<CameraDescription>;
        return CameraTesterPage(cameras: cameras);
      },
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: '/error',
      builder: (context, state) => const ErrorPage(),
    ),
  ],
);
