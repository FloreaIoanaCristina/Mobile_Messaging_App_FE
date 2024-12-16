import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:messaging_mobile_app/conversation_page.dart';
import 'package:messaging_mobile_app/repos/accounts_repo.dart';
import 'package:messaging_mobile_app/repos/conversations_repo.dart';
import 'package:messaging_mobile_app/style/colors.dart';
import 'package:provider/provider.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<dynamic> conversations = [];
  List<dynamic> filteredUsers = [];
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();
  String? _errorMessage; // Error message to display

  @override
  void initState() {
    final conversationsService = Provider.of<ConversationsService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    super.initState();
    _loadConversations(conversationsService, authService);
  }

  // Fetch conversations
  Future<void> _loadConversations(ConversationsService conversationsService, AuthService authService) async {
    try {
      String? userId = await authService.getIdFromClaims();
      if (userId != null) {
        final conversations = await conversationsService.getConversationsForUser(userId);
        setState(() {
          this.conversations = conversations;
        });
      }
    } catch (e) {
      print("Error loading conversations: $e");
    }
  }

  // Search users
  void _searchUsers(String query) async {
    if (query.isEmpty) return;

    try {
      final conversationsService = Provider.of<ConversationsService>(context, listen: false);
      List<dynamic> searchResults = await conversationsService.searchUsersByUsername(query);

      setState(() {
        filteredUsers = searchResults;
        _errorMessage = null; // Clear any previous errors
      });
    } catch (e) {
      print("Error searching users: $e");
    }
  }

  // Handle user selection from search results
  void _onUserSelected(String selectedUserId) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final conversationsService = Provider.of<ConversationsService>(context, listen: false);

    String? currentUserId = await authService.getIdFromClaims();

    // Check if the user is trying to start a conversation with themselves
    if (selectedUserId == currentUserId) {
      setState(() {
        _errorMessage = "You cannot start a conversation with yourself.";
      });
      return;
    }

    try {
      // Attempt to create the conversation
      final conversation = await conversationsService.createConversation(currentUserId!, selectedUserId);

      // If conversation is successfully created, navigate to the new conversation page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ConversationPage(
            conversationId: conversation['conversationId'],
          ),
        ),
      );
    } catch (e) {
      // If the conversation already exists or some other error occurs, display an appropriate error message
      setState(() {
        // Here, we extract a more specific error message from the exception
        _errorMessage = "Error: ${e.toString().replaceFirst('Exception: ', '')}";
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundContactsColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        centerTitle: false,
        toolbarHeight: 80,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            'Contacts',
            style: TextStyle(
              color: AppColors.textColor,
              fontSize: 40,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              iconSize: 40,
              icon: Icon(Icons.search, color: AppColors.accentColor),
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                  filteredUsers = []; // Clear search results when toggling search bar
                  _errorMessage = null; // Clear any error message
                  _searchController.clear();
                });
              },
            ),
          ),
        ],
        leading: null,
      ),
      body: Stack(
        children: [
          // Conversations ListView
          conversations.isEmpty
              ? Center(
            child: Text(
              'You do not have any active conversations',
              style: TextStyle(
                fontSize: 14, // Smaller font size
                color: AppColors.textColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center, // Ensures the text is centered
            ),
          )
              : ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final conversation = conversations[index];
              return Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 16.0, 16.0, 16.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConversationPage(
                          conversationId: conversation['conversationId'],
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundImage: AssetImage('assets/large-default.jpg'),
                        backgroundColor: Colors.grey,
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              conversation['name'],
                              style: TextStyle(
                                color: AppColors.textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              conversation['last_message'] ?? "",
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          // Search Dropdown
          if (_isSearching)
            Positioned(
              top: 0,
              left: 20,
              right: 20,
              child: Material(
                color: AppColors.primaryColor,
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              style: const TextStyle(color: AppColors.textColor),
                              decoration: InputDecoration(
                                hintText: 'Search...',
                                hintStyle: TextStyle(color: AppColors.secondaryColor),
                                border: InputBorder.none,
                              ),
                              onSubmitted: (query) {
                                _searchUsers(query);
                              },
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.search, color: AppColors.accentColor),
                            onPressed: () {
                              _searchUsers(_searchController.text);
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        itemCount: filteredUsers.length,
                        itemBuilder: (context, index) {
                          final user = filteredUsers[index];
                          return ListTile(
                            title: Text(
                              user['userName'],
                              style: TextStyle(color: AppColors.textColor),
                            ),
                            subtitle: _errorMessage != null
                                ? Text(
                              _errorMessage!,
                              style: TextStyle(color: AppColors.errorColor),
                            )
                                : null,
                            onTap: () {
                              _onUserSelected(user['id']);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
