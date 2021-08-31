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

class UserListView extends StatelessWidget {
  const UserListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('User List '),
        ),
        body: BlocConsumer<UserCubit, UserState>(
          listener: (context, state) {
            if (state.status.isFailure) {
              final snackBar = SnackBar(content: Text('Error!'));

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          builder: (context, state) {
            switch (state.status) {
              case UserStatus.initial:
                return Center(
                  child: Text('List Kosong'),
                );
              case UserStatus.loading:
                return Center(
                  child: CircularProgressIndicator(),
                );

              case UserStatus.failure:
              // return UserFailure();
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
        ));
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
