package inn.nowri.ka.rgbanime.core 
{
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import org.libspark.betweenas3.BetweenAS3;
	import org.libspark.betweenas3.tweens.ITween;

	/**
	 * RGBControlObject Class 
	 * 
	 */
	public class RGBControlObject extends RGBObject implements IControlAnime
	{
		public var flickTimer : Number;
		
		protected var rtween : ITween;
		protected var gtween : ITween;
		protected var btween : ITween;
		protected var tweeng : ITween;
		protected var _isDestroyed : uint = 1;
		
		// 引数 -------------------------------------------
		protected var time : Number = 1;
		protected var max : Number = 10;
		protected var delay : Number = 0.2;
		protected var isFlick : Boolean = true;
		protected var random : Number = 0.5;
		protected var blend : uint = 0;
		protected var direction : String;
		protected var count : uint = 1;
		// 引数 -------------------------------------------
		protected var _isPlaying:Boolean =false;
	//	protected var onComplete : Function;
	//	protected var onCompleteParams:Array;
		private var ftween : ITween;		
		private var targetFlickMc : DisplayObject;
		private var targetFlickScaleMc : DisplayObject;
		
		
		//private var isScale : Boolean;
		
		public function RGBControlObject(bmd : BitmapData, obj : Object)
		{
			super(bmd);
			time = (obj.time != undefined) ? obj.time : time;
			count = (obj.count != undefined)? obj.count : count;
			if(count == 0)
			{
				count = 4294967295;
			};
			max = (obj.max != undefined)? obj.max : max;
			delay = (obj.delay != undefined)? obj.delay : delay;
			direction = (obj.direction != undefined)? obj.direction.toUpperCase() : "";
			random = (obj.random != undefined)? obj.random : random;
			isFlick = (obj.isFlick != undefined)? obj.isFlick : isFlick;
			blend = (obj.blend != undefined)? obj.blend : blend;
			if(blend != 0)setBlendMode();
			
			
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
				if(ftween)
				{
					ftween.stop();
				}
				_r.visible=_g.visible=_b.visible=true;
			}
		}
		//		private function getFlickRandomValue() : Number 
		//		{	
		//			var val:Number = RGBConstants.FLICK_INTERVAL;
		//			var _val:Number;
		//			if(Math.random() <= RGBConstants.FLICK_RANDOM_VALUE)
		//			{
		//				_val = val + val * Math.random()*RGBConstants.FLICK_MAX_RANDOM_VALUE;
		//			}
		//			else
		//			{
		//				_val = val;
		//			};
		//			return _val;
		//		}

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
			ftween = BetweenAS3.tween(this, {flickTimer:1}, null, RGBConstants.FLICK_INTERVAL);
			if(_isPlaying)ftween.onComplete = completeFlick;
			ftween.play();
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
					//	targetFlickMc.scaleX = Math.random()+1
					if(getFlickRandomBool())targetFlickMc.visible = false;
				}
				else
				{
					targetFlickMc.visible = true;
				}
//				if(!isScale)
//				{
//					targetFlickScaleMc = getChildAt(int(Math.random() * 3));
//					if(getFlickRandomBool())scaleMe(targetFlickScaleMc,Math.random() + 1,Math.random() + 1);isScale=true;
//				}
//				else
//				{
//					scaleMe(targetFlickScaleMc, 1,1);
//					isScale =false;
//				};
				setFlick();
			};
		}

		private function setBlendMode() : void 
		{
			switch(blend)
			{
				case 0:
					_r.blendMode = _g.blendMode = _b.blendMode = BlendMode.MULTIPLY;
					getChildAt(0).blendMode=BlendMode.NORMAL;
				break;
				
				case 1: 
					_r.blendMode = _g.blendMode = _b.blendMode = BlendMode.MULTIPLY;
				break;
				
				case 2: 
					_r.blendMode = _g.blendMode = _b.blendMode = BlendMode.DIFFERENCE;
				break;
			}
			
		}

//		private function scaleMe(target : DisplayObject, sx : Number, sy : Number):void
//		{
//			var mat:Matrix = target.transform.matrix;
//			mat.translate(target.width/2, target.height/2);
//			mat.scale(sx, sy);
//		//	var mat_sx : Number = MatrixTransformer.getScaleX(mat);
//		//	var mat_sy : Number = MatrixTransformer.getScaleY(mat
//		//	MatrixTransformer.setScaleX(mat, sx);
//		//	MatrixTransformer.setScaleY(mat, sy);
//		//	target.transform.matrix = mat;
//		}
	}
}
