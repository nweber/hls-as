package net.digitalprimates.osmf.utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import net.digitalprimates.osmf.utils.events.PluginLoaderEvent;
	
	import org.osmf.events.MediaFactoryEvent;
	import org.osmf.media.MediaFactory;
	import org.osmf.media.PluginInfoResource;
	
	[Event(name="loadComplete", type="net.digitalprimates.osmf.utils.events.PluginLoaderEvent")]
	[Event(name="loadError", type="net.digitalprimates.osmf.utils.events.PluginLoaderEvent")]
	/**
	 * 
	 * 
	 * @author Nathan Weber
	 */
	public class PluginLoader extends EventDispatcher
	{
		//----------------------------------------
		//
		// Variables
		//
		//----------------------------------------
		
		private var pluginLoadCount:int;
		
		private var _factory:MediaFactory;
		private var _plugins:Vector.<PluginInfoResource>;
		
		//----------------------------------------
		//
		// Properties
		//
		//----------------------------------------
		
		public function get factory():MediaFactory {
			return _factory;
		}
		
		public function get plugins():Vector.<PluginInfoResource> {
			return _plugins;
		}
		
		//----------------------------------------
		//
		// Public Methods
		//
		//----------------------------------------
		
		public function load():Boolean {
			if (plugins && plugins.length > 0) {
				trace("PluginLoader :: load() :: Plugins to load = " + plugins.length);
				
				pluginLoadCount = 0;
				
				factory.addEventListener(MediaFactoryEvent.PLUGIN_LOAD, onPluginLoad);
				factory.addEventListener(MediaFactoryEvent.PLUGIN_LOAD_ERROR, onPluginError);
				
				for each (var pluginResource:PluginInfoResource in plugins) {
					factory.loadPlugin(pluginResource);
				}
				
				return true;
			}
			
			return false
		}
		
		//----------------------------------------
		//
		// Internal Methods
		//
		//----------------------------------------
		
		protected function pluginsLoaded():void {
			factory.removeEventListener(MediaFactoryEvent.PLUGIN_LOAD, onPluginLoad);
			trace("PluginLoader :: pluginsLoaded()");
			dispatchEvent(new PluginLoaderEvent(PluginLoaderEvent.LOAD_COMPLETE));
		}
		
		//----------------------------------------
		//
		// Handlers
		//
		//----------------------------------------
		
		private function onPluginLoad(event:MediaFactoryEvent):void {
			pluginLoadCount++;
			trace("PluginLoader :: onPluginLoad() :: Progress = " + pluginLoadCount + "/" + plugins.length);
			if (pluginLoadCount == plugins.length) {
				pluginsLoaded();
			}
		}
		
		private function onPluginError(event:MediaFactoryEvent):void {
			factory.removeEventListener(MediaFactoryEvent.PLUGIN_LOAD_ERROR, onPluginError);
			trace("PluginLoader :: onPluginError()");
			dispatchEvent(new PluginLoaderEvent(PluginLoaderEvent.LOAD_ERROR));
		}
		
		//----------------------------------------
		//
		// Constructor
		//
		//----------------------------------------
		
		public function PluginLoader(factory:MediaFactory, plugins:Vector.<PluginInfoResource>) {
			super();
			
			_factory = factory;
			_plugins = plugins;
		}
	}
}