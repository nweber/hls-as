package net.digitalprimates.osmf.plugins.hls
{
	import at.matthew.httpstreaming.*;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.utils.StringUtil;
	
	import org.osmf.elements.VideoElement;
	import org.osmf.elements.proxyClasses.LoadFromDocumentLoadTrait;
	import org.osmf.events.MediaError;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.URLResource;
	import org.osmf.net.DynamicStreamingItem;
	import org.osmf.net.DynamicStreamingResource;
	import org.osmf.net.StreamType;
	import org.osmf.net.StreamingURLResource;
	import org.osmf.net.httpstreaming.dvr.DVRInfo;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.LoaderBase;
	import org.osmf.utils.URL;

	/**
	 *
	 *
	 * @author Nathan Weber
	 */
	public class M3U8Loader extends LoaderBase
	{
		//----------------------------------------
		//
		// Variables
		//
		//----------------------------------------

		private var loadTrait:LoadTrait;

		private var manifestLoader:URLLoader;

		//----------------------------------------
		//
		// Public Methods
		//
		//----------------------------------------

		override public function canHandleResource(resource:MediaResourceBase):Boolean {
			// nweber
			if (resource is URLResource) {
				var url:URL = new URL((resource as URLResource).url);
				if (url.extension == "m3u8") {
					return true;
				}
			}
			return false;
		}

		//----------------------------------------
		//
		// Internal Methods
		//
		//----------------------------------------

		protected function error(message:String):void {
			updateLoadTrait(loadTrait, LoadState.LOAD_ERROR);
			loadTrait.dispatchEvent(new MediaErrorEvent(MediaErrorEvent.MEDIA_ERROR, false, false, new MediaError(0, message)));
		}

		override protected function executeLoad(loadTrait:LoadTrait):void {
			this.loadTrait = loadTrait;

			updateLoadTrait(loadTrait, LoadState.LOADING);

			manifestLoader = new URLLoader(new URLRequest(URLResource(loadTrait.resource).url));
			manifestLoader.addEventListener(Event.COMPLETE, onComplete);
			manifestLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			manifestLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
		}

		protected function finishLoad(resource:MediaResourceBase):void {
			var loader:HTTPStreamingM3U8NetLoader = new HTTPStreamingM3U8NetLoader();
			var loadedElem:MediaElement = new VideoElement(resource, loader);

			LoadFromDocumentLoadTrait(loadTrait).mediaElement = loadedElem;
			updateLoadTrait(loadTrait, LoadState.READY);
		}

		protected function buildStreamingResource(data:String):MediaResourceBase {
			var url:String = (loadTrait.resource as URLResource).url;
			var baseURL:String = url.substring(0, url.lastIndexOf("/")+1);
			var streamType:String = StreamType.LIVE;

			// figure out stream items and stream type
			
			data = data.replace(/\n\n/g, "\n");
			var lines:Array = data.split("\n");

			for (var j:int = 0; j < lines.length; j++) {
				lines[j] = StringUtil.trim(lines[j]);
			}
			
			if (lines[0] != "#EXTM3U") {
				throw new Error("Extended M3U files must start with #EXTM3U");
			}

			var streamItems:Vector.<DynamicStreamingItem> = new Vector.<DynamicStreamingItem>();
			var item:DynamicStreamingItem;

			var i:int;
			var len:int = lines.length;
			var line:String;
			var bandwidth:Number;
			var width:Number;
			var height:Number;

			for (i = 1; i < len; i++) {
				line = String(lines[i]);

				// this isn't a top-level file after all, it is a single-rate version...
				if (line.indexOf("#EXTINF:") == 0) {
					item = new DynamicStreamingItem(url, 1000); // bw doesn't matter
					streamItems.push(item);
				}

				// sub-playlist
				if (line.indexOf("#EXT-X-STREAM-INF:") == 0) {
					bandwidth = 0;
					width = -1;
					height = -1;

					var params:Array = getParams(line.slice(line.indexOf(":") + 1));
					for each (var p:Object in params) {
						switch (p.name) {
							case "BANDWIDTH":
								bandwidth = Number(p.value) / 1000; // kbps
								break;

							case "RESOLUTION":
								var dims:Array = p.value.split("x");
								if (p.length == 2) {
									width = p[0];
									height = p[1];
								}
								break;
						}
					}

					var playlistURL:String;
					i++;
					var urlLine:String = String(lines[i]);

					if (urlLine.toLowerCase().indexOf("http://") == 0 || String(lines[i]).toLowerCase().indexOf("https://") == 0) {
						playlistURL = urlLine;
					}
					else {
						playlistURL = baseURL + urlLine;
					}

					item = new DynamicStreamingItem(playlistURL, bandwidth, width, height);
					streamItems.push(item);
				}

				// check for a defined end - assume live if there's no defined end
				if (line.indexOf("#EXT-X-ENDLIST") == 0) {
					streamType = StreamType.RECORDED;
				}
			}

			// figure out DVR stuff
			// TODO : This might not need to be done here.. Maybe just default to DVR and let the IndexHandler figure out the DVRInfo later...?
			if (streamType == StreamType.LIVE) {
				/*
				var dvrInfo:DVRInfo = new DVRInfo();
				dvrInfo.isRecording = (streamType == StreamType.RECORDED);
				dvrInfo.beginOffset =
				dvrInfo.startTime = 0;
				dvrInfo.endOffset =
				dvrInfo.curLength =
				dvrInfo.offline = false;
				dvrInfo.windowDuration =
				streamType = StreamType.DVR;
				*/
			}

			// build resource

			var resource:MediaResourceBase;

			if (streamItems.length == 0) {
				throw new Error("Invalid m3u8!");
			}
			else if (streamItems.length == 1) {
				resource = new StreamingURLResource(url, streamType);
			}
			else {
				resource = new DynamicStreamingResource(url, streamType);
				(resource as DynamicStreamingResource).streamItems = streamItems;
			}

			return resource;
		}

		private function getParams(str:String):Array {
			var parameters:Array = [];

			var items:Array = str.split(",");
			for each (var param:String in items) {
				if (param.charAt(0) == " ")
					param = param.substring(1);
				var values:Array = param.split("=");
				if (values.length == 2)
					parameters.push({name:values[0], value:values[1]});
			}

			return parameters;
		}

		//----------------------------------------
		//
		// Handlers
		//
		//----------------------------------------

		private function onComplete(event:Event):void {
			var resourceData:String = String((event.target as URLLoader).data);

			manifestLoader.removeEventListener(Event.COMPLETE, onComplete);
			manifestLoader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			manifestLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			manifestLoader = null;

			var resource:MediaResourceBase = buildStreamingResource(resourceData);
			finishLoad(resource);
		}

		private function onError(event:Event):void {
			manifestLoader.removeEventListener(Event.COMPLETE, onComplete);
			manifestLoader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			manifestLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			manifestLoader = null;
			error("Error loading m3u8.");
		}

		//----------------------------------------
		//
		// Constructor
		//
		//----------------------------------------

		public function M3U8Loader() {
		}
	}
}
