package net.digitalprimates.osmf.utils
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import org.osmf.containers.MediaContainer;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaPlayer;

	/**
	 *
	 *
	 * @author Nathan Weber
	 */
	public class PlayerController extends EventDispatcher
	{
		//----------------------------------------
		//
		// Constants
		//
		//----------------------------------------



		//----------------------------------------
		//
		// Variables
		//
		//----------------------------------------

		private var _element:MediaElement;
		private var _player:MediaPlayer;
		private var _container:MediaContainer;

		//----------------------------------------
		//
		// Properties
		//
		//----------------------------------------



		//----------------------------------------
		//
		// Public Methods
		//
		//----------------------------------------

		public function get container():MediaContainer
		{
			return _container;
		}

		public function set container(value:MediaContainer):void
		{
			_container = value;
		}

		public function get player():MediaPlayer
		{
			return _player;
		}

		public function set player(value:MediaPlayer):void
		{
			_player = value;
		}

		public function get element():MediaElement
		{
			return _element;
		}

		public function set element(value:MediaElement):void
		{
			_element = value;
		}

		public function registerSkinPart(type:String, instance:EventDispatcher):void {
			
		}
		
		public function unregisterSkinPart(type:String, instance:EventDispatcher):void {
			
		}

		//----------------------------------------
		//
		// Internal Methods
		//
		//----------------------------------------



		//----------------------------------------
		//
		// Handlers
		//
		//----------------------------------------



		//----------------------------------------
		//
		// Lifecycle
		//
		//----------------------------------------



		//----------------------------------------
		//
		// Constructor
		//
		//----------------------------------------

		public function PlayerController() {
			super();
		}
	}
}
