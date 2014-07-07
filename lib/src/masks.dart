part of convenience_xl;


class GroupMask extends Mask {

  List<Bitmap> _zones = new List();

  GroupMask() : super();

  void renderMask(RenderState renderState) {
    if (renderState.renderContext is RenderContextCanvas) {

      var renderContext = renderState.renderContext as RenderContextCanvas;
      var context = renderContext.rawContext;

      _zones.forEach((b) {
        // Draw rectangle of the bitmap directly - 2d context
        context.rect(b.x, b.y, b.width, b.height);
      });
    } else {
      _zones.forEach((zone) {
        /*
         * Draw two rectangles in GL context:
         * Rect 1 - 1>2>3
         * Rect 2 - 1>3>4
         * 1-----2
         * |     |
         * |     |
         * 4-----3
         */
        renderState.renderTriangle(
            zone.x + 1, zone.y + 1,
            zone.x + zone.width - 2, zone.y + 1,
            zone.x + zone.width - 2, zone.y + zone.height - 2,
            Color.Magenta);
        renderState.renderTriangle(
            zone.x + 1, zone.y + 1,
            zone.x + zone.width - 2, zone.y + zone.height - 2,
            zone.x + 1, zone.y + zone.height - 2,
            Color.Magenta);
      });
    }
  }

  void addZone(Bitmap zone) {
    _zones.add(zone);
  }

  @override
  bool hitTest(num x, num y) {
    return _zones.any((zone) {
      return zone.hitTestPoint(x, y);
    });
  }
}
