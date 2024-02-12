import 'package:flutter/material.dart';
import 'package:strong_password/common/color_constants.dart';

// ignore: must_be_immutable
class SearchPassword extends StatelessWidget {
  SearchPassword({super.key, required this.onSearch});

  bool isCancelActive = true;
  Function(String) onSearch;
  
  @override
  Widget build(BuildContext context) {
    return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: SearchAnchor(
              builder: (BuildContext context, SearchController controller) {
                return SearchBar(
                  backgroundColor: MaterialStateColor.resolveWith(
                      (states) => Colors.grey.shade600),
                  hintText: 'Search Passwords',
                  hintStyle: MaterialStateTextStyle.resolveWith(
                      (states) => TextStyle(color: Colors.grey.shade200)),
                  textStyle: MaterialStateTextStyle.resolveWith(
                      (states) => const TextStyle(color: Colors.white)),
                  constraints: const BoxConstraints(
                    minHeight: 36,
                    maxHeight: 40,
                  ),
                  surfaceTintColor:
                      MaterialStateColor.resolveWith((states) => AppColors.componentColor),
                  // trailing: <Widget>[
                  //   AnimatedCrossFade(
                  //     firstChild: IconButton(
                  //       icon: const Icon(Icons.clear, color: Colors.white),
                  //       onPressed: () {
                  //         controller.clear();
                  //       },
                  //     ),
                  //     secondChild:
                  //         const SizedBox(), // You can provide an empty widget or any other widget you want to show when isCancelActive is false
                  //     crossFadeState: isCancelActive
                  //         ? CrossFadeState.showFirst
                  //         : CrossFadeState.showSecond,
                  //     duration: const Duration(milliseconds: 300),
                  //   ),
                  //   // Todo: I dont like animation's toward.(Edit)
                  // ],
                  controller: controller,
                  padding: const MaterialStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 16.0)),
                  onTap: () {
                    controller.buildTextSpan(
                        context: context, withComposing: false);
                  },
                  onChanged: (query) {
                    onSearch(query);
                    isCancelActive = query.isNotEmpty;
                  },
                  leading: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                );
              },
              suggestionsBuilder:
                  (BuildContext context, SearchController controller) async {
                // Return your suggestions here if needed
                return <Widget>[];
              },
            ),
          );
  }
}