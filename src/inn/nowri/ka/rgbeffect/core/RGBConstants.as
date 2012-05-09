package inn.nowri.ka.rgbeffect.core 
{
	import flash.display.StageAlign;

	public class RGBConstants 
	{
		/**
		 * ビットマップの基準
		 * "":center_middle
		 * "TL":top_left
		 */
		public static const BASE_ALIGN:String =StageAlign.TOP_LEFT;
			
		/**
		 * ランダムな移動をする場合、元移動量からの最大増加倍率
		 */
		public static const MAX_RANDOM_VALUE:Number =9;


		
//////////////////////////////////////////////////////////////// 
//	flick control
////////////////////////////////////////////////////////////////
		public static const FLICK_INTERVAL:Number = 0.001;
		public static const FLICK_TIME:Number = 0.0001;
		/**
		 * Math.random()の値がこれ未満の場合に visible=false します。
		 */
		public static const FLICK_RANDOM_VALUE:Number = 0.03;
	//	public static const FLICK_MAX_RANDOM_VALUE:Number = 0.3;
	}
}