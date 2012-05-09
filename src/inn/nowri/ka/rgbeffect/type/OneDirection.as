package inn.nowri.ka.rgbeffect.type 
{
	import inn.nowri.ka.rgbeffect.core.IControlAnime;
	import inn.nowri.ka.rgbeffect.core.RGBCommandConstants;
	import inn.nowri.ka.rgbeffect.core.RGBControlObject;

	import org.libspark.betweenas3.BetweenAS3;
	import org.libspark.betweenas3.easing.Sine;
	import org.libspark.betweenas3.tweens.ITween;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	
	public class OneDirection extends RGBControlObject implements IControlAnime
	{	
		/**
		 * 方向
		 */
		public static const LEFT:String = "LEFT";
		/**
		 * 方向
		 */
		public static const RIGHT:String = "RIGHT";
		/**
		 * 方向
		 */
		public static const UP:String = "UP";
		/**
		 * 方向
		 */
		public static const DOWN:String = "DOWN";
		
		/**
		 * Fillinの動く量がパラメータmaxに対してどれくらいの割合か
		 */
		public static const FILLIN_MOVE_VALUE:Number = 0.3;
		
		/**
		 * Fillinの振幅時間がパラメータmaxに対してどれくらいの割合か
		 */
		public static const FILLIN_MOVE_TIME:Number = 0.5;

		private var _isFillin:Boolean;
		private var delay : Number = 0.2;
		private var time : Number = 1;
		private var count : uint = 1;
		
		private var direction : String;
		private var max : Number = 10;
		
		public function OneDirection(bmd:BitmapData, obj:Object, isFillin:Boolean)
		{
			super(bmd, obj);
			count = (obj.count != undefined) ? obj.count : count;
			time=(obj.time)? 	obj.time:time;
			delay=(obj.delay)?	obj.delay:delay;
			direction = (obj.direction != undefined)? obj.direction.toUpperCase() : LEFT;
			max = (obj.max != undefined)? obj.max : max;
		}
		
		override public function play() : void
		{
			if(_isDestroyed!=1)return;
			_isPlaying = true;
			var obj1:Object = getTweenParamVct()[0];
			var obj2:Object = getTweenParamVct()[1];
			rtween = (!_isFillin)? BetweenAS3.tween(_r, obj2, obj1, time, Sine.easeOut) : renderAddedFillInPart(_r,obj1,obj2);
			gtween = (!_isFillin)? BetweenAS3.tween(_g, obj2, obj1, time, Sine.easeOut) : renderAddedFillInPart(_g,obj1,obj2);
			btween = (!_isFillin)? BetweenAS3.tween(_b, obj2, obj1, time, Sine.easeOut) : renderAddedFillInPart(_b,obj1,obj2);
			gtween = BetweenAS3.delay(gtween, delay);
			btween = BetweenAS3.delay(btween, delay*2);
			tweeng = BetweenAS3.repeat( BetweenAS3.parallel(rtween, gtween, btween), count);
			var self:Object = this;
			tweeng.onComplete = function():void
			{
				_isPlaying = false;
				if(isFlick)controlFlick(false);
				dispatchEvent(new Event(RGBCommandConstants.PLAY_COMPLETE));
			};
			tweeng.play();
			if(isFlick)controlFlick(true);
		}
		
		override public function stop() : void
		{
			if(_isDestroyed!=1 || !_isPlaying)return;
			
			_isPlaying = false;
			if(tweeng)tweeng.stop();
			if(isFlick)controlFlick(false);
		}
		
		override public function stopToDefault(_time:Number=undefined) : void
		{
			if(_isDestroyed!=1)return;
			
			_isPlaying = false;
			if(tweeng)tweeng.stop();
			var __time:Number =(_time)? _time:time;
			rtween = BetweenAS3.tween(_r, {x:basePosition.x, y:basePosition.y}, null, __time);
			gtween = BetweenAS3.delay(BetweenAS3.tween(_g, {x:basePosition.x,y:basePosition.y}, null, __time), delay);
			btween = BetweenAS3.delay(BetweenAS3.tween(_b, {x:basePosition.x,y:basePosition.y}, null, __time), delay*2);
			tweeng  = BetweenAS3.parallel
			(
				rtween,
				gtween,
				btween
			);
			tweeng.play();
			if(isFlick)controlFlick(false);
		}
		
		override public function togglePause() : void
		{
			if(_isDestroyed != 1 || !_isPlaying)return;
				
			if(tweeng)tweeng.togglePause();
			_isPlaying = tweeng.isPlaying;
			if(isFlick)controlFlick(tweeng.isPlaying);
		}
		
		
		
		private function renderAddedFillInPart(bmp:Bitmap, obj1:Object, obj2:Object) : ITween
		{
			var obj3:Object;
			var obj4:Object;
			switch(direction)
			{
				case LEFT:
					obj3={x:basePosition.x};
					obj4={x:basePosition.x-getRandomValue(max)*FILLIN_MOVE_VALUE};
					break;
				
				case RIGHT:
					obj3={x:basePosition.x};
					obj4={x:basePosition.x+getRandomValue(max)*FILLIN_MOVE_VALUE};
				break;
				
				case UP:
					obj3={y:basePosition.y};
					obj4={y:basePosition.y-getRandomValue(max)*FILLIN_MOVE_VALUE};
				break;
				
				case DOWN:
					obj3={y:basePosition.y};
					obj4={y:basePosition.y+getRandomValue(max)*FILLIN_MOVE_VALUE};
				break;
			};
			
			var _time:Number = time*FILLIN_MOVE_TIME;
			return BetweenAS3.serial(
				BetweenAS3.tween(bmp, obj4, obj3, _time, Sine.easeInOut),
				BetweenAS3.tween(bmp, obj3, obj4, _time, Sine.easeInOut),
				BetweenAS3.tween(bmp, obj2, obj1, _time, Sine.easeInOut)
			);
		}
		
		private function getTweenParamVct():Vector.<Object>
		{
			var vct:Vector.<Object> = new Vector.<Object>(2,false);
			var obj1:Object;
			var obj2:Object;
			switch(direction)
			{
				case LEFT:
					obj1={x:basePosition.x};
					obj2={x:basePosition.x-getRandomValue(max)};
				break;
				
				case RIGHT:
					obj1={x:basePosition.x};
					obj2={x:basePosition.x+getRandomValue(max)};
				break;
				
				case UP:
					obj1={y:basePosition.y};
					obj2={y:basePosition.y-getRandomValue(max)};
				break;
				
				case DOWN:
					obj1={y:basePosition.y};
					obj2={y:basePosition.y+getRandomValue(max)};
				break;
			}
			vct[0] = obj1;
			vct[1] = obj2;
			return vct;
		}
	}
}
