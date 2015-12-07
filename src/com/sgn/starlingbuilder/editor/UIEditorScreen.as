/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package com.sgn.starlingbuilder.editor
{
    import adobe.utils.ProductManager;

    import com.sgn.starlingbuilder.editor.data.EmbeddedData;

    import com.sgn.starlingbuilder.editor.helper.AssetLoaderWithOptions;
    import com.sgn.starlingbuilder.editor.helper.CustomComponentHelper;
    import com.sgn.starlingbuilder.editor.helper.CustomThemeHelper;
    import com.sgn.starlingbuilder.editor.helper.KeyboardHelper;
    import com.sgn.starlingbuilder.editor.ui.CenterPanel;
    import com.sgn.starlingbuilder.editor.ui.LeftPanel;
    import com.sgn.starlingbuilder.editor.ui.MainMenu;
    import com.sgn.starlingbuilder.editor.ui.RightPanel;
    import com.sgn.starlingbuilder.editor.ui.SettingPopup;
    import com.sgn.starlingbuilder.editor.ui.Toolbar;
    import com.sgn.tools.util.FileLoader;
    import com.sgn.tools.util.feathers.FeathersUIUtil;

    import feathers.controls.Button;
    import feathers.controls.LayoutGroup;
    import feathers.core.PopUpManager;
    import feathers.layout.AnchorLayout;
    import feathers.layout.AnchorLayoutData;

    import flash.desktop.NativeApplication;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.filesystem.File;
    import flash.ui.Mouse;
    import flash.ui.MouseCursorData;
    import flash.utils.Dictionary;
    import flash.utils.setTimeout;

    import starling.core.Starling;
    import starling.display.Image;
    import starling.display.Stage;
    import starling.events.Event;
    import starling.events.ResizeEvent;
    import com.sgn.starlingbuilder.editor.utils.AssetManager;

    public class UIEditorScreen extends LayoutGroup
    {
        //public static const LEFT_MARGIN:int = 200;
        //public static const RIGHT_MARGIN:int = 200;
        public static const TOP_MARGIN:int = 50;

        private var _stage:Stage;
        private var _assetManager:AssetManager;

        private var _toolbar:Toolbar;

        private var _leftPanel:LeftPanel;
        private var _rightPanel:RightPanel;
        private var _centerPanel:CenterPanel;

        private var _workspaceDir:File;

        private var _setting:Setting;

        private static var _instance:UIEditorScreen;

        public static function get instance():UIEditorScreen
        {
            return _instance;
        }

        public function UIEditorScreen()
        {
            _instance = this;

            new MainMenu();

            registerCursor();

            _assetManager = UIEditorApp.instance.assetManager;


            this.layout = new AnchorLayout();

            _stage = Starling.current.stage;
            _stage.addEventListener(Event.RESIZE, onResize);


            width = Starling.current.viewPort.width = Starling.current.stage.stageWidth = Starling.current.nativeStage.stageWidth;
            height = Starling.current.viewPort.height = Starling.current.stage.stageHeight = Starling.current.nativeStage.stageHeight;

            initWorkspaceDir();
        }

        private function registerCursor():void
        {
            var image:Bitmap = new EmbeddedData.horizontal_arrows();
            var data:MouseCursorData = new MouseCursorData();
            data.data = new <BitmapData>[image.bitmapData];
            Mouse.registerCursor(EmbeddedData.HORIZONTAL_ARROWS, data);
        }

        private function initWorkspaceDir():void
        {
            _setting = new Setting();

            if (_setting.workspaceUrl)
            {
                _workspaceDir = new File(_setting.workspaceUrl);

                if (_workspaceDir.exists)
                {
                    reload();
                }
                else
                {
                    var button:Button = FeathersUIUtil.buttonWithLabel("choose workspace", onBrowse);
                    addChild(button);
                    onBrowse(null);
                }
            }
            else
            {
                onBrowse(null);
            }
        }

        private function reload():void
        {
            prepareWorkspace();

            var assetManager:AssetManager = UIEditorApp.instance.assetManager;

            assetManager.purge();

            var assetLoader:AssetLoaderWithOptions = new AssetLoaderWithOptions(assetManager, _workspaceDir);
            assetLoader.enqueue(_workspaceDir.resolvePath("textures"));
            assetLoader.enqueue(_workspaceDir.resolvePath("fonts"));
            assetLoader.enqueue(_workspaceDir.resolvePath("backgrounds"));
            assetLoader.enqueue(_workspaceDir.resolvePath("libs"));

            assetManager.loadQueue(function(ratio:Number):void{
                if (ratio == 1)
                {
                    setTimeout(function():void{

                        init();



                    }, 1);
                }
            });

        }

        private function onBrowse(event:*):void
        {
            FileLoader.browseForDirectory("Choose workspace:", function(file:File):void{

                _workspaceDir = file;
                if (_toolbar) _toolbar.workspaceDir = _workspaceDir.url;

                _setting.workspaceUrl = _workspaceDir.url;
                _setting.persist();

                reboot();
                //reload();
            })
        }

        private function onReload(event:*):void
        {
            //reload();
            reboot();
        }

        private function reboot():void
        {
            var app:NativeApplication = NativeApplication.nativeApplication;

            var mgr:ProductManager =
                    new ProductManager("airappinstaller");

            mgr.launch("-launch " +
                    app.applicationID + " " +
                    app.publisherID);

            app.exit();
        }

        private function prepareWorkspace():void
        {
            const DIRS:Array = ["textures", "fonts", "backgrounds", "libs", "localization"];

            for each (var path:String in DIRS)
            {
                var dir:File = _workspaceDir.resolvePath(path);

                if (!dir.exists)
                {
                    dir.createDirectory();
                }
            }
        }

        private function init():void
        {
            var menu:MainMenu = MainMenu.instance;

            menu.unregisterAll();

            CustomComponentHelper.load(_assetManager, _workspaceDir, onComplete);

            function onComplete():void
            {
                UIEditorApp.instance.init();

                CustomThemeHelper.load(_assetManager);

                KeyboardHelper.startKeyboard(UIEditorApp.instance.documentManager);

                menu.registerAction(MainMenu.SETTING, onSetting);

                initUI();

            }


        }

        private function initUI():void
        {
            removeChildren(0, -1, true);

            createToolbar();
            createLeftPanel();
            createRightPanel();
            createCenterPanel();

            UIEditorApp.instance.documentManager.clear();
            _toolbar.documentSerializer.markDirty(false);
        }

        private function onSetting():void
        {
            var popup:SettingPopup = new SettingPopup(_setting, SettingParams.PARAMS);
            PopUpManager.addPopUp(popup);
        }


        private function onResize(event:ResizeEvent):void
        {
            width = Starling.current.stage.stageWidth = Starling.current.viewPort.width = event.width;
            height = Starling.current.stage.stageHeight = Starling.current.viewPort.height = event.height;
        }

        private function createToolbar():void
        {
            var layoutData:AnchorLayoutData = new AnchorLayoutData();
            layoutData.top = 0;
            layoutData.left = 0;

            _toolbar = new Toolbar();
            _toolbar.layoutData = layoutData;
            _toolbar.workspaceDir = _workspaceDir.url;
            _toolbar.addEventListener(Toolbar.BROWSE, onBrowse);
            _toolbar.addEventListener(Toolbar.RELOAD, onReload);

            addChild(_toolbar);

            _toolbar.validate();
        }

        private function createLeftPanel():void
        {
            var layoutData:AnchorLayoutData = new AnchorLayoutData();
            layoutData.left = 0;
            layoutData.top = 0;
            layoutData.bottom = 0;
            layoutData.topAnchorDisplayObject = _toolbar;

            _leftPanel = new LeftPanel();
            _leftPanel.layoutData = layoutData;
            addChild(_leftPanel);

            _leftPanel.validate();
        }

        private function createRightPanel():void
        {
            var layoutData:AnchorLayoutData = new AnchorLayoutData();
            layoutData.right = 5;
            layoutData.top = _toolbar.height;

            _rightPanel = new RightPanel();
            _rightPanel.layoutData = layoutData;
            addChild(_rightPanel);
        }

        private function createCenterPanel():void
        {
            var layoutData:AnchorLayoutData = new AnchorLayoutData();
            layoutData.left = _leftPanel.width;
            layoutData.top = _toolbar.height;
            layoutData.bottom = 0;
            layoutData.right = 5;
            layoutData.rightAnchorDisplayObject = _rightPanel;

            _centerPanel = new CenterPanel();
            _centerPanel.layoutData = layoutData;
            addChild(_centerPanel);
        }

        private function testButton():void
        {
            var button:Button = new Button();
            button.label = "test";
            button.defaultIcon = new Image(UIEditorApp.instance.assetManager.getTexture("add"));

            addChild(button);

            var layoutData:AnchorLayoutData = new AnchorLayoutData();
            layoutData.right = 10;
            layoutData.bottom = 10;
            button.layoutData = layoutData;
        }



        public function get leftPanel():LeftPanel
        {
            return _leftPanel;
        }

        public function get rightPanel():RightPanel
        {
            return _rightPanel;
        }

        public function get workspaceDir():File
        {
            return _workspaceDir;
        }

        // the name container with the registered bitmap fonts
        private static const BITMAP_FONT_DATA_NAME:String = "starling.display.TextField.BitmapFonts";

        public function getBitmapFontNames():Array
        {
            var array:Array = [];

            var dict:Dictionary = Starling.current.contextData[BITMAP_FONT_DATA_NAME] as Dictionary;
            for (var name:String in dict)
            {
                array.push(name);
            }
            array.sort();

            return array;
        }

        public function get setting():Setting
        {
            return _setting;
        }

    }
}
