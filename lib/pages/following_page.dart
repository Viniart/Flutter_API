import 'package:flutter/material.dart';
import 'package:github_api_demo/api/github_api.dart';
import 'package:github_api_demo/models/user.dart';

class FollowingPage extends StatefulWidget {
  final User user;

  FollowingPage({Key? key, required this.user}) : super(key: key);

  @override
  State<FollowingPage> createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  @override
  Widget build(BuildContext context) {
    final followersFuture = GithubApi().findFollowers(widget.user.login);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Following"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundColor: Colors.blue,
                    backgroundImage: NetworkImage(widget.user.avatarUrl),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  widget.user.login,
                  style: const TextStyle(fontSize: 22),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            // Lista de usuários seguindo
            child: Container(
              child: FutureBuilder<List<User?>>(
                  future: followersFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text("Erro ao carregar seguidores"),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text("Nenhum seguidor encontrado"),
                      );
                    } else {
                      final followers = snapshot.data!;
                      return ListView.separated(
                        itemCount: followers.length,
                        itemBuilder: (context, index) {
                          final follower = followers[index];
                          return ListTile(
                            leading: CircleAvatar(
                              radius: 20.0,
                              backgroundColor: Colors.blue,
                              backgroundImage:
                                  NetworkImage(follower!.avatarUrl),
                            ),
                            title: Text(follower.login),
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(),
                      );
                    }
                  }),
            ),
          ),
        ]),
      ),
    );
  }
}
