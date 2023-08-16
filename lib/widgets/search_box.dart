import 'package:flutter/material.dart';

class SearchBox extends StatefulWidget {
  final onChange;
  const SearchBox({super.key, this.onChange});

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  @override
  Widget build(BuildContext context) {
    var sizeWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: sizeWidth / 1.4,
      child: TextField(
        onChanged: (value) {
          widget.onChange(value);
        },
        decoration: InputDecoration(
          hintText: 'Search',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
