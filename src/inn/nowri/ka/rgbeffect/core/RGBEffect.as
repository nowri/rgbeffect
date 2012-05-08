package inn.nowri.ka.rgbanime.core 
{
	import inn.nowri.ka.rgbanime.ext.ImageUtil;
	import flash.display.BitmapData;
	public class RGBEffect 
	{
		static public function getRGB(bmd : BitmapData) : Vector.<BitmapData>
		{
			var w : Number = bmd.width;
			var h : Number = bmd.height;
			var bmdR : BitmapData = new BitmapData(w, h);
			var bmdG : BitmapData = bmdR.clone();
			var bmdB : BitmapData = bmdR.clone();
			var vct : Vector.<BitmapData> = new Vector.<BitmapData>(3, false);
			ImageUtil.copyChannel(bmd, bmdR, 1);
			ImageUtil.copyChannel(bmd, bmdG, 2);
			ImageUtil.copyChannel(bmd, bmdB, 4);
			ImageUtil.copyChannel(bmd, bmdR, 8);
			ImageUtil.copyChannel(bmd, bmdG, 8);
			ImageUtil.copyChannel(bmd, bmdB, 8);
			vct[0] = bmdR;
			vct[1] = bmdG;
			vct[2] = bmdB;
			return vct;
		}
	}
}