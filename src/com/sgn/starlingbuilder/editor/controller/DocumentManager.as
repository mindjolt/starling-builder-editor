/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package com.sgn.starlingbuilder.editor.controller
{
    import com.sgn.starlingbuilder.editor.Setting;
    import com.sgn.starlingbuilder.editor.UIEditorScreen;
    import com.sgn.starlingbuilder.editor.data.TemplateData;
    import com.sgn.starlingbuilder.editor.events.DocumentEventType;
    import com.sgn.starlingbuilder.editor.helper.AssetMediator;
    import com.sgn.starlingbuilder.editor.helper.DragHelper;
    import com.sgn.starlingbuilder.editor.helper.FileListingHelper;
    import com.sgn.starlingbuilder.editor.helper.InteractiveBoundingBox;
    import com.sgn.starlingbuilder.editor.helper.PixelSnapper;
    import com.sgn.starlingbuilder.editor.helper.PixelSnapperData;
    import com.sgn.starlingbuilder.editor.helper.SelectHelper;
    import com.sgn.starlingbuilder.editor.history.CreateOperation;
    import com.sgn.starlingbuilder.editor.history.CutOperation;
    import com.sgn.starlingbuilder.editor.history.DeleteOperation;
    import com.sgn.starlingbuilder.editor.history.MoveLayerOperation;
    import com.sgn.starlingbuilder.editor.history.MoveOperation;
    import com.sgn.starlingbuilder.editor.history.PasteOperation;
    import com.sgn.starlingbuilder.editor.history.PropertyChangeOperation;
    import com.sgn.starlingbuilder.editor.themes.IUIEditorThemeMediator;
    import com.sgn.starlingbuilder.engine.IUIBuilder;
    import com.sgn.starlingbuilder.engine.UIBuilder;
    import com.sgn.tools.util.feathers.popup.InfoPopup;
    import com.sgn.tools.util.history.HistoryManager;
    import com.sgn.tools.util.history.IHistoryOperation;
    import com.sgn.tools.util.ui.inspector.PropertyPanel;
    import com.sgn.tools.util.ui.inspector.UIMapperEventType;

    import feathers.core.FeathersControl;
    import feathers.core.IFeathersControl;
    import feathers.core.PopUpManager;
    import feathers.data.ListCollection;

    import flash.desktop.Clipboard;
    import flash.desktop.ClipboardFormats;
    import flash.filesystem.File;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;

    import starling.display.DisplayObject;
    import starling.display.DisplayObjectContainer;
    import starling.display.Image;
    import starling.display.Quad;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.EventDispatcher;
    import starling.text.TextField;
    import starling.utils.AssetManager;

    public class DocumentManager extends EventDispatcher implements IUIEditorThemeMediator
    {
        private var _assetManager:AssetManager;
        private var _uiBuilder:IUIBuilder;
        private var _uiBuilderForGame:IUIBuilder;
        private var _assetMediator:AssetMediator;

        private var _historyManager:HistoryManager;

        private var _container:Sprite;

        private var _testContainer:Sprite;

        private var _canvas:Quad;

        private var _canvasContainer:Sprite;

        private var _backgroundContainer:Sprite;

        private var _layoutContainer:Sprite;

        private var _root:DisplayObjectContainer;

        private var _snapContainer:Sprite;

        private var _boundingBox:InteractiveBoundingBox;

        private var _selectedObject:DisplayObject;

        private var _extraParamsDict:Dictionary;

        private var _dataProvider:ListCollection; //use for listing layout

        private var _snapPixel:Boolean = true;

        private var _showTextBorder:Boolean = false;

        private var _hasFocus:Boolean = false;

        private var _localizationManager:LocalizationManager;

        private var _setting:Setting;

        public function DocumentManager(assetManager:AssetManager, localizationManager:LocalizationManager)
        {
            _assetManager = assetManager;

            _localizationManager = localizationManager;

            _extraParamsDict = new Dictionary();

            _dataProvider = new ListCollection();

            _assetMediator = new AssetMediator(_assetManager);

            _uiBuilder = new UIBuilder(_assetMediator, true, TemplateData.editor_template, _localizationManager.localization);
            _uiBuilderForGame = new UIBuilder(_assetMediator, false, TemplateData.editor_template, _localizationManager.localization);

            _canvas = new Quad(100, 100);
            _canvasContainer = new Sprite();
            _canvasContainer.addChild(_canvas);

            _backgroundContainer = new Sprite();
            _layoutContainer = new Sprite();
            _snapContainer = new Sprite();
            _boundingBox = new InteractiveBoundingBox();

            _testContainer = new Sprite();

            PropertyPanel.globalDispatcher.addEventListener(UIMapperEventType.PROPERTY_CHANGE, onPropertyChange);

            _historyManager = new HistoryManager();

            _setting = UIEditorScreen.instance.setting;
        }

        public function set container(value:Sprite):void
        {
            _container = value;

            _container.addChild(_canvasContainer);
            _container.addChild(_backgroundContainer);
            _container.addChild(_layoutContainer);
            _container.addChild(_snapContainer);
            _container.addChild(_boundingBox);



            reset();
        }

        private function setRoot(obj:DisplayObjectContainer, param:Object):void
        {
            if (_root)
            {
                _root.removeFromParent(true);
            }

            _root = obj;
            _layoutContainer.addChild(_root);
            _extraParamsDict[obj] = param;
        }

        private function createRoot():void
        {
            var data:Object = {cls:_setting.rootContainerClass, customParams:{}, params:{name:"root"}};
            var result:Object = _uiBuilder.createUIElement(data);
            setRoot(result.object, result.params);

            var objects:Array = [];
            var obj:DisplayObjectContainer = result.object;
            getObjectsByPrefixTraversal(obj, _extraParamsDict, objects);
            addFrom(obj, result.params, null);
        }

        private function getParent():DisplayObjectContainer
        {
            if (_selectedObject)
            {
                if (_uiBuilder.isContainer(_extraParamsDict[_selectedObject]))
                {
                    return _selectedObject as DisplayObjectContainer;
                }
                else
                {
                    return _selectedObject.parent;
                }
            }
            else
            {
                return _root;
            }
        }


        public function addTree(root:DisplayObject, paramDict:Dictionary, parent:DisplayObjectContainer = null, index:int = -1):void
        {
            if (parent == null)
            {
                parent = getParent();
            }

            addFrom(root, paramDict[root], parent, index);

            var container:DisplayObjectContainer = root as DisplayObjectContainer;

            if (container)
            {
                var objects:Array = [];
                getObjectsByPrefixTraversal(container, paramDict, objects);

                for each (var obj:DisplayObject in objects)
                {
                    addFrom(obj, paramDict[obj], null);
                }
            }

            selectObject(root);

            setLayerChanged();

            setChanged();
        }





        private function addFrom(obj:DisplayObject, param:Object, parent:DisplayObjectContainer = null, index:int = -1):void
        {

            if (!_uiBuilder.isContainer(param))
            {
                DragHelper.startDrag(obj, function(obj:DisplayObject, dx:Number, dy:Number):Boolean{

                    dx /= scale;
                    dy /= scale;
                    return move(dx, dy);
                }, function():void{
                    endMove();
                });

                SelectHelper.startSelect(obj, function(object:DisplayObject){
                    if (!(selectedObject is DisplayObjectContainer) || !DisplayObjectContainer(selectedObject).contains(object))
                        selectObject(object);
                });
            }

            if (obj is TextField)
            {
                TextField(obj).border = _showTextBorder;
            }

            if (obj.hasOwnProperty("scaleWhenDown") && obj["scaleWhenDown"] is Number)
            {
                obj["scaleWhenDown"] = 1;
            }

            _extraParamsDict[obj] = param;


            if (isAncestorOf(obj, _root))
            {
                //do nothing
            }
            else if (parent)
            {
                if (index < 0)
                    parent.addChild(obj);
                else
                    parent.addChildAt(obj, index);
            }

            var prefix:String = getPrefixFromObject(obj);

            _dataProvider.push({label:prefix + obj.name, "hidden":false, "lock":false, "obj":obj, "prefix":prefix});
        }


        private function getPrefixFromObject(obj:DisplayObject):String
        {
            var layer:int = getLayer(_root, obj, 1);

            var str:String = "";
            for (var i:int = 0; i < layer; ++i)
            {
                if (i == layer - 1)
                {
                    str += "  •  "
                }
                else
                {
                    str += "     ";
                }
            }

            return str;
        }

        private function sortDataProvider():void
        {
            var dict:Dictionary = new Dictionary();
            var objects:Array = [];

            for (var i:int = 0; i < _dataProvider.length; ++i)
            {
                var item:Object = _dataProvider.getItemAt(i);
                dict[item.obj] = item;

                objects.push(item.obj);
            }

            var result:Array = [];

            getObjectsByPrefixTraversal(_root, _extraParamsDict, result);

            _dataProvider = new ListCollection();
            for each (var obj:DisplayObject in result)
            {
                _dataProvider.push(dict[obj]);
            }
        }

        private function getObjectsByPrefixTraversal(container:DisplayObjectContainer, paramDict:Dictionary, result:Array):void
        {
            result.push(container);

            for (var i:int = 0; i < container.numChildren; ++i)
            {
                var child:DisplayObject = container.getChildAt(i);

                if (paramDict[child])
                {


                    if (_uiBuilder.isContainer(paramDict[child]))
                    {
                        getObjectsByPrefixTraversal(child as DisplayObjectContainer, paramDict, result);
                    }
                    else
                    {
                        result.push(child);
                    }
                }
            }
        }

        private function getLayer(container:DisplayObjectContainer, obj:DisplayObject, layer:int):int
        {
            for (var i:int = 0; i < container.numChildren; ++i)
            {
                var child:DisplayObject = container.getChildAt(i);

                if (child === obj)
                {
                    return layer;
                }
                else if (child is DisplayObjectContainer)
                {
                    var l:int = getLayer(child as DisplayObjectContainer, obj, layer + 1);
                    if (l >= 0)
                    {
                        return l;
                    }
                }
            }

            return -1;
        }

        private function removeFromParam(obj:DisplayObject, paramDict:Dictionary):void
        {
            if (paramDict[obj])
                delete paramDict[obj];

            var container:DisplayObjectContainer = obj as DisplayObjectContainer;

            if (container)
            {
                for (var i:int = 0; i < container.numChildren; ++i)
                {
                    removeFromParam(container.getChildAt(i), paramDict);
                }
            }
        }

        private function recreateFromParam(obj:DisplayObject, paramDict:Dictionary, newDict:Dictionary):void
        {
            if (paramDict[obj])
            {
                newDict[obj] = paramDict[obj];
            }

            var container:DisplayObjectContainer = obj as DisplayObjectContainer;

            if (container)
            {
                for (var i:int = 0; i < container.numChildren; ++i)
                {
                    recreateFromParam(container.getChildAt(i), paramDict, newDict);
                }
            }
        }

        private function endSelect(obj:DisplayObject):void
        {
            SelectHelper.endSelect(obj);

            var container:DisplayObjectContainer = obj as DisplayObjectContainer;

            if (container)
            {
                for (var i:int = 0; i < container.numChildren; ++i)
                {
                    SelectHelper.endSelect(container.getChildAt(i));
                }
            }
        }

        public function removeTree(obj:DisplayObject):void
        {
            if (_root == obj)
            {
                info("can't remove root");
                return;
            }

            var parent:DisplayObject = obj.parent;

            selectObject(null);

            removeFromParam(obj, _extraParamsDict);

            obj.removeFromParent();

            endSelect(obj);

            setLayerChanged();

            if (parent === _root)
            {
                selectObject(null);
            }
            else
            {
                selectObject(parent);
            }

            setChanged();
        }

        public function remove():void
        {
            if (_selectedObject)
            {
                var newDict:Dictionary = new Dictionary();
                recreateFromParam(_selectedObject, _extraParamsDict, newDict);
                _historyManager.add(new DeleteOperation(_selectedObject, newDict, _selectedObject.parent));
                removeTree(_selectedObject);
            }
        }

        public function move(dx:Number, dy:Number, ignoreSnapPixel:Boolean = false):Boolean
        {
            //trace("dx:", dx, "dy:", dy);

            if (!_selectedObject)
                return false;

            var data:PixelSnapperData;

            if (snapPixel && !ignoreSnapPixel)
            {
                _snapContainer.removeChildren(0, -1, true);

                data = PixelSnapper.snap(_selectedObject, _selectedObject.parent, _container.parent, new Point(dx, dy));

                if (data)
                {
                    dx = data.deltaX;
                    dy = data.deltaY;
                }
            }

            _selectedObject.x += dx;
            _selectedObject.y += dy;

            recordMoveHistory(dx, dy);

            if (data)
            {
                _snapContainer.x = _selectedObject.parent.x;
                _snapContainer.y = _selectedObject.parent.y;
                PixelSnapper.drawSnapLine(_snapContainer, data)
            }

            setChanged();

            return !snapPixel || (dx * dx + dy * dy > 0.5);
        }

        public function endMove():void
        {
            _snapContainer.removeChildren(0, -1, true);
        }


        public function moveUp():void
        {
            if (!_selectedObject)
                return;

            var parent:DisplayObjectContainer = _selectedObject.parent;

            var index:int = parent.getChildIndex(_selectedObject);
            if (index > 0)
            {
                _historyManager.add(new MoveLayerOperation(_selectedObject, index, index - 1));

                parent.setChildIndex(_selectedObject, index - 1);

                setLayerChanged()

                setChanged();
            }

        }

        public function moveDown():void
        {
            if (!_selectedObject)
                return;

            var parent:DisplayObjectContainer = _selectedObject.parent;

            var index:int = parent.getChildIndex(_selectedObject);
            if (index < parent.numChildren - 1)
            {
                _historyManager.add(new MoveLayerOperation(_selectedObject, index, index + 1));

                parent.setChildIndex(_selectedObject, index + 1);

                setLayerChanged();

                setChanged();
            }

        }

        public function selectObject(obj:DisplayObject):void
        {
            if (_selectedObject === obj)
            {
                return;
            }
            else
            {
                if (_selectedObject)
                {
                    _boundingBox.target = null;
                }

                _selectedObject = obj;

                if (_selectedObject is FeathersControl)
                {
                    FeathersControl(_selectedObject).invalidate();
                }

                if (_selectedObject)
                {
                    _boundingBox.target = _selectedObject;
                }

                setChanged();
            }
        }

        private function onPropertyChange(event:Event):void
        {
            var target:Object = event.data.target;

            if (target === _background || target === _selectedObject)
            {
                recordPropertyChangeHistory(event);

                setChanged();
            }
        }

        private function recordPropertyChangeHistory(event:Event):void
        {
            var data:Object = event.data;

            if (data.hasOwnProperty("oldValue"))
            {
                var operation:IHistoryOperation = new PropertyChangeOperation(data.target, data.propertyName, data.oldValue, data.target[data.propertyName]);
                _historyManager.add(operation);
            }
        }

        private function recordMoveHistory(dx:Number, dy:Number):void
        {
            var operation:IHistoryOperation = new MoveOperation(_selectedObject, new Point(_selectedObject.x - dx, _selectedObject.y - dy), new Point(_selectedObject.x, _selectedObject.y));
            _historyManager.add(operation);
        }

        public function get historyManager():HistoryManager
        {
            return _historyManager;
        }

        public function selectObjectAtIndex(index:int):void
        {
            var item:Object = _dataProvider.getItemAt(index);

            var obj:DisplayObject = item.obj;
            if (obj)
            {
                selectObject(obj);
            }
        }

        public function get selectedIndex():int
        {
            if (_selectedObject)
            {
                for (var i:int = 0; i < _dataProvider.length; ++i)
                {
                    var item:Object = _dataProvider.getItemAt(i);

                    if (item && item.obj === _selectedObject)
                    {
                        return i;
                    }
                }
            }

            return -1;
        }

        public function get selectedObject():DisplayObject
        {
            return _selectedObject;
        }


        public function startTest(forGame:Boolean = false):Sprite
        {
            _testContainer.removeChildren(0, -1, true);

            var data:Object = _uiBuilder.save(_layoutContainer, _extraParamsDict, TemplateData.editor_template);

            var setting:Object = exportSetting();

            if (setting.background)
            {
                _testContainer.addChild(createBackground(setting.background));
            }

            var root:DisplayObject;

            if (forGame)
            {
                root = _uiBuilderForGame.load(data, false).object;
            }
            else
            {
                root = _uiBuilder.load(data, false).object;
            }

            _testContainer.addChild(root);

            return _testContainer;
        }

        public function stopTest():void
        {
            _testContainer.removeChildren(0, -1, true);
        }

        public function export():Object
        {
            return _uiBuilder.save(_layoutContainer, _extraParamsDict, exportSetting());
        }

        private function exportSetting():Object
        {
            var setting:Object = {};

            if (background)
            {
                setting.background = {name:background.name, x:background.x, y:background.y, width:background.width, height:background.height};
            }

            if (canvasSize)
            {
                setting.canvasSize = {x:_canvasSize.x, y:_canvasSize.y};
            }

            return setting;
        }

        private function importSetting(setting:Object):void
        {
            if (setting)
            {
                if (setting.background)
                {
                    background = createBackground(setting.background)
                }

                if (setting.canvasSize)
                {
                    canvasSize = new Point(setting.canvasSize.x, setting.canvasSize.y);
                }
            }

            setChanged();
        }

        private function createBackground(data:Object):Image
        {
            try
            {
                var image:Image = new Image(_assetMediator.getTexture(data.name));
                image.name = data.name;
                image.x = data.x;
                image.y = data.y;
                image.width = data.width;
                image.height = data.height;
                return image;
            }
            catch (e:Error)
            {
                return null;
            }
        }

        public function importData(data:Object, file:File):void
        {
            _assetMediator.file = file;

            reset();

            var result:Object = _uiBuilder.load(data, false);

            var container:DisplayObjectContainer = result.object;

            var objects:Array = [];

            var obj:DisplayObject;

            getObjectsByPrefixTraversal(container, result.params, objects);

            setRoot(container, result.params[container]);

            //add other objects
            for each (obj in objects)
            {
                addFrom(obj, result.params[obj], null);
            }

            importSetting(result.data.setting);

            setChanged();
        }

        public function loadExternal(data:Object, file:File):void
        {
            _assetMediator.file = file;

            var result:Object = _uiBuilder.load(data, false);

            var name:String = FileListingHelper.stripPostfix(file.name);

            var container:DisplayObjectContainer = result.object;
            container.name = name;
            var param:Object = result.params[container];

            _uiBuilder.setExternalSource(param, name);

            addFrom(container, param, getParent());
        }

        private function reset():void
        {
            selectObject(null);
            _layoutContainer.removeChildren(0, -1, true);
            _snapContainer.removeChildren(0, -1, true);
            _extraParamsDict = new Dictionary();
            _dataProvider = new ListCollection();

            canvasSize = new Point(_setting.defaultCanvasWidth, _setting.defaultCanvasHeight);
            background = null;
            _historyManager.reset();
        }

        public function clear():void
        {
            reset();
            createRoot();
            refreshLabels();
            setChanged();
        }

        public function createFromData(data:Object):void
        {
            var parent:DisplayObjectContainer = getParent();

            var result:Object = _uiBuilder.createUIElement(data);
            var paramDict:Dictionary = new Dictionary();

            var obj:DisplayObject = result.object;
            paramDict[obj] = result.params;

            _historyManager.add(new CreateOperation(obj, paramDict, parent));

            addFrom(obj, result.params, parent);

            selectObject(obj);

            setLayerChanged();

            setChanged();
        }

        public function get dataProvider():ListCollection
        {
            return _dataProvider;
        }

        public function refresh():void
        {
            for (var i:int = 0; i < _dataProvider.length; ++i)
            {
                var item:Object = _dataProvider.getItemAt(i);

                updateHidden(item.obj, item.hidden);
                updateLock(item.obj, item.lock);
            }
        }

        private function updateHidden(obj:DisplayObject, value:Boolean):void
        {
            obj.visible = !value;
        }

        private function updateLock(obj:DisplayObject, value:Boolean):void
        {
            obj.touchable = !value;
        }

        private function refreshLabels():void
        {
            for (var i:int = 0; i < _dataProvider.length; ++i)
            {
                var item:Object = _dataProvider.getItemAt(i);
                var obj:DisplayObject = item.obj;
                item.label = item.prefix + obj.name;
                _dataProvider.updateItemAt(i);
            }
        }

        public function setChanged():void
        {
            refreshLabels();
            dispatchEventWith(DocumentEventType.CHANGE);

            if (_container && _container.parent is FeathersControl)
            {
                (_container.parent as FeathersControl).invalidate();
            }
        }

        public function setLayerChanged():void
        {
            sortDataProvider();
        }

        public function get snapPixel():Boolean
        {
            return _snapPixel;
        }

        public function set snapPixel(value:Boolean):void
        {
            _snapPixel = value;
        }

        public function get showTextBorder():Boolean
        {
            return _showTextBorder;
        }

        public function set showTextBorder(value:Boolean):void
        {
            _showTextBorder = value;

            for (var i:int = 0; i < _dataProvider.length; ++i)
            {
                var textField:TextField = _dataProvider.getItemAt(i).obj as TextField;
                if (textField) textField.border = _showTextBorder;
            }
        }

        private function isAncestorOf(child:DisplayObject, parent:DisplayObject):Boolean
        {
            var p:DisplayObject = child;
            while (p)
            {
                p = p.parent;
                if (p === parent) return true;
            }

            return false;
        }

        public function cut():void
        {
            copy();

            if (_selectedObject)
            {
                var newDict:Dictionary = new Dictionary();
                recreateFromParam(_selectedObject, _extraParamsDict, newDict);
                _historyManager.add(new CutOperation(_selectedObject, newDict, _selectedObject.parent));
                removeTree(_selectedObject);
            }
        }

        public function copy():void
        {
            if (_selectedObject)
                Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, _uiBuilder.copy(_selectedObject, _extraParamsDict));
        }

        public function paste():void
        {
            try
            {
                var data:Object = _uiBuilder.paste(Clipboard.generalClipboard.getData(ClipboardFormats.TEXT_FORMAT) as String);

                if (data)
                {
//                    var result:Object = _uiBuilder.createUIElement(data);
//                    result.object.x = result.object.y = 0;
//                    add(result.object, result.params);

                    var result:Object = _uiBuilder.load(data, false);
                    var root:DisplayObject = result.object;
                    var paramDict:Dictionary = result.params;

                    root.x = root.y = 0;

                    var parent:DisplayObjectContainer = getParent();
                    _historyManager.add(new PasteOperation(root, paramDict, parent));

                    addTree(root, paramDict, parent);

                }
            }
            catch(e:Error)
            {
                info("Invalid Format");
            }
        }

        public function duplicate():void
        {
            if (_selectedObject == null || _selectedObject === _root)
            {
                info("Can't duplicate root");
                return;
            }

            copy();
            paste();
        }

        private var _background:DisplayObject;

        public function set background(obj:DisplayObject):void
        {
            if (_background)
            {
                _background.removeFromParent(true);
                _background = null;
            }

            if (obj)
            {
                _background = obj;
                _backgroundContainer.addChild(obj);
            }
        }

        public function get background():DisplayObject
        {
            return _background;
        }


        private function info(text:String):void
        {
            var popup:InfoPopup = new InfoPopup(300, 200);
            popup.title = text;
            popup.buttons = ["OK"];

            PopUpManager.addPopUp(popup);
        }

        public function get enableBoundingBox():Boolean
        {
            return _boundingBox.enable;
        }

        public function set enableBoundingBox(value:Boolean)
        {
            _boundingBox.enable = value;
        }

        private var _canvasSize:Point = new Point();

        public function set canvasSize(value:Point):void
        {
            if (_canvasSize.x != value.x || _canvasSize.y != value.y)
            {
                _canvasSize = value;
            }

            _canvas.width = canvasSize.x;
            _canvas.height = canvasSize.y;

            _container.clipRect = new Rectangle(0, 0, canvasSize.x * _canvasContainer.scaleX, canvasSize.y * _canvasContainer.scaleY);

            FeathersControl(_container.parent).invalidate();

            dispatchEventWith(DocumentEventType.CANVAS_SIZE_CHANGE);
        }

        public function get canvasSize():Point
        {
            return _canvasSize;
        }

        public function get container():Sprite
        {
            return _container;
        }

        public function useGameTheme(target:IFeathersControl):Boolean
        {
            //work around to fix theme pollution, not ideal
            var obj:DisplayObject = target as DisplayObject;
            while (obj)
            {
                if (obj is IFeathersControl && IFeathersControl(obj).styleName.indexOf("uiEditor") != -1)
                    return false;
                obj = obj.parent;
            }

            var object:DisplayObject = target as DisplayObject;

            return (object && object.stage ==  null) || (container && container.contains(object)) || (_testContainer && _testContainer.contains(object));
        }

        public function get extraParamsDict():Dictionary
        {
            return _extraParamsDict;
        }

        public function get uiBuilder():IUIBuilder
        {
            return _uiBuilder;
        }


        public function get hasFocus():Boolean
        {
            return _hasFocus;
        }

        public function set hasFocus(value:Boolean):void
        {
            _hasFocus = value;
        }

        public function get root():DisplayObjectContainer
        {
            return _root;
        }

        public function get scale():Number
        {
            return _layoutContainer.scaleX;
        }

        public function set scale(value:Number):void
        {
            if (scale != value)
            {
                _layoutContainer.scaleX = _layoutContainer.scaleY = value;
                _backgroundContainer.scaleX = _backgroundContainer.scaleY = value;
                _canvasContainer.scaleX = _canvasContainer.scaleY = value;

                FeathersControl(_container.parent).invalidate();

                _container.clipRect = new Rectangle(0, 0, canvasSize.x * _canvasContainer.scaleX, canvasSize.y * _canvasContainer.scaleY);

                _boundingBox.reload();

                dispatchEventWith(DocumentEventType.CANVAS_SIZE_CHANGE);
            }
        }
    }
}
