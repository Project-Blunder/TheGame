package ;

/**
 * ...
 * @author 
 */
class Util
{
	/**
	 * Returns the domain of a URL.
	 */
	public static function getDomain(url:String):String
	{
		var urlStart:Int = url.indexOf("://");
		if (urlStart < 0)
		{
			urlStart = 0;
		}
		else
		{
			urlStart += 3;
		}
		var urlEnd:Int = url.indexOf("/", urlStart);
		if (urlEnd < 0)
		{
			urlEnd = url.length;
		}
		var home:String = url.substring(urlStart, urlEnd);
		return (home == "") ? "local" : home;
	}
}