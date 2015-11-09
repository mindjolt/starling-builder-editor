/**
 * Created by hyh on 11/8/15.
 */
package com.sgn.starlingbuilder.editor.helper
{
    import flash.display.Loader;
    import flash.events.Event;
    import flash.system.ApplicationDomain;
    import flash.system.LoaderContext;
    import flash.utils.ByteArray;

    import starling.utils.AssetManager;

    public class LoadSwfHelper
    {
        public function LoadSwfHelper()
        {
        }

        public static function load(fileName:String, assetManager:AssetManager, onComplete:Function):void
        {
            var context:LoaderContext = new LoaderContext();

            context.allowCodeImport = true;
            context.applicationDomain = ApplicationDomain.currentDomain;

            var byteArray:ByteArray = assetManager.getByteArray(fileName);

            if (byteArray)
            {
                var loader:Loader = new Loader();
                loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
                loader.loadBytes(byteArray, context);

                function onLoaderComplete(e:Event):void
                {
                    onComplete(loader);
                }
            }
            else
            {
                onComplete(null);
            }
        }
    }
}
