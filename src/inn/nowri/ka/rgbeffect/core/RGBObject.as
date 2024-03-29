﻿package inn.nowri.ka.rgbeffect.core 
{
	import flash.display.PixelSnapping;
	import flash.display.BlendMode;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	
	/**
	 * RGBObject Class 
	 * 
	 */
	public class RGBObject extends Sprite
	{
		
		
		protected var _r : Bitmap;
		protected var _g : Bitmap;
		protected var _b : Bitmap;
		protected var _bmd : BitmapData;
		
		
		public function RGBObject(bmd : BitmapData)
		{
			_bmd = bmd;
			
			var vct:Vector.<BitmapData> = RGBEffect.getRGB(_bmd);
			_r = new Bitmap(vct[0]);
			_g = new Bitmap(vct[1]);
			_b = new Bitmap(vct[2]);
			_r.smoothing=true;
			_g.smoothing=true;
			_b.smoothing=true;
			_r.pixelSnapping=PixelSnapping.NEVER;
			_g.pixelSnapping=PixelSnapping.NEVER;
			_b.pixelSnapping=PixelSnapping.NEVER;
			vct[0] = null;
			vct[1] = null;
			vct[2] = null;
			vct = null;
			addChildFunc();
			getChildAt(1).blendMode = getChildAt(2).blendMode = BlendMode.MULTIPLY;
			
		}
		
		protected function addChildFunc() : void 
		{	
			var ar:Array = [_r,_g,_b];
			var len:uint = ar.length;
			for(var i:uint=0; i<len; i++)
			{
				var targetNum:int = int(Math.random()*(len - i));
				addChild(ar[targetNum]);
				ar.splice(targetNum,1);
			};
			ar[0] = ar[1] = ar[2] = null;
			ar=null;
		}
		
		final protected function removeChildFunc() : void 
		{	
				removeChild(_r);
				removeChild(_g);
				removeChild(_b);
				_r.bitmapData.dispose();
				_g.bitmapData.dispose();
				_b.bitmapData.dispose();
				_bmd.dispose();
				_r = null;
				_g=null;
				_b=null;
				_bmd=null;
		}
		
		final protected function removeRgbAndLeaveSourceImage() : void 
		{
			_r.bitmapData.dispose();
			_g.bitmapData.dispose();
			_b.bitmapData.dispose();
			_r.bitmapData = _bmd;
			_r.blendMode = _g.blendMode = _b.blendMode = BlendMode.NORMAL;
		}
		
		final protected function resumeRgb() : void 
		{
			 _bmd = _r.bitmapData;
			var vct:Vector.<BitmapData> = RGBEffect.getRGB(_bmd);
			_r.bitmapData = vct[0];
			_g.bitmapData = vct[1];
			_b.bitmapData = vct[2];
			vct[0] = null;
			vct[1] = null;
			vct[2] = null;
			vct = null;
		}
		

		// getter
		public function get r() : Bitmap
		{
			return _r;
		}
		
		public function get g() : Bitmap
		{
			return _g;
		}
		
		public function get b() : Bitmap
		{
			return _b;
		}
	}
}
