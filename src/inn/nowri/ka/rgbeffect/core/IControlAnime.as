package inn.nowri.ka.rgbanime.core 
{
	/**
	 * IControlAnime
	 * アニメーション用のインターフェイス 
	 */
	public interface IControlAnime 
	{
		function play():void;
		function togglePause():void;
		function stop():void;
		function stopToDefault(_time:Number=undefined):void;
		function destroy(bool:Boolean = true):void;
		function resumeFromDestroyFalse() : void;
	}
}
