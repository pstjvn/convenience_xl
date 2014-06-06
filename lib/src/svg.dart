part of convenience_xl;



/**
 * Attempts to generate a new BitmapData instance from an SVG string.
 *
 * Note that the SVG string should include the xmlns attribute for this to work
 * correctly in some browsers.
 */
Future<BitmapData> fromSvg(String _svg, int width, int height) {

  var s = new SvgElement.svg(_svg)
    ..setAttribute('width', width.toString())
    ..setAttribute('height', height.toString());

  var blob = new Blob([s.outerHtml], "image/svg+xml;charset=utf-8");
  var url = Url.createObjectUrlFromBlob(blob);
  var image = new ImageElement();
  var a = new Completer();

  image.src = url;

  image.onLoad.listen((_) {
    Url.revokeObjectUrl(url);
    a.complete(new BitmapData.fromImageElement(image));
  });

  image.onError.listen((_) {
    Url.revokeObjectUrl(url);
    a.completeError('Counl not load SVG image into BitmapData');
  });

  return a.future;
}
