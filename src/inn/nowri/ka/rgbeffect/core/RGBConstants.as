package inn.nowri.ka.rgbeffect.core 
{

	public class RGBConstants 
	{
		/**
		 * ビットマップの基準
		 * "":center_middle
		 * "TL":top_left
		 */
		public static const BASE_ALIGN:String ="";
			
		/**
		 * ランダムな移動をする場合、元移動量からの最大増加倍率
		 */
		public static const MAX_RANDOM_VALUE:Number =9;

//////////////////////////////////////////////////////////////// 
//	yoyo
////////////////////////////////////////////////////////////////		
		/**
		 * 方向 ALLの場合の実行されるしきい値
		 * @see inn.nowri.ka.rbgeffect.type.Yoyo
		 */
		public static const ALL_SHOW_THRESHOLD:Number = 0.7;

//////////////////////////////////////////////////////////////// 
//	oneDirection
////////////////////////////////////////////////////////////////		
		/**
		 * Fillinの動く量がパラメータmaxに対してどれくらいの割合か
		 * @see inn.nowri.ka.rbgeffect.type.OneDirection
		 */
		public static const FILLIN_MOVE_VALUE:Number = 0.3;
		
		/**
		 * Fillinの振幅時間がパラメータmaxに対してどれくらいの割合か
		 * @see inn.nowri.ka.rbgeffect.type.OneDirection
		 */
		public static const FILLIN_MOVE_TIME:Number = 0.5;
		
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