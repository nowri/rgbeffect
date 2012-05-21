package inn.nowri.ka.rgbeffect.type 
{
	import flash.display.Sprite;
	import inn.nowri.ka.rgbeffect.core.RGBEvent;
	import inn.nowri.ka.rgbeffect.core.IControlAnime;
	import inn.nowri.ka.rgbeffect.core.RGBControlObject;

	import org.libspark.betweenas3.BetweenAS3;
	import org.libspark.betweenas3.easing.Sine;
	import org.libspark.betweenas3.tweens.ITween;
	import org.libspark.betweenas3.tweens.ITweenGroup;

	import flash.display.BitmapData;
	import flash.geom.Point;
	
	public class Yoyo extends RGBControlObject implements IControlAnime
	{	
		/**
		 * 方向
		 */
		public static const UP_DOWN:String = "UP_DOWN";
		/**
		 * 方向
		 */
		public static const RIGHT_LEFT:String = "RIGHT_LEFT";
		/**
		 * 方向
		 */
		public static const ALL:String = "ALL";
		
		
		/**
		 * 方向 ALLの場合の実行されるしきい値
		 */
		public static const ALL_SHOW_THRESHOLD:Number = 0.7;
		
		private var betweenAS3ObjVct : Vector.<Object>;
		private var tweengAr : Vector.<ITween>;
		private var innerCountForPlayChaos : uint;
		private var time : Number = 0.1;
		private var max : Number = 1;
		private var delay : Number = 0.2;
		private var direction : String;
		private var count : uint = 0;
		
	
		public function Yoyo(bmd : BitmapData, obj:Object)
		{
			super(bmd, obj);
			time = (obj.time != undefined) ? obj.time : time;
			count = (obj.count != undefined)? obj.count : count;
			if(count == 0)
			{
				count = 4294967295;
			};
			max = (obj.max != undefined)? obj.max : max;
			delay = (obj.delay != undefined)? obj.delay : delay;
			direction = (obj.direction != undefined)? obj.direction.toUpperCase() : ALL;
			count = (count != 4294967295)? obj.count : count;
			direction =(direction=="")? ALL : direction;
			tweengAr = new Vector.<ITween>(3,false);
			
		}
		
		override public function play() : void
		{
			if(_isDestroyed!=1)return;
			_isPlaying = true;
			
			switch(direction)
			{
				case UP_DOWN:
					if(_isPlaying)playLinear();
				break;
				
				case RIGHT_LEFT:
					if(_isPlaying)playLinear();
				break;
				
				case ALL:
					innerCountForPlayChaos = count;
					if(_isPlaying)playChaos();
				break;
			};
			if(isFlick)controlFlick(true);
		}
		
		override public function togglePause() : void
		{
			if(_isDestroyed!=1 || !_isPlaying)return;
			
			tweengAr[0].togglePause();
			tweengAr[1].togglePause();
			tweengAr[2].togglePause();
			
			if(tweeng)tweeng.togglePause();
			
			_isPlaying = tweengAr[2].isPlaying;
			
			if(isFlick)
			{	
				if(tweeng)
				{
					controlFlick(tweeng.isPlaying);
				}
				else
				{
					controlFlick(tweengAr[2].isPlaying);
				}
			};
		}

		override public function stopToDefault(_time:Number=undefined) : void
		{
			if(_isDestroyed!=1)return;
			_isPlaying = false;
			
			var __time:Number =(_time)? _time:time;
			
			if(direction==ALL || time>=__time)
			{
				if(tweengAr[0])tweengAr[0].stop();
				if(tweengAr[1])tweengAr[1].stop();
				if(tweengAr[2])tweengAr[2].stop();
				tweengAr[0] = BetweenAS3.tween( rgb[0], {x:0, y:0}, null, __time);
				tweengAr[1] = BetweenAS3.tween( rgb[1], {x:0, y:0}, null, __time);
				tweengAr[2] = BetweenAS3.tween( rgb[2], {x:0, y:0}, null, __time);
				
				ITween(tweengAr[2]).onComplete = function():void
				{				
					dispatchEvent(new RGBEvent(RGBEvent.PLAY_COMPLETE));
				};
				
				tweengAr[0].play();
				tweengAr[1].play();
				tweengAr[2].play();
				if(tweeng)tweeng.stop();
				if(isFlick)controlFlick(false);
			}
			else
			{
				if(tweengAr[0])tweengAr[0].stop();
				if(tweengAr[1])tweengAr[1].stop();
				if(tweengAr[2])tweengAr[2].stop();
				var _count:uint = Math.ceil(__time/time);
				tweengAr= renderTweenGroup();
				
				var maxX:Number=basePosition.x;
				var maxY:Number=basePosition.y;
				var _max:Number;
				var xy:String;
				ITween(tweengAr[0]).onUpdate = function():void
				{
					if(maxX<rgb[0].x)maxX=rgb[0].x;
					if(maxY<rgb[0].y)maxY=rgb[0].y;
				};
				
				ITween(tweengAr[0]).onComplete = function():void
				{
					
					if(maxX==basePosition.x)
					{
						xy ="y";
						_max = maxY-basePosition.y;
					}
					else
					{
						xy="x";
						_max = maxX-basePosition.x;
					}			
					stopToDefaultPartTremolo(rgb[0], tweengAr[0], _count, _count, _max, xy);
				};
				
				ITween(tweengAr[1]).onComplete = function():void
				{				
					stopToDefaultPartTremolo(rgb[1], tweengAr[1], _count, _count, _max, xy);
				};
				
				ITween(tweengAr[2]).onComplete = function():void
				{				
					stopToDefaultPartTremolo(rgb[2], tweengAr[2], _count, _count, _max, xy);
					if(isFlick)controlFlick(false);
					dispatchEvent(new RGBEvent(RGBEvent.PLAY_COMPLETE));
				};
				tweengAr[1] = BetweenAS3.delay(tweengAr[1],delay*2);
				tweengAr[2] = BetweenAS3.delay(tweengAr[2],delay*4);
				tweengAr[0].play();
				tweengAr[1].play();
				tweengAr[2].play();
			}
		}

		
		override public function stop() : void
		{
			if(_isDestroyed!=1 || !_isPlaying)return;
			
			_isPlaying = false;
			if(tweengAr[0])tweengAr[0].stop();
			if(tweengAr[1])tweengAr[1].stop();
			if(tweengAr[2])tweengAr[2].stop();
			if(tweeng)tweeng.stop();
			if(isFlick)controlFlick(false);
		}
		
		private function stopToDefaultPartTremolo(spr:Sprite, tween : ITween, __count : uint, _countMax:uint, _max : Number, xy : String) : void 
		{
			var obj1:Object = {};
			obj1[xy] = -_max/2+basePosition[xy];
			
			var obj2:Object = {};
			obj2[xy] = _max/2+basePosition[xy];
			
			tween = BetweenAS3.serial
			(
				BetweenAS3.tween(spr, obj1, null, time, Sine.easeInOut),
				BetweenAS3.tween(spr, obj2, null, time, Sine.easeInOut)
			);
			
			if(__count != 0 && !_isPlaying)tween.onComplete = function():void
			{
				var _count:uint = __count-1;
				_max = _max * _count/_countMax;
				stopToDefaultPartTremolo(spr, tween, _count, _countMax, _max, xy);
			};
			tween.play();
		}

		private function renderTweenGroup():Vector.<ITween>
		{
			betweenAS3ObjVct = getTweenParamVct();
			var rtweeng:ITweenGroup = renderPart(rgb[0]);
			var gtweeng:ITweenGroup = renderPart(rgb[1]);
			var btweeng:ITweenGroup = renderPart(rgb[2]);
			var tweeng:Vector.<ITween> = new Vector.<ITween>(3,false);
			tweeng[0] = rtweeng;
			tweeng[1] = gtweeng;
			tweeng[2] = btweeng;
			return tweeng;
		}

		private function getTweenParamVct():Vector.<Object>
		{
			var vct:Vector.<Object> = new Vector.<Object>(2,false);
			var obj1:Object;
			var obj2:Object;
			switch(direction)
			{
				case UP_DOWN:
					obj1={y:-basePosition.y};
					obj2={y:-basePosition.y+getRandomValue(max)};
				break;
				
				case RIGHT_LEFT:
					obj1={x:-basePosition.x};
					obj2={x:-basePosition.x+getRandomValue(max)};
				break;
				
				case ALL:
					var pt:Point = getPoint
					(
						getRandomValue(max), 
						new Point(-basePosition.x, -basePosition.y), 
						int(Math.random()*360)
					);
					obj1={x:-basePosition.x,y:-basePosition.y};
					obj2={x:pt.x,y:pt.y};
				break;
			}
			vct[0] = obj1;
			vct[1] = obj2;
			return vct;
		}
		
		private function renderPart(spr:Sprite) : ITweenGroup 
		{
			var tween:ITween;
			if(spr === rgb[0] )
			{
				tween = rTween;
			}
			else if(spr === rgb[1])
			{
				tween = gTween;
			}
			else if(spr === rgb[2])
			{
				tween = bTween;
			};
			tween = BetweenAS3.tween(spr, betweenAS3ObjVct[1], betweenAS3ObjVct[0], time, Sine.easeInOut);
			var tween2:ITween = BetweenAS3.tween(spr, betweenAS3ObjVct[0], betweenAS3ObjVct[1], time, Sine.easeInOut);
			var tweeng:ITweenGroup = BetweenAS3.serial(tween,tween2);
			return tweeng;
		}

		private function playChaos() : void 
		{
			if(innerCountForPlayChaos!=0)
			{
				if(Math.random()<ALL_SHOW_THRESHOLD)
				{
					innerCountForPlayChaos--;
					if(tweengAr[2])tweengAr[2].stop();
					if(tweeng)tweeng.stop();
					tweengAr = renderTweenGroup();
					tweengAr[1] = BetweenAS3.delay( tweengAr[1], delay);
					tweengAr[2] = BetweenAS3.delay( tweengAr[2], delay*2);
					tweeng = BetweenAS3.parallel
					(
						tweengAr[0] ,
						tweengAr[1] ,
						tweengAr[2] 
					);
					if(numChildren)tweeng.onComplete = playChaos;
					tweeng.play();
				}
				else if(numChildren)
				{
					tweeng = BetweenAS3.parallel(BetweenAS3.delay(BetweenAS3.func(playChaos), delay*2+time));
					tweeng.play();
				};
			}
			else if(numChildren)
			{
				stopToDefault();
			}
		}

		private function playLinear() : void 
		{
			tweengAr= renderTweenGroup();
			tweengAr[0] = BetweenAS3.repeat(tweengAr[0], count);
			tweengAr[0].play();
			tweengAr[1] = BetweenAS3.delay( BetweenAS3.repeat(tweengAr[1], count), delay);
			tweengAr[1].play();
			tweengAr[2] = BetweenAS3.delay( BetweenAS3.repeat(tweengAr[2], count), delay*2);
			tweengAr[2].play();
			ITween(tweengAr[2]).onComplete = function():void
			{
				stopToDefault();
			};
		}
	}
}
