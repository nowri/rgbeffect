package inn.nowri.ka.rgbeffect.type 
{
	import inn.nowri.ka.rgbeffect.core.IControlAnime;
	import inn.nowri.ka.rgbeffect.core.RGBCommandConstants;
	import inn.nowri.ka.rgbeffect.core.RGBConstants;
	import inn.nowri.ka.rgbeffect.core.RGBControlObject;

	import org.libspark.betweenas3.BetweenAS3;
	import org.libspark.betweenas3.easing.Sine;
	import org.libspark.betweenas3.tweens.ITween;
	import org.libspark.betweenas3.tweens.ITweenGroup;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class Yoyo extends RGBControlObject implements IControlAnime
	{	
		private var betweenAS3ObjVct : Vector.<Object>;
		private var tweengAr : Vector.<ITween>;
		private var innerCountForPlayChaos : uint;
	
		public function Yoyo(bmd : BitmapData, obj:Object)
		{
			super(bmd, obj);
			count = (count != 4294967295)? obj.count : count;
			direction =(direction=="")? RGBCommandConstants.ALL : direction;
			tweengAr = new Vector.<ITween>(3,false);
			
		}
		
		override public function play() : void
		{
			if(_isDestroyed!=1)return;
			_isPlaying = true;
			
			switch(direction)
			{
				case RGBCommandConstants.UP_DOWN:
					if(_isPlaying)playLinear();
				break;
				
				case RGBCommandConstants.RIGHT_LEFT:
					if(_isPlaying)playLinear();
				break;
				
				case RGBCommandConstants.ALL:
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
			
			if(direction==RGBCommandConstants.ALL || time>=__time)
			{
				if(tweengAr[0])tweengAr[0].stop();
				if(tweengAr[1])tweengAr[1].stop();
				if(tweengAr[2])tweengAr[2].stop();
				tweengAr[0] = BetweenAS3.tween( _r, {x:basePosition.x, y:basePosition.y}, null, __time);
				tweengAr[1] = BetweenAS3.tween( _g, {x:basePosition.x, y:basePosition.y}, null, __time);
				tweengAr[2] = BetweenAS3.tween( _b, {x:basePosition.x, y:basePosition.y}, null, __time);
				
				ITween(tweengAr[2]).onComplete = function():void
				{				
					dispatchEvent(new Event(RGBCommandConstants.PLAY_COMPLETE));
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
					if(maxX<_r.x)maxX=_r.x;
					if(maxY<_r.y)maxY=_r.y;
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
					stopToDefaultPartTremolo(_r, tweengAr[0], _count, _count, _max, xy);
				};
				
				ITween(tweengAr[1]).onComplete = function():void
				{				
					stopToDefaultPartTremolo(_g, tweengAr[1], _count, _count, _max, xy);
				};
				
				ITween(tweengAr[2]).onComplete = function():void
				{				
					stopToDefaultPartTremolo(_b, tweengAr[2], _count, _count, _max, xy);
					if(isFlick)controlFlick(false);
					dispatchEvent(new Event(RGBCommandConstants.PLAY_COMPLETE));
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
		
		private function stopToDefaultPartTremolo(bmp:Bitmap, tween : ITween, __count : uint, _countMax:uint, _max : Number, xy : String) : void 
		{
			var obj1:Object = {};
			obj1[xy] = -_max/2+basePosition[xy];
			
			var obj2:Object = {};
			obj2[xy] = _max/2+basePosition[xy];
			
			tween = BetweenAS3.serial
			(
				BetweenAS3.tween(bmp, obj1, null, time, Sine.easeInOut),
				BetweenAS3.tween(bmp, obj2, null, time, Sine.easeInOut)
			);
			
			if(__count != 0 && !_isPlaying)tween.onComplete = function():void
			{
				var _count:uint = __count-1;
				_max = _max * _count/_countMax;
				stopToDefaultPartTremolo(bmp, tween, _count, _countMax, _max, xy);
			};
			tween.play();
		}

		private function renderTweenGroup():Vector.<ITween>
		{
			betweenAS3ObjVct = getTweenParamVct();
			var rtweeng:ITweenGroup = renderPart(_r);
			var gtweeng:ITweenGroup = renderPart(_g);
			var btweeng:ITweenGroup = renderPart(_b);
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
				case RGBCommandConstants.UP_DOWN:
					obj1={y:basePosition.y};
					obj2={y:basePosition.y+getRandomValue(max)};
				break;
				
				case RGBCommandConstants.RIGHT_LEFT:
					obj1={x:basePosition.x};
					obj2={x:basePosition.x+getRandomValue(max)};
				break;
				
				case RGBCommandConstants.ALL:
					var pt:Point = getPoint(getRandomValue(max), new Point(basePosition.x, basePosition.y), int(Math.random()*360));
					obj1={x:basePosition.x,y:basePosition.y};
					obj2={x:pt.x,y:pt.y};
				break;
			}
			vct[0] = obj1;
			vct[1] = obj2;
			return vct;
		}
		
		private function renderPart(bmp:Bitmap) : ITweenGroup 
		{
			var tween:ITween;
			if(bmp === _r )
			{
				tween = rtween;
			}
			else if(bmp === _g)
			{
				tween = gtween;
			}
			else if(bmp === _b)
			{
				tween = btween;
			};
			tween = BetweenAS3.tween(bmp, betweenAS3ObjVct[1], betweenAS3ObjVct[0], time, Sine.easeInOut);
			var tween2:ITween = BetweenAS3.tween(bmp, betweenAS3ObjVct[0], betweenAS3ObjVct[1], time, Sine.easeInOut);
			var tweeng:ITweenGroup = BetweenAS3.serial(tween,tween2);
			return tweeng;
		}

		private function playChaos() : void 
		{
			if(innerCountForPlayChaos!=0)
			{
				if(Math.random()<RGBConstants.ALL_SHOW_THRESHOLD)
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
