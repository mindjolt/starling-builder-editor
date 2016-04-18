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

    import flash.utils.getDefinitionByName;

    import starlingbuilder.editor.UIEditorApp;
    import starlingbuilder.editor.themes.BaseMetalWorksDesktopTheme2;

    import starling.core.Starling;

    public class CustomThemeHelper
    {
        private static const NAME:String = "EmbeddedTheme";

        public static function load():void
        {
            try
            {
                var cls:Class = getDefinitionByName(NAME) as Class;
                new cls.theme(false, UIEditorApp.instance.documentManager);
                initializeStage();
            }
            catch (e:Error){}
        }

        protected static function initializeStage():void
        {
            Starling.current.stage.color = BaseMetalWorksDesktopTheme2.PRIMARY_BACKGROUND_COLOR;
            Starling.current.nativeStage.color = BaseMetalWorksDesktopTheme2.PRIMARY_BACKGROUND_COLOR;
            PopUpManager.overlayFactory = BaseMetalWorksDesktopTheme2.popUpOverlayFactory;
        }

    }
}
