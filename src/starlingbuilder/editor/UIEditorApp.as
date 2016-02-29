/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor
{
    import starlingbuilder.editor.controller.DocumentManager;
    import starlingbuilder.editor.controller.LocalizationManager;
    import starlingbuilder.editor.themes.MetalWorksDesktopTheme2;

    import starling.display.Sprite;
    import starling.events.EventDispatcher;
    import starlingbuilder.editor.utils.AssetManager;
    import starlingbuilder.util.AppUpdater;

    public class UIEditorApp extends Sprite
    {
        private var _assetManager:AssetManager;
        private var _documentManager:DocumentManager;
        private var _localizationManager:LocalizationManager;
        private var _notificationDispatcher:EventDispatcher;

        private var _appUpdater:AppUpdater;

        private static var _instance:UIEditorApp;

        public static function get instance():UIEditorApp
        {
            return _instance;
        }


        public function UIEditorApp()
        {
            _appUpdater = new AppUpdater();

            setup();

            //new MetalWorksMobileTheme2(false, _documentManager);
            new MetalWorksDesktopTheme2(_documentManager);

            addChild(createEditorScreen());
        }

        private function setup():void
        {
            _assetManager = new AssetManager();
            _assetManager.keepFontXmls = true;
            _notificationDispatcher = new EventDispatcher();

            _instance = this;
        }

        public function init():void
        {
            _localizationManager = new LocalizationManager();
            _documentManager = new DocumentManager(_assetManager, _localizationManager);
        }

        public function get assetManager():AssetManager
        {
            return _assetManager;
        }

        public function get documentManager():DocumentManager
        {
            return _documentManager;
        }

        public function get localizationManager():LocalizationManager
        {
            return _localizationManager;
        }

        public function get notificationDispatcher():EventDispatcher
        {
            return _notificationDispatcher;
        }

        protected function createEditorScreen():Sprite
        {
            return new UIEditorScreen();
        }

        public function get appUpdater():AppUpdater
        {
            return _appUpdater;
        }


    }
}
