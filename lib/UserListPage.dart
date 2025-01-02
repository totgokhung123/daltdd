import 'package:flutter/material.dart';
import 'AddUserPage.dart';
import 'ApiService.dart';

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late Future<List<dynamic>> _users;

  @override
  void initState() {
    super.initState();
    _users = ApiService().fetchUsers();
  }

  void _refreshData() {
    setState(() {
      _users = ApiService().fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh sách người dùng"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _users,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          }

          final users = snapshot.data ?? [];
          if (users.isEmpty) {
            return Center(child: Text("Không có người dùng."));
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(users[index]['name']),
                subtitle: Text('Email: ${users[index]['email']}'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddUserPage()),
          ).then((_) => _refreshData());
        },
      ),
    );
  }
}
