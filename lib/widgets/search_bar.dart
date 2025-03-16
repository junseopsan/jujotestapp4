import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String) onSearch;

  const SearchBarWidget({
    super.key,
    required this.onSearch,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchFocused = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: _isSearchFocused
            ? [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ]
            : [],
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: _isSearchFocused ? Theme.of(context).primaryColor : Colors.grey,
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: '검색어를 입력하세요',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12.0),
              ),
              onChanged: (value) {
                if (value.length > 2) {
                  widget.onSearch(value);
                }
              },
              onTap: () {
                setState(() {
                  _isSearchFocused = true;
                });
              },
              onSubmitted: (value) {
                widget.onSearch(value);
                setState(() {
                  _isSearchFocused = false;
                });
              },
            ),
          ),
          if (_searchController.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                _searchController.clear();
                widget.onSearch('');
              },
              child: const Icon(Icons.close, color: Colors.grey),
            ),
        ],
      ),
    );
  }
} 