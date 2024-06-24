import 'package:chickychickyplanner/Provider/chat_provider.dart';
import 'package:chickychickyplanner/Provider/collections_provider.dart';
import 'package:chickychickyplanner/Provider/task_provider.dart';
import 'package:chickychickyplanner/Provider/overview_provider.dart';
import 'package:chickychickyplanner/Provider/timer_provider.dart';
import 'package:chickychickyplanner/animation_page.dart';
import 'package:chickychickyplanner/home.dart';
import 'package:chickychickyplanner/provider/prompt_text_provider.dart';
import 'package:chickychickyplanner/start_page/options.dart';
import 'package:chickychickyplanner/start_page/start_page.dart';
import 'package:chickychickyplanner/start_page/tutorial_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:chickychickyplanner/service/navigation.dart';
import 'Provider/course_provider.dart';
import 'Theme/theme.dart';
import 'Theme/util.dart';

Future main() async {
  await dotenv.load(fileName: "lib/env/.env");
  runApp(
    MultiProvider(
      providers: [
        Provider<NavigationService>(create: (_) => NavigationService()),
        ChangeNotifierProvider(create: (_) => CourseProvider()),
        ChangeNotifierProvider(create: (_) => TableProvider()),
        ChangeNotifierProvider(create: (_) => TimerProvider()),
        ChangeNotifierProvider(create: (_) => ItemCollectionProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => PromptTextProvider()),
        ChangeNotifierProvider(create: (_) => ChatService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });
  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final brightness = MediaQuery.of(context).platformBrightness;
        TextTheme textTheme = createTextTheme(context, "Mali", "Mali");
        MaterialTheme theme = MaterialTheme(textTheme);

        return MaterialApp(
          theme: brightness == Brightness.light ? theme.light() : theme.dark(),
          navigatorKey: navigatorKey,
          initialRoute: '/',
          onGenerateRoute: (settings) {
            WidgetBuilder builder;
            RouteTransitionsBuilder transitionBuilder = fadeTransition;
            switch (settings.name) {
              case '/':
                builder = (BuildContext context) => const StartPage();
                break;
              case '/options':
                builder = (BuildContext context) => const OptionsPage();
                break;
              case '/tutorial':
                builder = (BuildContext context) => const TutorialPage();
                break;
              case '/table':
                builder = (BuildContext context) => const HomePage(
                      selectedTab: HomeTab.table,
                    );
                transitionBuilder = fadeTransition;
                break;
              case '/checklist':
                builder = (BuildContext context) => const HomePage(
                      selectedTab: HomeTab.checklist,
                    );
                transitionBuilder = fadeTransition;
                break;
              case '/timer':
                builder = (BuildContext context) => const HomePage(
                      selectedTab: HomeTab.timer,
                    );
                transitionBuilder = fadeTransition;
                break;
              case '/chart':
                builder = (BuildContext context) => const HomePage(
                      selectedTab: HomeTab.chart,
                    );
                transitionBuilder = fadeTransition;
                break;
              case '/ai':
                builder = (BuildContext context) => const HomePage(
                      selectedTab: HomeTab.ai,
                    );
                transitionBuilder = fadeTransition;
                break;
              default:
                builder = (BuildContext context) => const HomePage(
                      selectedTab: HomeTab.table,
                    );
                break;
            }
            return CustomTransitionPage<void>(
              child: builder(context),
              transitionsBuilder: transitionBuilder,
            ).createRoute(context);
          },
        );
      },
    );
  }
}
