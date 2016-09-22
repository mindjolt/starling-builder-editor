/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.ui
{
    import feathers.controls.Button;
    import feathers.controls.ButtonGroup;
    import feathers.controls.LayoutGroup;
    import feathers.controls.TextInput;
    import feathers.core.PopUpManager;
    import feathers.data.ListCollection;
    import feathers.events.FeathersEventType;
    import feathers.layout.HorizontalLayout;

    import flash.display.NativeMenu;
    import flash.display.NativeMenuItem;
    import flash.display.NativeWindow;
    import flash.events.Event;
    import flash.filesystem.File;
    import flash.geom.Point;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;

    import starling.core.Starling;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.utils.AssetManager;

    import starlingbuilder.editor.UIEditorApp;
    import starlingbuilder.editor.UIEditorScreen;
    import starlingbuilder.editor.controller.DocumentManager;
    import starlingbuilder.editor.events.DocumentEventType;
    import starlingbuilder.editor.serialize.LoadExternalDocumentMediator;
    import starlingbuilder.editor.serialize.UIEditorDocumentMediator;
    import starlingbuilder.util.feathers.FeathersUIUtil;
    import starlingbuilder.util.feathers.popup.InfoPopup;
    import starlingbuilder.util.history.HistoryManager;
    import starlingbuilder.util.history.OpenRecentManager;
    import starlingbuilder.util.serialize.DocumentSerializer;
    import starlingbuilder.util.serialize.IDocumentMediator;
    import starlingbuilder.util.ui.inspector.ColorPicker;

    public class Toolbar extends LayoutGroup
    {
        public static const BROWSE:String = "browse";
        public static const RELOAD:String = "reload";

        private var _assetManager:AssetManager;
        private var _documentManager:DocumentManager;

        private var _serializer:DocumentSerializer;
        private var _mediator:IDocumentMediator;

        private var _recentOpenManager:OpenRecentManager;

        private var _workspaceInput:TextInput;
        private var _workspaceButton:Button;

        private var _reloadButton:Button;

        private var _canvasSizeWidth:TextInput;
        private var _canvasSizeHeight:TextInput;

        private var _canvasScale:TextInput;
        private var _colorPicker:ColorPicker;

        private var _loadExternalSerializer:DocumentSerializer;

        public function Toolbar()
        {
            super();

            var layout:HorizontalLayout = new HorizontalLayout();
            layout.padding = 10;
            layout.gap = 5;
            this.layout = layout;

            _assetManager = UIEditorApp.instance.assetManager;
            _documentManager = UIEditorApp.instance.documentManager;

            _mediator = new UIEditorDocumentMediator();

            _serializer = new DocumentSerializer(_mediator);
            _serializer.addEventListener(BROWSE, doBrowse);
            _serializer.addEventListener(RELOAD, doReload);
            _serializer.addEventListener(DocumentSerializer.CHANGE, onChange);

            _recentOpenManager = new OpenRecentManager(UIEditorScreen.instance.workspaceDir);

            _loadExternalSerializer = new DocumentSerializer(new LoadExternalDocumentMediator(UIEditorApp.instance.documentManager));

            var group:ButtonGroup = new ButtonGroup();
            group.direction = ButtonGroup.DIRECTION_HORIZONTAL;
            group.dataProvider = new ListCollection(createTextButtons());
            addChild(group);

            addEventListener(starling.events.Event.ENTER_FRAME, onEnterFrame);

            var window:NativeWindow = Starling.current.nativeStage.nativeWindow;

            window.addEventListener(flash.events.Event.CLOSING, onClosing);

            UIEditorApp.instance.documentManager.addEventListener(DocumentEventType.CHANGE, onDocumentChange);


            _workspaceInput = new TextInput();
            _workspaceButton = FeathersUIUtil.buttonWithLabel("choose workspace", onChooseWorkspace);
            _reloadButton = FeathersUIUtil.buttonWithLabel("reload", onReload);
            addChild(_workspaceInput);
            addChild(_workspaceButton);

            //TODO: add this when memory leak is fixed
            addChild(_reloadButton);

            createCanvasInput();

            registerMenuActions();

//            NativeDragAndDropHelper.start(function(file:File):void{
//                _serializer.openWithFile(file);
//            });


        }


        private function createCanvasInput():void
        {
            var group:LayoutGroup = new LayoutGroup();

            var layout:HorizontalLayout = new HorizontalLayout();
            layout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
            layout.gap = 5;
            group.layout = layout;
            group.addChild(FeathersUIUtil.labelWithText("cavas size:"));

            _canvasSizeWidth = new TextInput();
            _canvasSizeWidth.addEventListener(FeathersEventType.ENTER, onCanvasChange);
            _canvasSizeWidth.addEventListener(FeathersEventType.FOCUS_OUT, onCanvasChange);
            _canvasSizeWidth.width = 50;

            _canvasSizeHeight = new TextInput();
            _canvasSizeHeight.addEventListener(FeathersEventType.ENTER, onCanvasChange);
            _canvasSizeHeight.addEventListener(FeathersEventType.FOCUS_OUT, onCanvasChange);
            _canvasSizeHeight.width = 50;

            _documentManager.addEventListener(DocumentEventType.CANVAS_CHANGE, onCanvas);

            group.addChild(_canvasSizeWidth);

            group.addChild(FeathersUIUtil.labelWithText("x"));

            group.addChild(_canvasSizeHeight);

            group.addChild(FeathersUIUtil.labelWithText("canvas scale:"));

            _canvasScale = new TextInput();
            _canvasScale.addEventListener(FeathersEventType.ENTER, onCanvasScaleChange);
            _canvasScale.addEventListener(FeathersEventType.FOCUS_OUT, onCanvasScaleChange);
            group.addChild(_canvasScale);

            _colorPicker = new ColorPicker();
            _colorPicker.addEventListener(starling.events.Event.CHANGE, onColorChange);
            group.addChild(_colorPicker);

            addChild(group);

        }

        private function onColorChange(event:starling.events.Event):void
        {
            _documentManager.canvasColor = _colorPicker.value;
        }

        private function onCanvasChange(event:starling.events.Event):void
        {
            _documentManager.canvasSize = new Point(int(_canvasSizeWidth.text), int(_canvasSizeHeight.text));
            _documentManager.setChanged();
        }

        private function onCanvas(event:starling.events.Event):void
        {
            var canvasSize:Point = _documentManager.canvasSize;
            _canvasSizeWidth.text = String(canvasSize.x);
            _canvasSizeHeight.text = String(canvasSize.y);

            _canvasScale.text = String(_documentManager.scale);

            _colorPicker.value = _documentManager.canvasColor;
        }

        private function onCanvasScaleChange(event:starling.events.Event):void
        {
            _documentManager.scale = Number(_canvasScale.text);
        }

        private function createTextButtons():Array
        {
            return [
                {label:"new", triggered:onButtonClick},
                {label:"open", triggered:onButtonClick},
                {label:"save", triggered:onButtonClick},
                {label:"save as", triggered:onButtonClick},
                {label:"external", triggered:onButtonClick},
                {label:"test", triggered:onButtonClick}
            ]
        }

        private function onButtonClick(event:starling.events.Event):void
        {
            var button:Button = event.target as Button;

            switch (button.label)
            {
                case "new":
                    create();
                    break;
                case "open":
                    open();
                    break;
                case "save":
                    save();
                    break;
                case "save as":
                    saveAs();
                    break;
                case "external":
                    openExternal();
                    break;
                case "test":
                    startTest();
                    break;
                default:
                    trace("Not implemented");
                    break;
            }
        }

        private function create():void
        {
            _serializer.create();
        }

        private function open():void
        {
            try
            {
                _serializer.open();
            }
            catch (e:Error)
            {
                InfoPopup.show(e.getStackTrace());
            }
        }

        private function save():void
        {
            _serializer.save();
        }

        private function saveAs():void
        {
            _serializer.saveAs();
        }

        private function openExternal():void
        {
            _loadExternalSerializer.open();
        }

        private function onEnterFrame(event:starling.events.Event):void
        {
            var title:String = "Starling Builder";

            var str:String = title;

            var file:File = _serializer.getFile();

            if (file)
                str += " " + file.url;
            else
                str += " [NEW]";

            if (_serializer.isDirty())
            {
                str += "*";
            }

            var window:NativeWindow = Starling.current.nativeStage.nativeWindow;
            if (!window.closed)
                window.title = str;
        }

        private function startTest():void
        {
            new TestPanel(_documentManager.startTest());
        }

        private function startTestGame():void
        {
            new TestPanel(_documentManager.startTest(true));
        }

        private function quit():void
        {
            Starling.current.nativeStage.nativeWindow.dispatchEvent(new flash.events.Event(flash.events.Event.CLOSING));
        }

        private function startExport():void
        {
            trace(JSON.stringify(UIEditorApp.instance.documentManager.export()));
        }

        private function onClosing(event:flash.events.Event):void
        {
            event.preventDefault();
            _serializer.close();
        }

        private function onDocumentChange():void
        {
            _serializer.markDirty(true);
        }

        public function set workspaceDir(value:String):void
        {
            _workspaceInput.text = value;
        }

        private function onChooseWorkspace(event:starling.events.Event):void
        {
            _serializer.customAction(BROWSE);
        }

        private function onReload(event:starling.events.Event):void
        {
            _serializer.customAction(RELOAD);
        }

        private function doBrowse(event:starling.events.Event):void
        {
            dispatchEventWith(BROWSE);
        }

        private function doReload(event:starling.events.Event):void
        {
            dispatchEventWith(RELOAD);
        }

        private function onShowTextBorder():void
        {
            _documentManager.showTextBorder = !_documentManager.showTextBorder;
            MainMenu.instance.getItemByName(MainMenu.SHOW_TEXT_BORDER).checked = _documentManager.showTextBorder;
        }

        private function onSnapPixel():void
        {
            _documentManager.snapPixel = !_documentManager.snapPixel;
            MainMenu.instance.getItemByName(MainMenu.SNAP_PIXEL).checked = _documentManager.snapPixel;
        }

        private function onResizableBox():void
        {
            _documentManager.enableBoundingBox = !_documentManager.enableBoundingBox;
            MainMenu.instance.getItemByName(MainMenu.RESIZABLE_BOX).checked = _documentManager.enableBoundingBox;
        }

        private function onOpenWorkspace():void
        {
            var file:File = UIEditorScreen.instance.workspaceDir;

            if (file)
            {
                file.openWithDefaultApplication();
            }
        }

        private function onEditTemplate():void
        {
            var file:File = UIEditorScreen.instance.workspaceDir;

            if (file)
            {
                var template:File = file.resolvePath("settings/editor_template.json");
                if (template.exists)
                {
                    template.openWithDefaultApplication();
                }
                else
                {
                    InfoPopup.show("Template not found! Reload Starling Builder to regenerate.");
                }
            }
            else
            {
                InfoPopup.show("Workspace not found!");
            }
        }

        private function onDeleteTemplate():void
        {
            deleteTemplate(true);
        }

        public function deleteTemplate(showPopup:Boolean):void
        {
            var file:File = UIEditorScreen.instance.workspaceDir;

            if (file)
            {
                var template:File = file.resolvePath("settings/editor_template.json");

                if (template.exists)
                {
                    template.deleteFile();
                    if (showPopup)
                        InfoPopup.show("Template deleted. Reload the editor to take effect.");
                }
                else
                {
                    if (showPopup)
                        InfoPopup.show("Template not found!");
                }
            }
            else
            {
                if (showPopup)
                    InfoPopup.show("Workspace not found!");
            }
        }

        private function onUndo():void
        {
            _documentManager.historyManager.undo();
            updateHistoryManager();
        }

        private function onRedo():void
        {
            _documentManager.historyManager.redo();
            updateHistoryManager();
        }

        private var OFFSET:Number = 0.707;

        private function onZoomIn():void
        {
            _documentManager.scale /= OFFSET;
        }

        private function onZoomOut():void
        {
            _documentManager.scale *= OFFSET;
        }

        private function onResetZoom():void
        {
            _documentManager.scale = 1;
        }

        private function onCanvasSnapshot():void
        {
            _documentManager.snapshot();
        }

        private function updateHistoryManager():void
        {
            var hint:String = _documentManager.historyManager.getNextRedoHint();
            var item:NativeMenuItem = MainMenu.instance.getItemByName(MainMenu.REDO);
            if (hint)
            {
                item.label = MainMenu.REDO + " " + hint;
                item.enabled = true;
            }
            else
            {
                item.label = MainMenu.REDO;
                item.enabled = false;
            }

            hint = _documentManager.historyManager.getNextUndoHint();
            item = MainMenu.instance.getItemByName(MainMenu.UNDO);
            if (hint)
            {
                item.label = MainMenu.UNDO + " " + hint;
                item.enabled = true;
            }
            else
            {
                item.label = MainMenu.UNDO;
                item.enabled = false;
            }

        }

        private function registerMenuActions():void
        {
            var menu:MainMenu = MainMenu.instance;

            menu.registerAction(MainMenu.NEW, create);
            menu.registerAction(MainMenu.OPEN, open);
            menu.registerAction(MainMenu.SAVE, save);
            menu.registerAction(MainMenu.SAVE_AS, saveAs);
            menu.registerAction(MainMenu.LOAD_EXTERNAL, openExternal);

            menu.registerAction(MainMenu.CHOOSE_WORKSPACE, onChooseWorkspace);
            menu.registerAction(MainMenu.RELOAD, onReload);

            menu.registerAction(MainMenu.TEST, startTest);
            menu.registerAction(MainMenu.TEST_GAME, startTestGame);
            menu.registerAction(MainMenu.QUIT, quit);

            menu.registerAction(MainMenu.SHOW_TEXT_BORDER, onShowTextBorder);
            menu.registerAction(MainMenu.SNAP_PIXEL, onSnapPixel);
            menu.registerAction(MainMenu.RESIZABLE_BOX, onResizableBox);

            menu.registerAction(MainMenu.OPEN_WORKSPACE, onOpenWorkspace);
            menu.registerAction(MainMenu.EDIT_TEMPLATE, onEditTemplate);
            menu.registerAction(MainMenu.DELETE_TEMPLATE, onDeleteTemplate);

            menu.getItemByName(MainMenu.SHOW_TEXT_BORDER).checked = _documentManager.showTextBorder;
            menu.getItemByName(MainMenu.SNAP_PIXEL).checked = _documentManager.snapPixel;
            menu.getItemByName(MainMenu.RESIZABLE_BOX).checked = _documentManager.enableBoundingBox;

            menu.registerAction(MainMenu.UNDO, onUndo);
            menu.registerAction(MainMenu.REDO, onRedo);

            menu.registerAction(MainMenu.ZOOM_IN, onZoomIn);
            menu.registerAction(MainMenu.ZOOM_OUT, onZoomOut);
            menu.registerAction(MainMenu.RESET_ZOOM, onResetZoom);
            menu.registerAction(MainMenu.CANVAS_SNAPSHOT, onCanvasSnapshot);

            menu.registerAction(MainMenu.DOCUMENTATION, onDocumentation);
            menu.registerAction(MainMenu.GITHUB_PAGE, onGithubPage);
            menu.registerAction(MainMenu.ABOUT, onAbout);
            menu.registerAction(MainMenu.CHECK_FOR_UPDATE, onCheckForUpdate);

            menu.registerAction(MainMenu.GROUP_WITH_SPRITE, onGroupWithSprite);
            menu.registerAction(MainMenu.GROUP_WITH_LAYOUTGROUP, onGroupWithLayoutGroup);
            menu.registerAction(MainMenu.UNGROUP, onUngroup);

            _documentManager.historyManager.addEventListener(starling.events.Event.CHANGE, updateHistoryManager);
            _documentManager.historyManager.addEventListener(HistoryManager.RESET, updateHistoryManager);

            updateRecentOpenMenu();
        }

        public function get documentSerializer():DocumentSerializer
        {
            return _serializer;
        }

        public static const DOCUMENTATION_PAGE:String = "http://wiki.starling-framework.org/builder/start";
        public static const GITHUB_PAGE:String = "https://github.com/mindjolt/starling-builder-editor";

        private function onDocumentation():void
        {
            navigateToURL(new URLRequest(DOCUMENTATION_PAGE));
        }

        private function onGithubPage():void
        {
            navigateToURL(new URLRequest(GITHUB_PAGE));
        }

        private function onAbout():void
        {
            var popup:AboutPopup = new AboutPopup();
            PopUpManager.addPopUp(popup);
        }

        private function onCheckForUpdate():void
        {
            UIEditorApp.instance.appUpdater.checkNow();
        }

        private function onChange(e:starling.events.Event):void
        {
            _recentOpenManager.open(e.data as String);

            trace(_recentOpenManager.recentFiles);

            updateRecentOpenMenu();
        }

        public static const RESET:String = "Reset";

        private function updateRecentOpenMenu():void
        {
            var menu:NativeMenu = MainMenu.instance.root;
            var subMenu:NativeMenu = menu.getItemByName(MainMenu.FILE).submenu.getItemByName(MainMenu.OPEN_RECENT).submenu;

            subMenu.removeAllItems();

            var item:NativeMenuItem;

            for each (var url:String in _recentOpenManager.recentFiles)
            {
                item = new NativeMenuItem(url);
                item.name = url;
                item.addEventListener(flash.events.Event.SELECT, onOpenRecent, false, 0, true);
                subMenu.addItem(item);
            }

            item = new NativeMenuItem("", true);
            subMenu.addItem(item);

            item = new NativeMenuItem(RESET);
            item.name = RESET;
            item.addEventListener(flash.events.Event.SELECT, onOpenRecent, false, 0, true);
            subMenu.addItem(item);

        }

        private function onOpenRecent(e:flash.events.Event):void
        {
            var item:NativeMenuItem = e.target as NativeMenuItem;

            if (item.name == RESET)
            {
                _recentOpenManager.reset();
                updateRecentOpenMenu();
            }
            else
            {
                var file:File = new File();
                file.url = item.name;

                if (file.exists)
                {
                    try
                    {
                        _serializer.openWithFile(file);
                    }
                    catch (e:Error)
                    {
                        InfoPopup.show(e.getStackTrace());
                    }
                }
                else
                {
                    InfoPopup.show("File not found!");
                }
            }
        }

        private function onGroupWithSprite():void
        {
            _documentManager.group(Sprite);
        }

        private function onGroupWithLayoutGroup():void
        {
            _documentManager.group(LayoutGroup);
        }

        private function onUngroup():void
        {
            _documentManager.ungroup();
        }
    }
}
