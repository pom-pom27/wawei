import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                icon: Icon(Icons.arrow_upward)),
            IconButton(
                onPressed: () {
                  context.read<UserCubit>().sortUsers(false);
                },
                icon: Icon(Icons.arrow_downward)),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                onChanged: (value) {
                  context.read<UserCubit>().searchUsers(value);
                },
                decoration: InputDecoration(
                    hintText: 'Search by name', border: OutlineInputBorder()),
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
                              return UserItem(user: user);
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
  }) : super(key: key);

  final User user;

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
      title: Text(user.name ?? 'No Name'),
      subtitle: Text(user.email ?? 'No Email'),
    );
  }
}
