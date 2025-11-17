
extension ColorFromString on String {
  int toColor() {
    return int.parse(replaceAll('#', ''));
  }
}
