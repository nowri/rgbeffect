package inn.nowri.ka.rgbeffect.core 
{
	import flash.display.Sprite;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import org.libspark.betweenas3.BetweenAS3;
	import org.libspark.betweenas3.tweens.ITween;

	/**
	 * RGBControlObject Class 
	 */
	public class RGBControlObject extends RGBObject implements IControlAnime
	{
		public var flickTimer : Number;
		protected var rTween : ITween;
		protected var gTween : ITween;
		protected var bTween : ITween;
		protected var tweeng : ITween;
		protected var _isDestroyed : uint = 1;
		protected var rgb : Vector.<Sprite> = Vector.<Sprite>([
			new Sprite(),
			new Sprite(),
			new Sprite()
		]);
		
		// 引数 -------------------------------------------
		protected var blend : uint = 0;
		protected var isFlick : Boolean = true;
		// 引数 -------------------------------------------
		protected var _isPlaying:Boolean =false;
		private var _basePosition:Point;
		private var fTween : ITween;		
		private var targetFlickMc : DisplayObject;
		private var targetFlickScaleMc : DisplayObject;
		private var random : Number = 0.5;
		public function RGBControlObject(bmd : BitmapData, obj : Object)
		{
			super(bmd);
			_basePosition = getBasePosition();
			blend = (obj.blend != undefined)? obj.blend : blend;
			if(blend != 0)setBlendMode();
			isFlick = (obj.isFlick != undefined)? obj.isFlick : isFlick;
			random = (obj.random != undefined)? obj.random : random;
		}
		
		/**
		 * 最初から再生開始
		 */
		public function play() : void{}
		
		/**
		 * 停止
		 */
		public function stop() : void{}
		
		/**
		 * 一時停止、再生再開を繰り返す
		 */
		public function togglePause() : void
		{
			if(_isDestroyed!=1)return;
			
			tweeng.togglePause();
			
			if(isFlick)controlFlick(tweeng.isPlaying);
		}
		/**
		 * ビットマップデータを削除しメモリ解放
		 * @param bool:Boolean=true trueの場合は完全破壊、falseの場合は元のbitmapData1枚に差し替わり復旧可能。
		 */
		public function destroy(bool:Boolean = true) : void
		{
			if(_isDestroyed!=1)return;
			
			if(bool)
			{
				if(numChildren)
				{
					stop();
					removeChildFunc();
					_isDestroyed = 0;
				};
			}
			else
			{
				stopToDefault(0);
				removeRgbAndLeaveSourceImage();
				_isDestroyed = 2;
			}
		}
		
		/**
		 * destroy(false)から復旧する
		 */
		public function resumeFromDestroyFalse() : void
		{
			if(_isDestroyed!=2)return;
			resumeRgb();
			setBlendMode();
			_isDestroyed = 1;
		}
		
		/**
		 * ストップして初期状態に戻る 
		 *  @param _time:Number 初期状態に戻るアニメーション秒数、デフォルトはtime
		 */
		public function stopToDefault(_time : Number=undefined) : void{}
		
		// getter setter
		/**
		 * 再生状態かどうか
		 */
		public function get isPlaying() : Boolean
		{
			return _isPlaying;
		}
		public function set isPlaying(isPlaying : Boolean) : void
		{
			_isPlaying = isPlaying;
		}
		
		/**
		 * 0:完全破壊<br>
		 * 1:未破壊<br>
		 * 2:復旧可能破壊<br>
		 */
		public function get isDestroyed() : uint
		{
			return _isDestroyed;
		}
		
		final protected function getPoint(radius : uint, point : Point, angle : Number) : Point
		{
			var radian : Number = angle * Math.PI / 180;
			return new Point(radius * Math.cos(radian) + point.x, radius * Math.sin(radian) + point.y);
		}
		
		final protected function getRandomValue(val : Number) : Number
		{
			var _val : Number;
			if(Math.random() <= random)
			{
				_val = val + val * Math.random() * RGBConstants.MAX_RANDOM_VALUE;
			}
			else
			{
				_val = val;
			}
			return _val;
		}
		
		final protected function controlFlick(isPlay : Boolean) : void
		{
			if(isPlay)
			{
				setFlick();
			}
			else
			{
				if(fTween)
				{
					fTween.stop();
				}
				_r.visible=_g.visible=_b.visible=true;
			}
		}
		
		final protected function get basePosition() : Point
		{
			return _basePosition;
		}
		
		final override protected function addChildFunc() : void 
		{	
			var ar:Array = [_r,_g,_b];
			var len:uint = ar.length;
			for(var i:uint=0; i<len; i++)
			{
				var targetNum:int = int(Math.random()*(len - i));
				addChild(rgb[i]);
				rgb[i].addChild(ar[targetNum]);
				_basePosition = getBasePosition();
				ar[targetNum].x = _basePosition.x;
				ar[targetNum].y = _basePosition.y;
				_basePosition = new Point(-_basePosition.x, -_basePosition.y);
				rgb[i].x = _basePosition.x;
				rgb[i].y = _basePosition.y;
				ar.splice(targetNum,1);
			};
		}

		private function getFlickRandomBool() : Boolean 
		{	
			var bool : Boolean;
			if(Math.random() <= RGBConstants.FLICK_RANDOM_VALUE)
			{
				bool = true;
			}
			else
			{
				bool = false;
			}
			return bool;
		}

		private function setFlick() : void 
		{
			flickTimer = 0;
			fTween = BetweenAS3.tween(this, {flickTimer:1}, null, RGBConstants.FLICK_INTERVAL);
			if(_isPlaying)fTween.onComplete = completeFlick;
			fTween.play();
		}
		
		private function completeFlick():void
		{
			if(numChildren)
			{
				if(!targetFlickMc)
				{
					targetFlickMc = getChildAt(int(Math.random() * 3));
				}
				
				if(!targetFlickScaleMc)
				{
					targetFlickScaleMc = getChildAt(int(Math.random() * 3));
				}
				
				if(targetFlickMc.visible)
				{
					targetFlickMc = getChildAt(int(Math.random() * 3));
					if(getFlickRandomBool())targetFlickMc.visible = false;
				}
				else
				{
					targetFlickMc.visible = true;
				}

				setFlick();
			};
		}
		
		private function getBasePosition() : Point 
		{
			var bool:Boolean = RGBConstants.BASE_ALIGN=="";
			var xx:Number = (bool)? -_bmd.width/2 : 0;
			var yy:Number = (bool)? -_bmd.height/2 : 0;
			return new Point(xx, yy);
		}

		private function setBlendMode() : void 
		{
			switch(blend)
			{
				case 0:
					rgb[0].blendMode = rgb[1].blendMode = rgb[2].blendMode = BlendMode.MULTIPLY;
					getChildAt(0).blendMode=BlendMode.NORMAL;
				break;
				
				case 1: 
					rgb[0].blendMode = rgb[1].blendMode = rgb[2].blendMode = BlendMode.MULTIPLY;
				break;
				
				case 2: 
					rgb[0].blendMode = rgb[1].blendMode = rgb[2].blendMode = BlendMode.DIFFERENCE;
				break;
			}
		}
	}
}
