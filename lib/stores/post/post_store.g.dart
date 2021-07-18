// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PostStore on _PostStore, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??=
          Computed<bool>(() => super.loading, name: '_PostStore.loading'))
      .value;

  final _$fetchPostsFutureAtom = Atom(name: '_PostStore.fetchPostsFuture');

  @override
  ObservableFuture<PostList?> get fetchPostsFuture {
    _$fetchPostsFutureAtom.reportRead();
    return super.fetchPostsFuture;
  }

  @override
  set fetchPostsFuture(ObservableFuture<PostList?> value) {
    _$fetchPostsFutureAtom.reportWrite(value, super.fetchPostsFuture, () {
      super.fetchPostsFuture = value;
    });
  }

  final _$postListAtom = Atom(name: '_PostStore.postList');

  @override
  ObservableList<Post> get postList {
    _$postListAtom.reportRead();
    return super.postList;
  }

  @override
  set postList(ObservableList<Post> value) {
    _$postListAtom.reportWrite(value, super.postList, () {
      super.postList = value;
    });
  }

  final _$successAtom = Atom(name: '_PostStore.success');

  @override
  bool get success {
    _$successAtom.reportRead();
    return super.success;
  }

  @override
  set success(bool value) {
    _$successAtom.reportWrite(value, super.success, () {
      super.success = value;
    });
  }

  final _$getPostsAsyncAction = AsyncAction('_PostStore.getPosts');

  @override
  Future<dynamic> getPosts() {
    return _$getPostsAsyncAction.run(() => super.getPosts());
  }

  final _$deletePostAsyncAction = AsyncAction('_PostStore.deletePost');

  @override
  Future<dynamic> deletePost(Post post) {
    return _$deletePostAsyncAction.run(() => super.deletePost(post));
  }

  final _$deleteAllAsyncAction = AsyncAction('_PostStore.deleteAll');

  @override
  Future<dynamic> deleteAll() {
    return _$deleteAllAsyncAction.run(() => super.deleteAll());
  }

  final _$updatePostAsyncAction = AsyncAction('_PostStore.updatePost');

  @override
  Future<dynamic> updatePost(Post post) {
    return _$updatePostAsyncAction.run(() => super.updatePost(post));
  }

  @override
  String toString() {
    return '''
fetchPostsFuture: ${fetchPostsFuture},
postList: ${postList},
success: ${success},
loading: ${loading}
    ''';
  }
}
