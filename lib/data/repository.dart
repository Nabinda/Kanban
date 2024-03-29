import 'dart:async';

import 'package:kanban/data/local/datasources/post/post_datasource.dart';
import 'package:kanban/data/network/apis/organizations/organization_api.dart';
import 'package:kanban/data/sharedpref/shared_preference_helper.dart';
import 'package:kanban/models/board/board.dart';
import 'package:kanban/models/board/board_list.dart';
import 'package:kanban/models/boardItem/boardItem.dart';
import 'package:kanban/models/boardItem/boardItem_list.dart';
import 'package:kanban/models/organization/organization.dart';
import 'package:kanban/models/organization/organization_list.dart';
import 'package:kanban/models/post/post.dart';
import 'package:kanban/models/post/post_list.dart';
import 'package:kanban/models/project/project.dart';
import 'package:kanban/models/project/project_list.dart';
import 'package:sembast/sembast.dart';

import 'local/constants/db_constants.dart';
import 'local/datasources/board/board_datasource.dart';
import 'local/datasources/boardItem/boardItem_datasource.dart';
import 'local/datasources/organization/organization_datasource.dart';
import 'local/datasources/project/project_datasource.dart';
import 'network/apis/board/boardItem_api.dart';
import 'network/apis/board/board_api.dart';
import 'network/apis/posts/post_api.dart';
import 'network/apis/projects/project_api.dart';

class Repository {
  // data source object
  final PostDataSource _postDataSource;
  final OrganizationDataSource _organizationDataSource;
  final ProjectDataSource _projectDataSource;
  final BoardDataSource _boardDataSource;
  final BoardItemDataSource _boardItemDataSource;

  // api objects
  final PostApi _postApi;
  final OrganizationApi _organizationApi;
  final ProjectApi _projectApi;
  final BoardApi _boardApi;
  final BoardItemApi _boardItemApi;

  // shared pref object
  final SharedPreferenceHelper _sharedPrefsHelper;

  // constructor
  Repository(
    this._postApi,
    this._organizationApi,
    this._projectApi,
    this._boardApi,
    this._boardItemApi,
    this._sharedPrefsHelper,
    this._postDataSource,
    this._organizationDataSource,
    this._projectDataSource,
    this._boardDataSource,
    this._boardItemDataSource,
  );

  // Post: ---------------------------------------------------------------------
  Future<PostList> getPosts() async {
    try {
      PostList postList = await _postDataSource.getPostsFromDb();
      if (postList.posts != null) {
        if (postList.posts!.length > 0) {
          return postList;
        }
      }

      postList = await _postApi.getPosts();
      await _postDataSource.deleteAll();

      postList.posts?.forEach((post) {
        _postDataSource.insert(post);
      });

      return postList;
    } catch (e) {
      throw e;
    }
  }

  Future<List<Post>> findPostById(int id) {
    //creating filter
    List<Filter> filters = [];

    //check to see if dataLogsType is not null
    Filter dataLogTypeFilter = Filter.equals(DBConstants.FIELD_ID, id);
    filters.add(dataLogTypeFilter);

    //making db call
    return _postDataSource
        .getAllSortedByFilter(filters: filters)
        .then((posts) => posts)
        .catchError((error) => throw error);
  }

  Future<int> insert(Post post) => _postDataSource
      .insert(post)
      .then((id) => id)
      .catchError((error) => throw error);

  Future<int> updatePost(Post post) => _postDataSource
      .update(post)
      .then((id) => id)
      .catchError((error) => throw error);

  Future<int> deletePost(Post post) => _postDataSource
      .delete(post)
      .then((id) => id)
      .catchError((error) => throw error);

  Future deleteAll() => _postDataSource
      .deleteAll()
      .then((id) => id)
      .catchError((error) => throw error);

  // Organization: ---------------------------------------------------------------------
  Future<OrganizationList> getOrganizations() async {
    try {
      OrganizationList organizationList =
          await _organizationDataSource.getOrganizationsFromDb();
      if (organizationList.organizations != null) {
        if (organizationList.organizations!.length > 0) {
          return organizationList;
        }
      }
      organizationList = await _organizationApi.getOrganizations();

      // deleteAll because key might repeat, which messes up the id field
      await _organizationDataSource.deleteAll();

      //TODO: do these separately
      await _projectDataSource.deleteAll();
      await _boardDataSource.deleteAll();
      await _boardItemDataSource.deleteAll();

      organizationList.organizations?.forEach((org) {
        _organizationDataSource.insert(org);
      });
      return organizationList;
    } catch (e) {
      throw e;
    }
  }

  Future<Organization> insertOrganization(
      String title, String description) async {
    Organization org = Organization();
    try {
      org = await _organizationApi.insertOrganizations(title, description);
      var future = await _organizationDataSource.insert(org);
      if (future != 0) {
        return org;
      }
    } catch (e) {
      throw e;
    }
    return org;
  }

  Future<int> updateOrganization(Organization org) => _organizationDataSource
      .update(org)
      .then((id) => id)
      .catchError((error) => throw error);

  Future<int> deleteOrganization(Organization org) => _organizationDataSource
      .delete(org)
      .then((id) => id)
      .catchError((error) => throw error);

  // Project: ---------------------------------------------------------------------
  Future<ProjectList> getProjects(int organizationId) async {
    try {
      ProjectList projectList =
          await _projectDataSource.getProjectsFromDb(organizationId);
      if (projectList.projects != null) {
        if (projectList.projects!.length > 0) {
          return projectList;
        }
      }
      // ProjectList
      projectList = await _projectApi.getProjects(organizationId);

      await _projectDataSource.deleteByOrganizationId(organizationId);

      projectList.projects?.forEach((pro) {
        _projectDataSource.insert(pro);
      });
      return projectList;
    } catch (e) {
      throw e;
    }
  }

  Future<int> updateProject(Project project) => _projectDataSource
      .update(project)
      .then((id) => id)
      .catchError((error) => throw error);

  Future<Project> insertProject(
      int orgId, String title, String description) async {
    Project project = Project();
    try {
      project = await _projectApi.insertProject(orgId, title, description);

      var future = await _projectDataSource.insert(project);
      if (future != 0) {
        return project;
      }
    } catch (e) {
      throw e;
    }
    return project;
  }

  Future<int> deleteProject(Project project) => _projectDataSource
      .delete(project)
      .then((id) => id)
      .catchError((error) => throw error);

  // Board: ---------------------------------------------------------------------
  Future<BoardList> getBoards(int projectId) async {
    // later use
    try {
      BoardList boardList = await _boardDataSource.getBoardsFromDb(projectId);
      if (boardList.boards != null) {
        if (boardList.boards!.length > 0) {
          return boardList;
        }
      }
      // boardList
      boardList = await _boardApi.getBoards(projectId);

      await _boardDataSource.deleteByProjectId(projectId);

      boardList.boards?.forEach((board) {
        _boardDataSource.insert(board);
      });
      return boardList;
    } catch (e) {
      throw e;
    }
  }

  Future<Board> insertBoard(int proId, String title, String description) async {
    Board brd = Board();
    try {
      brd = await _boardApi.insertBoard(proId, title, description);
      var future = await _boardDataSource.insert(brd);
      if (future != 0) {
        return brd;
      }
    } catch (e) {
      throw e;
    }
    return brd;
  }

  Future<int> deleteBoard(int boardId) async {
    var brd = 0;
    try {
      brd = await _boardApi.deleteBoard(boardId);
      var future = await _boardDataSource.delete(brd);
      if (future != 0) {
        return brd;
      }
    } catch (e) {
      throw e;
    }
    return brd;
  }

  // BoardItem: ---------------------------------------------------------------------
  Future<BoardItemList> getBoardItems(int boardId) async {
    // later use
    try {
      BoardItemList boardItemList = await _boardItemDataSource.getBoardItemsFromDb(boardId);
      if (boardItemList.boardItemList != null) {
        if (boardItemList.boardItemList!.length > 0) {
          return boardItemList;
        }
      }
      // boardItemList
      boardItemList = await _boardItemApi.getBoardItems(boardId);

      await _boardItemDataSource.deleteByBoardId(boardId);

      boardItemList.boardItemList?.forEach((boardItem) {
        _boardItemDataSource.insert(boardItem);
      });
      return boardItemList;
    } catch (e) {
      throw e;
    }
  }

  Future<BoardItem> insertBoardItem(
      int boardId, String title, String description) async {
    BoardItem brd = BoardItem();
    try {
      brd = await _boardItemApi.insertBoard(boardId, title, description);
      var future = await _boardItemDataSource.insert(brd);
      if (future != 0) {
        return brd;
      }
    } catch (e) {
      throw e;
    }
    return brd;
  }

  Future<int> deleteBoardItem(int boardItemId) async {
    try {
      boardItemId = await _boardItemApi.deleteBoardItem(boardItemId);
      var future = await _boardItemDataSource.delete(boardItemId);
      if (future != 0) {
        return boardItemId;
      }
    } catch (e) {
      throw e;
    }
    return boardItemId;
  }

  // Login:---------------------------------------------------------------------
  Future<bool> login(String email, String password) async {
    return await Future.delayed(Duration(seconds: 2), () => true);
  }

  Future<void> saveIsLoggedIn(bool value) =>
      _sharedPrefsHelper.saveIsLoggedIn(value);

  Future<bool> get isLoggedIn => _sharedPrefsHelper.isLoggedIn;

  // Theme: --------------------------------------------------------------------
  Future<void> changeBrightnessToDark(bool value) =>
      _sharedPrefsHelper.changeBrightnessToDark(value);

  bool get isDarkMode => _sharedPrefsHelper.isDarkMode;

  // Language: -----------------------------------------------------------------
  Future<void> changeLanguage(String value) =>
      _sharedPrefsHelper.changeLanguage(value);

  String? get currentLanguage => _sharedPrefsHelper.currentLanguage;
}
