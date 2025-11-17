
import '../../../domain/entities/base/lazy_response.dart';
import 'safe_convert.dart';


class LazyRPM<T>  extends LazyResponse{

  LazyRPM({
    final List<T>? data,
    final int? currentPage,
    final int? totalPages,
    final int? totalCount,
    final int? pageSize,
    final bool? hasPreviousPage,
    final bool? hasNextPage,

    // final List<String> messages;
    final bool? succeeded
  }):super(
      data: data ?? [],
      succeeded: succeeded ?? false,
      pageSize: pageSize ?? 0,
      currentPage: currentPage ?? 0,
      hasNextPage: hasNextPage ?? false,
      hasPreviousPage: hasPreviousPage ?? false,
      totalCount: totalCount ?? 0,
      totalPages: totalPages ?? 0


  );



  factory LazyRPM.fromJson(Map<String, dynamic> json, Function fromJsonT) {
    final items = json['data'].cast<Map<String, dynamic>>();
    return LazyRPM<T>(
      data: List<T>.from(items.map((itemsJson) => fromJsonT(itemsJson))),
      currentPage: asT<int>(json, 'currentPage'),
      totalPages: asT<int>(json, 'totalPages'),
      totalCount: asT<int>(json, 'totalCount'),
      pageSize: asT<int>(json, 'pageSize'),
      hasPreviousPage: asT<bool>(json, 'hasPreviousPage'),
      hasNextPage: asT<bool>(json, 'hasNextPage'),
      // messages: asT<List>(json, 'messages').map((e) => e.toString()).toList(),
      succeeded: asT<bool>(json, 'succeeded'),
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'data': data.map((e) => e),
        'currentPage': currentPage,
        'totalPages': totalPages,
        'totalCount': totalCount,
        'pageSize': pageSize,
        'hasPreviousPage': hasPreviousPage,
        'hasNextPage': hasNextPage,
        // 'messages': messages.map((e) => e),
        'succeeded': succeeded,
      };
}
