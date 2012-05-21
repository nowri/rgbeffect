package inn.nowri.ka.rgbeffect 
{
	import inn.nowri.ka.rgbeffect.type.FromEachEnd;
	import inn.nowri.ka.rgbeffect.type.OneDirection;
	import inn.nowri.ka.rgbeffect.type.Yoyo;

	import flash.display.BitmapData;
	
	/**
	 * RGBAnime Class 
	 * 
	 * @version 2.0
	 * @update  2012/05/21 ver.2.0 <code>FromEachEnd</code>追加、VO追加
	 * @update  2012/05/09 ver.1.6
	 * @update  2012/05/08 ver.1.5 パッケージ名変更
	 * @update  2010/05/28 ver.1.11
	 * @update  2010/05/27 ver.1.1 再生終了時onCompleteのdispatch追加
	 * @update  2010/05/25 ver.1.02
	 * @update  2010/05/23 ver.1.01
	 * @update  2010/05/09 ver.1.0
	 * @update  2010/05/07 ver.0.1
	 * @date	2010/05/07
	 * @author	nowri.ka
	 */
	public class RGBAnime 
	{
		/**
		 * 
		 * @param bmd:BitmapData
		 * @param obj:Object
		 * {<br>
		 * 		time:Number 振幅時間、デフォルト1秒,<br>
		 * 		count:uint リピート回数、デフォルト無限、0を指定でも無限,<br>
		 * 		max:Number 最大移動量デフォルト10,<br>
		 * 		delay:Number r、g、bパートの遅延時間、デフォルト0.4秒,<br><br>
		 * 		direction:String 方向
		 * 			<ul><li>import inn.nowri.ka.rgbeffect.core.RGBCommandConstants;</li>
		 * 			<li>RGBCommandConstants.RIGHT_LEFT //左右,</li>
		 * 			<li>RGBCommandConstants.UP_DOWN //上下,</li>
		 * 			<li>RGBCommandConstants.ALL //全方向,</li>
		 * 			</ul><br><br>
		 * 		random:Number ランダム値、デフォルト0.5,<br>
		 * 		isFlick:Boolean ちらつき演出するか、デフォルトtrue,<br>
		 * 		blend:uint ブレンドモード種類 デフォルト0,<br>
		 * 		0# 2-乗算、1-乗算、0-通常<br>
		 * 		1# 2-乗算、1-乗算、0-乗算<br>
		 * 	}
		 */
		public static function yoyo(bmd:BitmapData,obj:Object):Yoyo
		{
			return new Yoyo(bmd,obj);
		}
		
		/**
		 * 
		 * @param bmd:BitmapData
		 * @param obj:Object {<br>
		 * 	time:Number 移動時間、デフォルト0.5秒,<br>
		 * 	count:uint リピート回数、デフォルト無限、0を指定でも無限,<br>
		 * 	max:Number 最大移動量デフォルト100,<br>
		 * 	delay:Number r、g、bパートの遅延時間、デフォルト0.1秒,<br><br>
		 * 	direction:String 方向
		 * 		<ul>
		 * 		<li>import inn.nowri.ka.rgbeffect.core.RGBCommandConstants;</li>
		 * 		<li>RGBCommandConstants.LEFT //左,</li>
		 * 		<li>RGBCommandConstants.RIGHT //右,</li>
		 * 		<li>RGBCommandConstants.UP //上,</li>
		 * 		<li>RGBCommandConstants.DOWN //下,</li>
		 * 		</ul><br><br>
		 * 	random:Number ランダム値、デフォルト0,<br>
		 * 	isFlick:Boolean ちらつき演出するか、デフォルトtrue,<br>
		 * 	blend:uint ブレンドモード種類 デフォルト0<br>
		 * 		0# 2-乗算、1-乗算、0-通常<br>
		 * 		1# 2-乗算、1-乗算、0-乗算<br>
		 * 	}
		 * 	@param isFillin:Boolean 最初のオカズ有りか無しか
		 */
		public static function oneDirection(bmd:BitmapData, obj:Object, isFillin:Boolean= false) : OneDirection
		{
			return new OneDirection(bmd,obj,isFillin);
		}
		
		public static function fromEachEnd(bmd:BitmapData, obj:Object) : FromEachEnd
		{
			return new FromEachEnd(bmd,obj);
		}
		
	}
}
