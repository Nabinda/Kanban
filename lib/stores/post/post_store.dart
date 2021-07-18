import 'package:kanban/data/repository.dart';
import 'package:kanban/models/post/post.dart';
import 'package:kanban/models/post/post_list.dart';
import 'package:kanban/stores/error/error_store.dart';
import 'package:kanban/utils/dio/dio_error_util.dart';
import 'package:mobx/mobx.dart';

part 'post_store.g.dart';

class PostStore = _PostStore with _$PostStore;

abstract class _PostStore with Store {
  // repository instance
  late Repository _repository;

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  _PostStore(Repository repository) : this._repository = repository;

  // store variables:-----------------------------------------------------------
  static ObservableFuture<PostList?> emptyPostResponse =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<PostList?> fetchPostsFuture =
      ObservableFuture<PostList?>(emptyPostResponse);

  @observable
  ObservableList<Post> postList = ObservableList<Post>();

  @observable
  bool success = false;

  @computed
  bool get loading => fetchPostsFuture.status == FutureStatus.pending;

  // actions:-------------------------------------------------------------------
  @action
  Future getPosts() async {
    final future = _repository.getPosts();
    fetchPostsFuture = ObservableFuture(future);
    this.postList.clear();
    future.then((postList) {
      if (postList.posts != null) {
        for (Post post in postList.posts!) {
          this.postList.add(post);
        }
      }
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
  }

  @action
  Future deletePost(Post post) async {
    final future = _repository.deletePost(post);
    //deletePostFuture = ObservableFuture(future);
    future.then((postList) {}).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
  }

  @action
  Future deleteAll() async {
    _repository.deleteAll();
  }

  @action
  Future updatePost(Post post) async {
    final future = _repository.updatePost(post);
    // fetchPostsFuture = ObservableFuture(future);
    future.then((postList) {
      Post upPost =
          this.postList.firstWhere((postItem) => postItem.id == post.id);
      int index = this.postList.indexOf(upPost);
      this.postList[index] = post;
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
  }
}
