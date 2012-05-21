package inn.nowri.ka.rgbeffect.type 
{
	import inn.nowri.ka.rgbeffect.core.RGBEvent;
	import org.libspark.betweenas3.BetweenAS3;
	import org.libspark.betweenas3.core.easing.IEasing;
	import org.libspark.betweenas3.easing.Sine;
	import inn.nowri.ka.rgbeffect.core.IControlAnime;
	import inn.nowri.ka.rgbeffect.core.RGBControlObject;

	import flash.display.BitmapData;

	public class FromEachEnd extends RGBControlObject implements IControlAnime
	{
		public static const HORIZONAL:String = "HORIZONAL";
		public static const VERTICAL:String = "VERTICAL";
		
		private var time:Number;
		private var transition:IEasing;
		private var direction:String;
		private var max:Number=20;
		private var delay:Number=0.2;
		
		/**
		 * TODO isFrick not implemented 
		 * TODO random not implemented 
		 */
		public function FromEachEnd(bmd:BitmapData, obj:Object)
		{
			super(bmd, obj);
			time=(obj.time||obj.time==0)? obj.time:time;
			transition=(obj.transition)? obj.transition:Sine.easeOut;
			direction = (obj.direction)? obj.direction.toUpperCase() : HORIZONAL;
			max = (obj.max||obj.max==0)? obj.max : max;
			
		}
		
		override public function play() : void
		{
			if(_isDestroyed!=1)return;
			_isPlaying = true;
			
			var blurObj:Object={};
			var fromObj:Object={_blurFilter:blurObj,alpha:0};
			var toObj:Object={_blurFilter:{blurX:0, blurY:0}};
			switch(direction)
			{
				case HORIZONAL:
					fromObj["$width"] = max;
					blurObj["blurX"] = max;
					break;

				case VERTICAL:
					fromObj["$height"] = max;
					blurObj["blurY"] = max;
					break;
			}
			rTween = BetweenAS3.tween(rgb[0], toObj, fromObj, time, transition);
			gTween = BetweenAS3.tween(rgb[1], toObj, fromObj, time, transition);
			bTween = BetweenAS3.tween(rgb[2], toObj, fromObj, time, transition);
			var ar:Array = [rTween, gTween, bTween];
			ar = shuffleArray(ar);
			for(var i:int=0; i<3; i++) 
			{
				ar[i] = BetweenAS3.delay(ar[i], delay*i);
			}
			tweeng = BetweenAS3.parallelTweens(ar);
			tweeng.onComplete = function():void
			{
				_isPlaying = false;
				dispatchEvent(new RGBEvent(RGBEvent.PLAY_COMPLETE));
			};
			tweeng.play();
//			if(isFlick)controlFlick(true);
		}
		
		override public function stop() : void
		{
			if(_isDestroyed!=1 || !_isPlaying)return;
			_isPlaying = false;
			if(tweeng)tweeng.stop();
//			if(isFlick)controlFlick(false);
		}
		
		override public function stopToDefault(_time:Number=undefined) : void
		{
			if(_isDestroyed!=1)return;
			_isPlaying = false;
			if(tweeng)tweeng.stop();
			
//			if(isFlick)controlFlick(false);
		}
		
		override public function togglePause() : void
		{
			if(_isDestroyed != 1 || !_isPlaying)return;
			if(tweeng)tweeng.togglePause();
			_isPlaying = tweeng.isPlaying;
//			if(isFlick)controlFlick(tweeng.isPlaying);
		}
		
		private function shuffleArray(arr:Array):Array
		{
			var l:int = arr.length;
			var newArr:Array = arr;
			while(l)
			{
				var m:int = Math.floor(Math.random()*l);
				var n:Object = newArr[--l];
				newArr[l] = newArr[m];
				newArr[m] = n;
			}
			return newArr;
		};

	}
}
