/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.helper
{
    import feathers.core.PopUpManager;

    import starlingbuilder.editor.UIEditorApp;
    import starlingbuilder.editor.themes.BaseMetalWorksDesktopTheme2;

    import flash.display.Loader;
    import flash.events.Event;
    import flash.system.LoaderContext;
    import flash.utils.ByteArray;

    import starling.core.Starling;
    import starling.utils.AssetManager;

    public class CustomThemeHelper
    {
        public static const NAME:String = "EmbeddedTheme";

        public function CustomThemeHelper()
        {
        }

        public static function load(assetManager:AssetManager):void
        {
            LoadSwfHelper.load(NAME, assetManager, onComplete);

            function onComplete(loader:Loader):void{

                if (loader)
                {
                    var cls:Class = loader.contentLoaderInfo.applicationDomain.getDefinition(NAME) as Class;
                    new cls.theme(false, UIEditorApp.instance.documentManager);
                    initializeStage();
                }

            }
        }

        protected static function initializeStage():void
        {
            Starling.current.stage.color = BaseMetalWorksDesktopTheme2.PRIMARY_BACKGROUND_COLOR;
            Starling.current.nativeStage.color = BaseMetalWorksDesktopTheme2.PRIMARY_BACKGROUND_COLOR;
            PopUpManager.overlayFactory = BaseMetalWorksDesktopTheme2.popUpOverlayFactory;
        }

    }
}
