
String parseUrl(String url) {
  if (url.startsWith('http://') || url.startsWith('https://')) {
    return url;
  } else {
    return 'http://$url';
  }
}