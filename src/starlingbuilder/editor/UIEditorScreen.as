/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor
{
    import adobe.utils.ProductManager;

    import flash.utils.getTimer;

    import starlingbuilder.editor.data.EmbeddedData;

    import starlingbuilder.editor.data.TemplateData;
    import starlingbuilder.editor.data.UIBuilderTemplate;
    import starlingbuilder.editor.helper.AssetLoaderWithOptions;
    import starlingbuilder.editor.helper.CustomComponentHelper;
    import starlingbuilder.editor.helper.CustomThemeHelper;
    import starlingbuilder.editor.helper.CustomThemeHelper;
    import starlingbuilder.editor.helper.FileListingHelper;
    import starlingbuilder.editor.helper.FilesMonitor;
    import starlingbuilder.editor.helper.KeyboardHelper;
    import starlingbuilder.editor.helper.LoadSwfHelper;
    import starlingbuilder.editor.helper.TemplateLoader;
    import starlingbuilder.editor.ui.CenterPanel;
    import starlingbuilder.editor.ui.LeftPanel;
    import starlingbuilder.editor.ui.LoadingPopup;
    import starlingbuilder.editor.ui.MainMenu;
    import starlingbuilder.editor.ui.PositionToolbar;
    import starlingbuilder.editor.ui.RightPanel;
    import starlingbuilder.editor.ui.SettingPopup;
    import starlingbuilder.editor.ui.Toolbar;
    import starlingbuilder.util.FileLoader;
    import starlingbuilder.util.feathers.FeathersUIUtil;

    import feathers.controls.Button;
    import feathers.controls.LayoutGroup;
    import feathers.core.PopUpManager;
    import feathers.layout.AnchorLayout;
    import feathers.layout.AnchorLayoutData;

    import flash.desktop.NativeApplication;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.utils.Dictionary;
    import flash.utils.setTimeout;

    import starling.core.Starling;
    import starling.display.Image;
    import starling.display.Stage;
    import starling.events.Event;
    import starling.events.ResizeEvent;
    import starling.utils.AssetManager;

    public class UIEditorScreen extends LayoutGroup
    {
        //public static const LEFT_MARGIN:int = 200;
        //public static const RIGHT_MARGIN:int = 200;
        public static const TOP_MARGIN:int = 50;

        private var _stage:Stage;
        private var _assetManager:AssetManager;
        private var _assetLoader:AssetLoaderWithOptions;

        private var _toolbar:Toolbar;
        private var _positionToolbar:PositionToolbar;

        private var _leftPanel:LeftPanel;
        private var _rightPanel:RightPanel;
        private var _centerPanel:CenterPanel;

        private var _workspaceDir:File;

        private var _setting:Setting;

        private var _workspaceSetting:WorkspaceSetting;

        private var _filesMonitor:FilesMonitor;

        private static var _instance:UIEditorScreen;

        public static function get instance():UIEditorScreen
        {
            return _instance;
        }

        public function UIEditorScreen()
        {
            _instance = this;

            new MainMenu();



            _assetManager = UIEditorApp.instance.assetManager;


            this.layout = new AnchorLayout();

            _stage = Starling.current.stage;
            _stage.addEventListener(Event.RESIZE, onResize);


            width = Starling.current.viewPort.width = Starling.current.stage.stageWidth = Starling.current.nativeStage.stageWidth;
            height = Starling.current.viewPort.height = Starling.current.stage.stageHeight = Starling.current.nativeStage.stageHeight;

            initWorkspaceDir();
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
                    addChooseWorkspaceButton();
                    onBrowse(null);
                }
            }
            else
            {
                addChooseWorkspaceButton();
                onBrowse(null);
            }
        }

        private function addChooseWorkspaceButton():void
        {
            var button:Button = FeathersUIUtil.buttonWithLabel("choose workspace", onBrowse);
            addChild(button);
        }

        private function reload():void
        {
            prepareWorkspace();

            var assetManager:AssetManager = UIEditorApp.instance.assetManager;

            assetManager.purge();

            _assetLoader = new AssetLoaderWithOptions(assetManager, _workspaceDir);

            var t:int = getTimer();

            for each (var path:String in _workspaceSetting.getAssetManagerPaths())
            {
                _assetLoader.enqueue(_workspaceDir.resolvePath(path));
            }

            trace("Enqueue time: ", getTimer() - t);

            var loadingPopup:LoadingPopup = new LoadingPopup();
            PopUpManager.addPopUp(loadingPopup);

            t = getTimer();

            assetManager.loadQueue(function(ratio:Number):void{

                loadingPopup.ratio = ratio;

                if (ratio == 1)
                {
                    trace("Loading time: ", getTimer() - t);

                    setTimeout(function():void{

                        PopUpManager.removePopUp(loadingPopup, true);
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
            createDefaultSettings();

            _workspaceSetting = new WorkspaceSetting();

            for each (var path:String in _workspaceSetting.getAssetManagerPaths())
            {
                var dir:File = _workspaceDir.resolvePath(path);

                if (!dir.exists)
                {
                    dir.createDirectory();
                }
            }
        }

        private function createDefaultSettings():void
        {
            var dir:File = _workspaceDir.resolvePath("settings");

            if (!dir.exists)
            {
                dir.createDirectory();
            }

            var fs:FileStream;
            var file:File;

            file = _workspaceDir.resolvePath("settings/texture_options.json");

            if (!file.exists)
            {
                fs = new FileStream();
                fs.open(file, FileMode.WRITE);
                fs.writeUTFBytes(new EmbeddedData.texture_options);
                fs.close();
            }

            file = _workspaceDir.resolvePath("settings/workspace_setting.json");

            if (!file.exists)
            {
                fs = new FileStream();
                fs.open(file, FileMode.WRITE);
                fs.writeUTFBytes(new EmbeddedData.workspace_setting);
                fs.close();
            }
        }

        private function init():void
        {
            var menu:MainMenu = MainMenu.instance;

            menu.unregisterAll();

            var libFiles:Array = FileListingHelper.getFileList(_workspaceDir, _workspaceSetting.libraryPath, ["swf"]);
            LoadSwfHelper.loads(libFiles, _assetManager, onComplete);

            _filesMonitor = new FilesMonitor(_workspaceSetting, _workspaceDir);
            _filesMonitor.addEventListener(Event.CHANGE, onFilesChange);

            function onComplete():void
            {
                TemplateLoader.load(_workspaceDir, "ui_builder", UIBuilderTemplate);
                CustomComponentHelper.load(_workspaceDir);

                UIEditorApp.instance.init();

                CustomThemeHelper.load();

                KeyboardHelper.startKeyboard(UIEditorApp.instance.documentManager);

                menu.registerAction(MainMenu.SETTING, onSetting);
                menu.registerAction(MainMenu.WORKSPACE_SETTING, onWorkspaceSetting);

                initUI();
                initTests();
            }
        }

        private function onFilesChange(event:Event):void
        {
            var files:Array = event.data.files as Array;

            _filesMonitor.stop();

            var loadingPopup:LoadingPopup = new LoadingPopup();
            PopUpManager.addPopUp(loadingPopup);

            var t:int = getTimer();

            _assetLoader.enqueue.apply(null, files);
            _assetManager.loadQueue(function(ratio:Number):void{

               loadingPopup.ratio = ratio;
               if (ratio == 1)
               {
                   var duration:int = getTimer() - t;
                   if (duration < 500)
                   {
                       setTimeout(function():void{
                           PopUpManager.removePopUp(loadingPopup);
                       }, 500 - duration);
                   }
                   else
                   {
                       PopUpManager.removePopUp(loadingPopup);
                   }

                   _leftPanel.assetTab.refreshAsset();
                   _filesMonitor.start();
               }
            });

        }


        private function initUI():void
        {
            removeChildren(0, -1, true);

            createToolbar();
            createLeftPanel();
            createRightPanel();
            createPositionToolbar();
            createCenterPanel();

            UIEditorApp.instance.documentManager.clear();
            _toolbar.documentSerializer.markDirty(false);
        }

        private function onSetting():void
        {
            var popup:SettingPopup = new SettingPopup("Setting", _setting, SettingParams.PARAMS);
            PopUpManager.addPopUp(popup);
        }

        private function onWorkspaceSetting():void
        {
            var popup:SettingPopup = new SettingPopup("Workspace Setting (Reload editor to take effect)", _workspaceSetting, WorkspaceSettingParams.PARAMS);
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
            layoutData.bottom = 0;

            _rightPanel = new RightPanel();
            _rightPanel.layoutData = layoutData;
            addChild(_rightPanel);
        }

        private function createCenterPanel():void
        {
            var layoutData:AnchorLayoutData = new AnchorLayoutData();
            layoutData.left = _leftPanel.width + _positionToolbar.width;
            layoutData.top = _toolbar.height;
            layoutData.bottom = 0;
            layoutData.right = 5;
            layoutData.rightAnchorDisplayObject = _rightPanel;

            _centerPanel = new CenterPanel();
            _centerPanel.layoutData = layoutData;
            addChild(_centerPanel);
        }

        private function createPositionToolbar():void
        {
            _positionToolbar = new PositionToolbar();
            _positionToolbar.validate();
            _positionToolbar.x = _leftPanel.width;
            _positionToolbar.y = _toolbar.height;
            addChild(_positionToolbar);
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

        public function get centerPanel():CenterPanel
        {
            return _centerPanel;
        }

        public function get toolbar():Toolbar
        {
            return _toolbar;
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

        public function get workspaceSetting():WorkspaceSetting
        {
            return _workspaceSetting;
        }

        protected function initTests():void
        {

        }

    }
}
