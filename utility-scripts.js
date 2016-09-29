
/**
 * Method to create hashcode from any string.
 * E.g var text = '71d1c454c147e10923dff4f025d90c5a'; => 1181378191
 * @param string text
 */
function createHashCode(text) {
  return Math.abs(text.split("").reduce(function(a,b){a=((a<<5)-a)+b.charCodeAt(0);return a&a;},0));
}
