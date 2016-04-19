/**
 * Created by hyh on 11/8/15.
 */
package starlingbuilder.editor.helper
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

        public static function loads(files:Array, assetManager:AssetManager, onComplete:Function):void
        {
            var context:LoaderContext = new LoaderContext();

            context.allowCodeImport = true;
            context.applicationDomain = ApplicationDomain.currentDomain;

            var total:int = 0;
            var completed:int = 0;

            for (var i:int = 0; i < files.length; ++i)
            {
                var byteArray:ByteArray = assetManager.getByteArray(files[i]);

                if (byteArray)
                {
                    ++total;

                    var loader:Loader = new Loader();
                    loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
                    loader.loadBytes(byteArray, context);

                    function onLoaderComplete(e:Event):void
                    {
                        ++completed;

                        if (completed == total)
                            onComplete();
                    }
                }
            }

            if (total == 0)
                onComplete();
        }
    }
}
