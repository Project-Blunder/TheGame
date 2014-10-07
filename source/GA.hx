package ;


import googleAnalytics.Stats;

/**
 * ...
 * @author 
 */
class GA
{
	static public function submit(category, event, label)
	{
		try
		{
			Stats.trackEvent(category, event, label, 0);
		}
		catch (e:Dynamic)
		{
			
		}
	}
}