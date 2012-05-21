package inn.nowri.ka.rgbeffect.core 
{
	import flash.events.Event;

	public class RGBEvent extends Event 
	{
		public static const PLAY_COMPLETE:String = "PLAY_COMPLETE";
				
		public function RGBEvent(type:String) 
		{
			super(type);
		}
	
		public override function clone() : Event 
		{
			return new RGBEvent(type);
		}
	}

}
