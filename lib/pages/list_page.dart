import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../cubit/user_cubit.dart';
import '../repositories/models/user/user.dart';
import '../repositories/user_repository.dart';

class UserListPage extends StatelessWidget {
  const UserListPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UserCubit(context.read<UserRepository>())..fetchUsers(),
      child: UserListView(),
    );
  }
}

class UserListView extends StatefulWidget {
  const UserListView({Key? key}) : super(key: key);

  @override
  _UserListViewState createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchEmpty = true;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      context.read<UserCubit>().searchUsers(_searchController.text);
      setState(() {
        _isSearchEmpty = _searchController.text.isEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('User List '),
          actions: [
            IconButton(
                onPressed: () {
                  context.read<UserCubit>().sortUsers(true);
                },
                icon: FaIcon(FontAwesomeIcons.sortAlphaUp)),
            IconButton(
                onPressed: () {
                  context.read<UserCubit>().sortUsers(false);
                },
                icon: FaIcon(FontAwesomeIcons.sortAlphaDown)),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by name',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  suffixIcon: _isSearchEmpty
                      ? null
                      : IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                          },
                        ),
                ),
              ),
              Expanded(
                child: BlocConsumer<UserCubit, UserState>(
                  listener: (context, state) {
                    if (state.status.isFailure) {
                      final snackBar = SnackBar(content: Text('Error!'));

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  builder: (context, state) {
                    switch (state.status) {
                      case UserStatus.initial:
                        return Empty();
                      case UserStatus.loading:
                        return Loading();
                      case UserStatus.failure:
                      case UserStatus.success:
                      default:
                        return RefreshIndicator(
                          onRefresh: () async {
                            await context.read<UserCubit>().fetchUsers();
                          },
                          child: ListView.builder(
                            itemBuilder: (context, idx) {
                              final user = state.users[idx];

                              final queryText = user.name!
                                  .substring(0, _searchController.text.length);

                              final remainingText = user.name!
                                  .substring(_searchController.text.length);

                              return UserItem(
                                user: user,
                                queryText: queryText,
                                remainingText: remainingText,
                              );
                            },
                            itemCount: state.users.length,
                          ),
                        );
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class Empty extends StatelessWidget {
  const Empty({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('List Kosong'),
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class UserFailure extends StatelessWidget {
  const UserFailure({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Error'),
          ElevatedButton(
            onPressed: () async {
              await context.read<UserCubit>().fetchUsers();
            },
            child: Text('Coba lagi'),
          )
        ],
      ),
    );
  }
}

class UserItem extends StatelessWidget {
  const UserItem({
    Key? key,
    required this.user,
    required this.queryText,
    required this.remainingText,
  }) : super(key: key);

  final User user;

  final String queryText, remainingText;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      horizontalTitleGap: 4,
      leading: Container(
          height: double.infinity,
          child: Icon(
            Icons.account_circle,
            color: Colors.blue[400],
          )),
      title: queryText.isEmpty
          ? Text(user.name ?? 'No name')
          : RichText(
              text: TextSpan(
                  text: queryText,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 16),
                  children: [
                    TextSpan(
                      text: remainingText,
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                      ),
                    )
                  ]),
            ),
      subtitle: Text(user.email ?? 'No Email'),
    );
  }
}
