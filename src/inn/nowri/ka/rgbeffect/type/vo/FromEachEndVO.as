package inn.nowri.ka.rgbeffect.type.vo
{
	import org.libspark.betweenas3.core.easing.IEasing;
	/**
	 * @author ka
	 */
	public class FromEachEndVO
	{
		private var _transition:IEasing;
		private var _time:Number;
		private var _direction:String;
		private var _max:Number;
		private var _blend:int;
		private var _isFlick:Boolean;
		private var _random:Number;
		private var _delay:Number;
		public function FromEachEndVO(	
			time:Number=1, 
			direction:String="HORIZONAL", 
			max:Number=32,
			delay:Number=0.5, 
			transition:IEasing=null, 
			blend:int=0, 
			isFlick:Boolean=false, 
			random:Number=0
		) 
		{
			_transition = transition;
			_time = time;
			_direction = direction;
			_max=max;
			_blend=blend;
			_isFlick = isFlick;
			_random = random;
			_delay=delay;
		}

		public function get transition():IEasing
		{
			return _transition;
		}

		public function set transition(transition:IEasing):void
		{
			_transition=transition;
		}

		public function get time():Number
		{
			return _time;
		}

		public function set time(time:Number):void
		{
			_time=time;
		}

		public function get direction():String
		{
			return _direction;
		}

		public function set direction(direction:String):void
		{
			_direction=direction;
		}

		public function get max():Number
		{
			return _max;
		}

		public function set max(max:Number):void
		{
			_max=max;
		}

		public function get blend():int
		{
			return _blend;
		}

		public function set blend(blend:int):void
		{
			_blend=blend;
		}

		public function get isFlick():Boolean
		{
			return _isFlick;
		}

		public function set isFlick(is_frick:Boolean):void
		{
			_isFlick=is_frick;
		}

		public function get random():Number
		{
			return _random;
		}

		public function set random(random:Number):void
		{
			_random=random;
		}

		public function get delay():Number
		{
			return _delay;
		}

		public function set delay(delay:Number):void
		{
			_delay=delay;
		}
	}
}
