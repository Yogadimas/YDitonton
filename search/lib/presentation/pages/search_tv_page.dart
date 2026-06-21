import 'package:core/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search/presentation/bloc/search_tv_bloc.dart';
import 'package:search/presentation/bloc/search_tv_event.dart';
import 'package:search/presentation/bloc/search_tv_state.dart';
import 'package:tv/presentation/widgets/tv_card_list.dart';

class SearchTVPage extends StatelessWidget {
  static const routeName = '/search-tv';

  const SearchTVPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (query) {
                context.read<SearchTvBloc>().add(OnQueryChangedTv(query));
              },
              decoration: InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text('Search Result', style: kHeading6),
            BlocBuilder<SearchTvBloc, SearchTvState>(
              builder: (context, state) {
                if (state is SearchTvLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is SearchTvHasData) {
                  final result = state.result;
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (_, index) {
                        final tv = result[index];
                        return TVCard(tv);
                      },
                      itemCount: result.length,
                    ),
                  );
                } else if (state is SearchTvError) {
                  return Expanded(
                    child: Center(
                      child: Text(state.message),
                    ),
                  );
                } else {
                  return Expanded(child: Container());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
