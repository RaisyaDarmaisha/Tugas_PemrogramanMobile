import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class Clothing {
  final String name;
  final String category;

  Clothing({required this.name, required this.category});
}

class ClothingProvider extends ChangeNotifier {
  List<Clothing> _clothingList = [];

  List<Clothing> get clothingList => _clothingList;

  void addClothing(Clothing clothing) {
    _clothingList.add(clothing);
    notifyListeners();
  }

  void deleteClothing(int index) {
    _clothingList.removeAt(index);
    notifyListeners();
  }
}

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(size: 100),
            SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Perform login logic here
                // For simplicity, let's assume login is successful
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clothing App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Product List',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ClothingListScreen(),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: FloatingActionButton(
              onPressed: () {
                // Implement logout logic
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                  (route) => false,
                );
              },
              tooltip: 'Logout',
              child: Icon(Icons.exit_to_app),
            ),
          ),
          Row(
            children: [
              FloatingActionButton(
                onPressed: () {
                  // Implement search functionality
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchScreen(),
                    ),
                  );
                },
                tooltip: 'Search',
                child: Icon(Icons.search),
              ),
              SizedBox(width: 16),
              FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddClothingScreen()),
                  );
                },
                tooltip: 'Add Clothing',
                child: Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class ClothingListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var clothingProvider = Provider.of<ClothingProvider>(context);
    var clothingList = clothingProvider.clothingList;

    return ListView.builder(
      itemCount: clothingList.length,
      itemBuilder: (context, index) {
        var clothing = clothingList[index];
        // Adding 1 to index since the list index starts from 0
        int itemNumber = index + 1;

        return Card(
          elevation: 3,
          margin: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              child: Text('$itemNumber'),
            ),
            title: Text(
              clothing.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              clothing.category,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Call a function to delete the clothing item
                _showDeleteDialog(context, clothingProvider, index);
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _showDeleteDialog(BuildContext context,
      ClothingProvider clothingProvider, int index) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Clothing'),
          content: Text('Are you sure you want to delete this clothing item?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Perform delete operation
                clothingProvider.deleteClothing(index);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

class AddClothingScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Clothing'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.shopping_bag),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(
                labelText: 'Category',
                prefixIcon: Icon(Icons.category),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                var clothingProvider =
                    Provider.of<ClothingProvider>(context, listen: false);
                var newClothing = Clothing(
                  name: _nameController.text,
                  category: _categoryController.text,
                );
                clothingProvider.addClothing(newClothing);
                Navigator.pop(context);
              },
              child: Text('Add Clothing'),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Clothing> _searchResults = [];

  @override
  Widget build(BuildContext context) {
    var clothingProvider = Provider.of<ClothingProvider>(context);
    var clothingList = clothingProvider.clothingList;

    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                setState(() {
                  _searchResults = clothingList
                      .where((clothing) => clothing.name
                          .toLowerCase()
                          .contains(query.toLowerCase()))
                      .toList();
                });
              },
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: _searchResults.isEmpty
                ? Center(
                    child: Text('No results found.'),
                  )
                : ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      var clothing = _searchResults[index];
                      return Card(
                        elevation: 3,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(
                            clothing.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            clothing.category,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ClothingProvider()
        ..addClothing(Clothing(name: 'T-Shirt', category: 'Casual'))
        ..addClothing(Clothing(name: 'Jeans', category: 'Denim'))
        ..addClothing(Clothing(name: 'Jeans', category: 'Casual'))
        ..addClothing(Clothing(name: 'Shirt', category: 'Denim'))
        ..addClothing(Clothing(name: 'Dress', category: 'Casual'))
        ..addClothing(Clothing(name: 'Jeans', category: 'Formal'))
        ..addClothing(Clothing(name: 'T-Shirt', category: 'Formal'))
        ..addClothing(Clothing(name: 'Short Pants', category: 'Denim'))
        ..addClothing(Clothing(name: 'Long Sleeve', category: 'Casual'))
        ..addClothing(Clothing(name: 'Dress Shirt', category: 'Formal')),
      child: MaterialApp(
        title: 'Clothing App',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: LoginScreen(),
      ),
    );
  }
}
