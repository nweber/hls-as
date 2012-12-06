package net.digitalprimates.osmf.utils.events
{
	import flash.events.Event;
	
	/**
	 * 
	 * 
	 * @author Nathan Weber
	 */
	public class PluginLoaderEvent extends Event
	{
		//----------------------------------------
		//
		// Constants
		//
		//----------------------------------------
		
		public static const LOAD_COMPLETE:String = "loadComplete";
		public static const LOAD_ERROR:String = "loadError";
		
		//----------------------------------------
		//
		// Lifecycle
		//
		//----------------------------------------
		
		override public function clone():Event {
			return new PluginLoaderEvent(type, bubbles, cancelable);
		}
		
		//----------------------------------------
		//
		// Constructor
		//
		//----------------------------------------
		
		public function PluginLoaderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
	}
}