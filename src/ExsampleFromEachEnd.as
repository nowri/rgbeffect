package
{
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import inn.nowri.ka.bmp.DrawAuto;
	import inn.nowri.ka.rgbeffect.RGBAnime;
	import inn.nowri.ka.rgbeffect.core.RGBControlObject;
	import inn.nowri.ka.rgbeffect.type.vo.FromEachEndVO;

	import uk.co.soulwire.gui.SimpleGUI;

	import org.libspark.betweenas3.BetweenAS3;
	import org.libspark.betweenas3.core.easing.IEasing;
	import org.libspark.betweenas3.tweens.ITween;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * @author ka
	 */
	public class ExsampleFromEachEnd extends Sprite
	{
		public static const HORIZONAL:String = "HORIZONAL";
		public static const VERTICAL:String = "VERTICAL";

		public var time:Number;
		public var max:Number;
		public var delay:Number;
		public var direction:String;
		public var transition1:String;
		public var transition2:IEasing;
		
		private var isAnime:Boolean;
		private var container:Sprite=new Sprite();
		
		public function ExsampleFromEachEnd()
		{
			addEventListener(Event.ADDED_TO_STAGE, start);
		}

		private function start(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, start);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			reset();
			addChild(container);
	
			var gui:SimpleGUI = new SimpleGUI(this);
			gui.addButton("run anime", {callback:anime});
//			gui.addButton("reset", {callback:reset});
//			gui.addStepper("time", 0, 5);
//			gui.addStepper("max", 1, 100);
//			gui.addStepper("delay", 0, 4);
//			gui.addComboBox("transition1", [
//				{label:"linear",	data:"linear"},
//				{label:"easeIn",	data:"easeIn"},
//				{label:"easeOut",	data:"easeOut"},
//				{label:"easeInOut",	data:"easeInOut"},
//				{label:"easeOutIn",	data:"easeOutIn"}
//			]);
//			gui.addComboBox("transition2", [
//				{label:"Sine",		data:Sine},
//				{label:"Quint",		data:Quint},
//				{label:"Expo",		data:Expo},
//				{label:"Circ",		data:Circ},
//				{label:"Linear",	data:Linear},
//				{label:"Elastic",	data:Elastic},
//				{label:"Bounce",	data:Bounce}
//			]);

//			gui.addComboBox("direction", [
//				{label:"horizonal",	data:"x"},
//				{label:"vertical",	data:"y"},
//			]);
			gui.show();
		}
		
		private function anime():void
		{
			reset();
//			if(isAnime)return;
			isAnime = true;

			var ar:Array=[];
			var removeList:Array=[];
			for(var i:int=0; i<container.numChildren; i++) 
			{
				var dio:DisplayObject = container.getChildAt(i);
				var func:Function = function(dio:DisplayObject):void
				{
					(addChildPos
					(
						RGBAnime.fromEachEnd(DrawAuto.drawBmd(dio), new FromEachEndVO()),
						dio.x,
						dio.y
					) as RGBControlObject).play();
				};
				
				var be:ITween = BetweenAS3.delay
				(
					BetweenAS3.func(func, [dio]),
					i/4
				);
				ar.push(be);
				removeList.push(dio);
			}
			while(removeList.length)
			{
				container.removeChild(removeList.shift());
			}

			BetweenAS3.serialTweens(ar).play();
		}
		
		private function reset():void
		{
			while(container.numChildren)container.removeChild(container.getChildAt(0));
			
			createTF("あのイーハトーヴォのすきとおった風、", 150, 120);
			createTF("夏でも底に冷たさをもつ青いそら、", 150, 150);
			createTF("うつくしい森で飾られたモリーオ市、", 150, 180);
			createTF("郊外のぎらぎらひかる草の波。", 150, 210);
			addChildPos(new Bitmap(new Img(0,0)), 0, stage.stageHeight/2);
		}
		
		//util
		private function createTF(str:String, _x:Number, _y:Number):Sprite 
		{
			var txt:TextField = new TextField();
			txt.autoSize = TextFieldAutoSize.LEFT;
			var tf:TextFormat = txt.defaultTextFormat;
			tf.size=18;
			tf.color = 0xffffff;
			txt.defaultTextFormat = tf;
			txt.text = str;			
			
			var spr:Sprite = new Sprite();
			spr.x = _x;
			spr.y = _y;
			container.addChild(spr);
			spr.addChild(txt);
			return spr;
		}
		
		private function addChildPos(child:DisplayObject, _x:Number, _y:Number):DisplayObject 
		{
			child.x = _x;
			child.y = _y;
			return container.addChild(child);
		}
	}
}
