import 'package:kanban/constants/app_theme.dart';
import 'package:kanban/constants/strings.dart';
import 'package:kanban/data/repository.dart';
import 'package:kanban/di/components/service_locator.dart';
import 'package:kanban/stores/board/board_list_store.dart';
import 'package:kanban/stores/organization/organization_list_store.dart';
import 'package:kanban/ui/organization/organization.dart';
import 'package:kanban/utils/routes/routes.dart';
import 'package:kanban/stores/language/language_store.dart';
import 'package:kanban/stores/post/post_store.dart';
import 'package:kanban/stores/theme/theme_store.dart';
import 'package:kanban/stores/user/user_store.dart';
import 'package:kanban/ui/login/login.dart';
import 'package:kanban/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  // Create your store as a final variable in a base Widget. This works better
  // with Hot Reload than creating it directly in the `build` function.
  final ThemeStore _themeStore = ThemeStore(getIt<Repository>());
  final PostStore _postStore = PostStore(getIt<Repository>());
  final OrganizationListStore _organizationListStore = OrganizationListStore(getIt<Repository>());
  final BoardListStore _boardListStore = BoardListStore(getIt<Repository>());
  final LanguageStore _languageStore = LanguageStore(getIt<Repository>());
  final UserStore _userStore = UserStore(getIt<Repository>());

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ThemeStore>(create: (_) => _themeStore),
        Provider<PostStore>(create: (_) => _postStore),
        Provider<OrganizationListStore>(create: (_) => _organizationListStore),
        Provider<BoardListStore>(create: (_) => _boardListStore),
        Provider<LanguageStore>(create: (_) => _languageStore),
      ],
      child: Observer(
        name: 'global-observer',
        builder: (context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: Strings.appName,
            theme: _themeStore.darkMode ? themeDataDark : themeData,
            routes: Routes.routes,
            locale: Locale(_languageStore.locale),
            supportedLocales: _languageStore.supportedLanguages
                .map((language) => Locale(language.locale!, language.code))
                .toList(),
            localizationsDelegates: [
              // A class which loads the translations from JSON files
              AppLocalizations.delegate,
              // Built-in localization of basic text for Material widgets
              GlobalMaterialLocalizations.delegate,
              // Built-in localization for text direction LTR/RTL
              GlobalWidgetsLocalizations.delegate,
              // Built-in localization of basic text for Cupertino widgets
              GlobalCupertinoLocalizations.delegate,
            ],
            home: _userStore.isLoggedIn ? OrganizationScreen() : LoginScreen(),
          );
        },
      ),
    );
  }
}
