import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutterpractic/core/enums/versions.dart';
import 'package:flutterpractic/modules/home/context/book_context.dart';
import 'package:flutterpractic/modules/search/services/search_service.dart';

import 'package:flutterpractic/shared/widgets/select_version.dart';

import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// FIXME: This is a workaround for the issue #1

class SearchScreen extends HookConsumerWidget {
  SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bibleContext = ref.watch(bibleProvider);

    final results = useState(<SearchResult>[]);

    final searchController = useState(TextEditingController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: searchController.value,
              decoration: const InputDecoration(
                labelText: "Search query",
                border: OutlineInputBorder(),
              ),
            ),
            /* Row(
              children: [BibleSelectVersion()],
            ), */
            ElevatedButton(
              onPressed: () async {
                final data = await searchBible(
                  version: bibleContext.version!,
                  query: searchController.value.text,
                  testament: "old",
                );
                if (data == null) {
                  return;
                }
                results.value = data.data;
              },
              child: const Text("Search"),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: results.value.length,
                itemBuilder: (context, index) {
                  final result = results.value[index];
                  return InkWell(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Flexible(
                          child: Text(
                            result.verse,
                            style: const TextStyle(
                              fontSize: 16.0,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      ref.read(bibleProvider.notifier).state =
                          ref.read(bibleProvider.notifier).state.copyWith(
                                book: result.book,
                                chapter: result.chapter,
                              );
                      context.go('/book/chapter');
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
