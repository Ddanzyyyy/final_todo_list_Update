import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomFABMenu extends StatefulWidget {
  final VoidCallback onSearchPressed;
  final VoidCallback onBinPressed;
  final VoidCallback onAddPressed;
  final bool isSearching;

  const CustomFABMenu({
    Key? key,
    required this.onSearchPressed,
    required this.onBinPressed,
    required this.onAddPressed,
    required this.isSearching,
  }) : super(key: key);

  @override
  State<CustomFABMenu> createState() => _CustomFABMenuState();
}

class _CustomFABMenuState extends State<CustomFABMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Map<int, bool> _hoveredStates = {0: false, 1: false, 2: false};
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setHovered(int index, bool isHovered) {
    setState(() {
      _hoveredStates[index] = isHovered;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return AnimatedScale(
      duration: const Duration(milliseconds: 300),
      scale: _isExpanded ? 1.05 : 1.0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: isSmallScreen ? 60 : 70,
        margin: EdgeInsets.symmetric(
          horizontal: screenWidth * (isSmallScreen ? 0.03 : 0.05),
          vertical: isSmallScreen ? 12 : 16,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF2C3E50),
              Color.fromARGB(255, 81, 108, 136),
              Color(0xFF651FFF),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6200EA).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildFABButton(
              index: 0,
              icon: widget.isSearching 
                ? Icons.close_rounded 
                : Icons.search_rounded,
              onPressed: () {
                widget.onSearchPressed();
                _playButtonAnimation(0);
              },
              tooltip: widget.isSearching ? 'Close Search' : 'Search',
              isSmallScreen: isSmallScreen,
            ),
            _buildFABButton(
              index: 2,
              icon: Icons.add,
              onPressed: () {
                widget.onAddPressed();
                _playButtonAnimation(2);
              },
              tooltip: 'Add Task',
              isSmallScreen: isSmallScreen,
            ),
            _buildFABButton(
              index: 1,
              icon: Icons.delete_rounded,
              onPressed: () {
                widget.onBinPressed();
                _playButtonAnimation(1);
              },
              tooltip: 'Delete',
              isSmallScreen: isSmallScreen,
            ),
          ],
        ),
      ),
    );
  }

  void _playButtonAnimation(int index) {
    HapticFeedback.mediumImpact();
    setState(() {
      _hoveredStates[index] = true;
    });
    
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _hoveredStates[index] = false;
        });
      }
    });
  }

  Widget _buildFABButton({
    required int index,
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
    required bool isSmallScreen,
    bool isMain = false,
  }) {
    final bool isHovered = _hoveredStates[index] ?? false;
    
    return MouseRegion(
      onEnter: (_) => _setHovered(index, true),
      onExit: (_) => _setHovered(index, false),
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 200),
        tween: Tween<double>(
          begin: 0.0,
          end: isHovered ? 1.0 : 0.0,
        ),
        builder: (context, value, child) {
          return Transform.scale(
            scale: 1.0 + (0.1 * value),
            child: Container(
              width: isSmallScreen ? 50 : 60,
              height: isSmallScreen ? 50 : 60,
              margin: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 4 : 6,
              ),
              decoration: BoxDecoration(
                color: isHovered
                    ? Colors.white.withOpacity(0.25)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 12),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 12),
                  onTap: onPressed,
                  child: Tooltip(
                    message: tooltip,
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: isSmallScreen ? 22 : 26,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
