import 'package:kanban/data/local/datasources/organization/organization_datasource.dart';
import 'package:kanban/data/local/datasources/post/post_datasource.dart';
import 'package:kanban/data/local/datasources/project/project_datasource.dart';
import 'package:kanban/data/network/apis/board/boardItem_api.dart';
import 'package:kanban/data/network/apis/board/board_api.dart';
import 'package:kanban/data/network/apis/organizations/organization_api.dart';
import 'package:kanban/data/network/apis/posts/post_api.dart';
import 'package:kanban/data/network/apis/projects/project_api.dart';
import 'package:kanban/data/network/dio_client.dart';
import 'package:kanban/data/network/rest_client.dart';
import 'package:kanban/data/repository.dart';
import 'package:kanban/data/sharedpref/shared_preference_helper.dart';
import 'package:kanban/di/module/local_module.dart';
import 'package:kanban/di/module/network_module.dart';
import 'package:kanban/stores/error/error_store.dart';
import 'package:kanban/stores/form/form_store.dart';
import 'package:kanban/stores/language/language_store.dart';
import 'package:kanban/stores/organization/organization_list_store.dart';
import 'package:kanban/stores/post/post_store.dart';
import 'package:kanban/stores/theme/theme_store.dart';
import 'package:kanban/stores/user/user_store.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:sembast/sembast.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  // factories:-----------------------------------------------------------------
  getIt.registerFactory(() => ErrorStore());
  getIt.registerFactory(() => FormStore());

  // async singletons:----------------------------------------------------------
  getIt.registerSingletonAsync<Database>(() => LocalModule.provideDatabase());
  getIt.registerSingletonAsync<SharedPreferences>(
      () => LocalModule.provideSharedPreferences());

  // singletons:----------------------------------------------------------------
  getIt.registerSingleton(
      SharedPreferenceHelper(await getIt.getAsync<SharedPreferences>()));
  getIt.registerSingleton<Dio>(
      NetworkModule.provideDio(getIt<SharedPreferenceHelper>()));
  getIt.registerSingleton(DioClient(getIt<Dio>()));
  getIt.registerSingleton(RestClient());

  // api's:---------------------------------------------------------------------
  getIt.registerSingleton(PostApi(getIt<DioClient>(), getIt<RestClient>()));
  getIt.registerSingleton(OrganizationApi(getIt<DioClient>()));
  getIt.registerSingleton(ProjectApi(getIt<DioClient>()));
  getIt.registerSingleton(BoardApi(getIt<DioClient>()));
  getIt.registerSingleton(BoardItemApi(getIt<DioClient>()));

  // data sources
  getIt.registerSingleton(PostDataSource(await getIt.getAsync<Database>()));
  getIt.registerSingleton(OrganizationDataSource(await getIt.getAsync<Database>()));
  getIt.registerSingleton(ProjectDataSource(await getIt.getAsync<Database>()));

  // repository:----------------------------------------------------------------
  getIt.registerSingleton(Repository(
    getIt<PostApi>(),
    getIt<OrganizationApi>(),
    getIt<ProjectApi>(),
    getIt<BoardApi>(),
    getIt<BoardItemApi>(),
    getIt<SharedPreferenceHelper>(),
    getIt<PostDataSource>(),
    getIt<OrganizationDataSource>(),
    getIt<ProjectDataSource>(),
  ));

  // stores:--------------------------------------------------------------------
  getIt.registerSingleton(LanguageStore(getIt<Repository>()));
  getIt.registerSingleton(PostStore(getIt<Repository>()));
  getIt.registerSingleton(OrganizationListStore(getIt<Repository>()));
  getIt.registerSingleton(ThemeStore(getIt<Repository>()));
  getIt.registerSingleton(UserStore(getIt<Repository>()));
}
