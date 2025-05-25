import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tubes/home.dart';
import 'package:tubes/profile.dart';
import 'package:tubes/login_page.dart';
import 'package:tubes/list_book.dart';
import 'package:tubes/recommended_book.dart';
import 'package:tubes/searchpage.dart';
import 'package:tubes/provider/auth_provider.dart';

class GlobalScaffold extends StatefulWidget {
  final Widget body;
  final int selectedIndex;

  const GlobalScaffold({
    super.key,
    required this.body,
    required this.selectedIndex,
  });

  @override
  State<GlobalScaffold> createState() => _GlobalScaffoldState();
}

class _GlobalScaffoldState extends State<GlobalScaffold> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) async {
    if (index == widget.selectedIndex) return;
    if (index == 3) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.isAuthenticated) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                const ProfilePage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => const LoginPage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      }
      return;
    }

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => const HomePage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                const ListBooksPage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                const RecommendedPage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: const Color.fromRGBO(241, 244, 249, 1),
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.menu_book_outlined,
                    size: 35,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search for books',
                          hintStyle: const TextStyle(
                            color: Color.fromRGBO(150, 150, 150, 1),
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color.fromRGBO(100, 100, 100, 1),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                        onSubmitted: (value) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BookSearchPage(searchQuery: value),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: widget.body),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontSize: 12),
        currentIndex: widget.selectedIndex == 4 ? 0 : widget.selectedIndex,
        backgroundColor: const Color.fromRGBO(241, 244, 249, 1),
        selectedItemColor: widget.selectedIndex == 4
            ? const Color.fromARGB(253, 129, 128, 128)
            : const Color.fromRGBO(1, 8, 23, 1),
        onTap: _onItemTapped,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'List Book',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Recommended',
          ),
          BottomNavigationBarItem(
            icon: Icon(authProvider.isAuthenticated
                ? Icons.person_outline
                : Icons.login),
            label: authProvider.isAuthenticated ? 'Profile' : 'Sign In',
          ),
        ],
      ),
    );
  }
}
