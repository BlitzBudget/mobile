import 'package:flutter/material.dart';
import 'package:mobile_blitzbudget/app/widgets/input.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:mobile_blitzbudget/app/constants/theme.dart';

class Navbar extends StatefulWidget implements PreferredSizeWidget {
  const Navbar(
      {Key? key,
      this.title = 'Home',
      this.categoryOne = '',
      this.categoryTwo = '',
      required this.tags,
      this.transparent = false,
      this.rightOptions = true,
      required this.getCurrentPage,
      required this.searchController,
      this.isOnSearch = false,
      required this.searchOnChanged,
      this.searchAutofocus = false,
      this.backButton = false,
      this.noShadow = false,
      this.bgColor = ArgonColors.white,
      this.searchBar = false})
      : super(key: key);

  final String title;
  final String categoryOne;
  final String categoryTwo;
  final bool searchBar;
  final bool backButton;
  final bool transparent;
  final bool rightOptions;
  final List<String> tags;
  final Function getCurrentPage;
  final bool isOnSearch;
  final TextEditingController searchController;
  final ValueChanged<String>? searchOnChanged;
  final bool searchAutofocus;
  final bool noShadow;
  final Color bgColor;

  @override
  _NavbarState createState() => _NavbarState();

  @override
  Size get preferredSize => const Size.fromHeight(180);
}

class _NavbarState extends State<Navbar> {
  late String activeTag;

  final ItemScrollController _scrollController = ItemScrollController();

  @override
  void initState() {
    if (widget.tags.isNotEmpty) {
      activeTag = widget.tags[0];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final categories =
        widget.categoryOne.isNotEmpty && widget.categoryTwo.isNotEmpty;
    final tagsExist = widget.tags.isNotEmpty;

    return Container(
        height: widget.searchBar
            ? (!categories
                ? (tagsExist ? 211.0 : 178)
                : (tagsExist ? 262.0 : 210.0))
            : (!categories
                ? (tagsExist ? 162.0 : 102.0)
                : (tagsExist ? 200.0 : 150.0)),
        decoration: BoxDecoration(
            color: !widget.transparent ? widget.bgColor : Colors.transparent,
            boxShadow: [
              BoxShadow(
                  color: !widget.transparent && !widget.noShadow
                      ? ArgonColors.initial
                      : Colors.transparent,
                  spreadRadius: -10,
                  blurRadius: 12,
                  offset: const Offset(0, 5))
            ]),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            icon: Icon(
                                !widget.backButton
                                    ? Icons.menu
                                    : Icons.arrow_back_ios,
                                color: !widget.transparent
                                    ? (widget.bgColor == ArgonColors.white
                                        ? ArgonColors.initial
                                        : ArgonColors.white)
                                    : ArgonColors.white,
                                size: 24),
                            onPressed: () {
                              if (!widget.backButton) {
                                Scaffold.of(context).openDrawer();
                              } else {
                                Navigator.pop(context);
                              }
                            }),
                        Text(widget.title,
                            style: TextStyle(
                                color: !widget.transparent
                                    ? (widget.bgColor == ArgonColors.white
                                        ? ArgonColors.initial
                                        : ArgonColors.white)
                                    : ArgonColors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 18)),
                      ],
                    ),
                    if (widget.rightOptions)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/pro');
                            },
                            child: IconButton(
                                icon: Icon(Icons.notifications_active,
                                    color: !widget.transparent
                                        ? (widget.bgColor == ArgonColors.white
                                            ? ArgonColors.initial
                                            : ArgonColors.white)
                                        : ArgonColors.white,
                                    size: 22),
                                onPressed: null),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/pro');
                            },
                            child: IconButton(
                                icon: Icon(Icons.shopping_basket,
                                    color: !widget.transparent
                                        ? (widget.bgColor == ArgonColors.white
                                            ? ArgonColors.initial
                                            : ArgonColors.white)
                                        : ArgonColors.white,
                                    size: 22),
                                onPressed: null),
                          ),
                        ],
                      )
                  ],
                ),
                if (widget.searchBar)
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8, bottom: 4, left: 15, right: 15),
                    child: Input(
                      placeholder: 'What are you looking for?',
                      controller: widget.searchController,
                      onChanged: widget.searchOnChanged,
                      autofocus: widget.searchAutofocus,
                      suffixIcon:
                          const Icon(Icons.zoom_in, color: ArgonColors.muted),
                      onTap: () {
                        Navigator.pushNamed(context, '/pro');
                      },
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
                if (categories)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/pro');
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.camera,
                                color: ArgonColors.initial, size: 22),
                            const SizedBox(width: 10),
                            Text(widget.categoryOne,
                                style: const TextStyle(
                                    color: ArgonColors.initial, fontSize: 16)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 30),
                      Container(
                        color: ArgonColors.initial,
                        height: 25,
                        width: 1,
                      ),
                      const SizedBox(width: 30),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/pro');
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.shopping_cart,
                                color: ArgonColors.initial, size: 22),
                            const SizedBox(width: 10),
                            Text(widget.categoryTwo,
                                style: const TextStyle(
                                    color: ArgonColors.initial, fontSize: 16)),
                          ],
                        ),
                      )
                    ],
                  ),
                if (tagsExist)
                  Container(
                    height: 40,
                    child: ScrollablePositionedList.builder(
                      itemScrollController: _scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.tags.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            if (activeTag != widget.tags[index]) {
                              setState(() => activeTag = widget.tags[index]);
                              _scrollController.scrollTo(
                                  index:
                                      index == widget.tags.length - 1 ? 1 : 0,
                                  duration: const Duration(milliseconds: 420),
                                  curve: Curves.easeIn);
                              widget.getCurrentPage(activeTag);
                            }
                          },
                          child: Container(
                              margin: EdgeInsets.only(
                                  left: index == 0 ? 46 : 8, right: 8),
                              padding: const EdgeInsets.only(
                                  top: 4, bottom: 4, left: 20, right: 20),
                              // width: 90,
                              decoration: BoxDecoration(
                                  color: activeTag == widget.tags[index]
                                      ? ArgonColors.primary
                                      : ArgonColors.secondary,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4))),
                              child: Center(
                                child: Text(widget.tags[index],
                                    style: TextStyle(
                                        color: activeTag == widget.tags[index]
                                            ? ArgonColors.white
                                            : ArgonColors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14)),
                              )),
                        );
                      },
                    ),
                  )
              ],
            ),
          ),
        ));
  }
}
