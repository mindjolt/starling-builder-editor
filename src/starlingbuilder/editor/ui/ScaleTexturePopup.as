/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.ui
{
    import starling.utils.Color;

    import starlingbuilder.editor.UIEditorApp;
    import starlingbuilder.util.DrawUtil;
    import starlingbuilder.util.feathers.popup.InfoPopup;
    import starlingbuilder.util.ui.inspector.PropertyPanel;
    import starlingbuilder.util.ui.inspector.UIMapperEventType;

    import feathers.controls.LayoutGroup;
    import feathers.controls.PickerList;
    import feathers.data.ListCollection;
    import feathers.textures.Scale3Textures;

    import flash.geom.Rectangle;

    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.display.Quad;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.utils.AssetManager;
    import starling.utils.RectangleUtil;

    public class ScaleTexturePopup extends InfoPopup
    {
        private static const MAX_SIZE:int = 700;

        private var _assetManager:AssetManager;

        private var _gridContainer:Sprite;

        private var _textureName:String;
        private var _scaleRatio:Array;

        private var _rect:Rectangle;
        private var _scale9:Boolean;
        private var _direction:String;

        private var _image:Image;
        private var _pickerList:PickerList;
        private var _propertyPanel:PropertyPanel;

        private var _onComplete:Function;

        protected var _data:Object;

        public function ScaleTexturePopup(data:Object, onComplete:Function)
        {
            _data = data;

            _assetManager = UIEditorApp.instance.assetManager;
            _textureName = data.constructorParams[0].textureName;
            _scaleRatio = data.constructorParams[0].scaleRatio;
            _direction = Scale3Textures.DIRECTION_HORIZONTAL;

            _onComplete = onComplete;

            super(1024, 960);

            title = "Select Scale Area";
            buttons = ["OK", "Cancel"];

            addEventListener(Event.COMPLETE, onDialogComplete);

            PropertyPanel.globalDispatcher.addEventListener(UIMapperEventType.PROPERTY_CHANGE, onRectChange);
        }

        override protected function createContent(container:LayoutGroup):void
        {
            var imageContainer:Sprite = new Sprite();

            _image = new Image(_assetManager.getTexture(_textureName));
            _gridContainer = new Sprite();

            _rect = new Rectangle();

            if (_scaleRatio.length == 3)
            {
                _scale9 = false;

                _rect.x = _scaleRatio[0];
                _rect.width = _scaleRatio[1];

                _rect.y = _scaleRatio[0];
                _rect.height = _scaleRatio[1];

                _direction = _scaleRatio[2];

            }
            else if (_scaleRatio.length == 4)
            {
                _scale9 = true;

                _rect.x = _scaleRatio[0];
                _rect.y = _scaleRatio[1];
                _rect.width = _scaleRatio[2];
                _rect.height = _scaleRatio[3];
            }

            var params:Array = createUIMapperParams();
            _propertyPanel = new PropertyPanel(_rect, params);

            imageContainer.addChild(_image);
            imageContainer.addChild(_gridContainer);

            fitDisplayObject(_image);

            container.addChild(imageContainer);
            createDirectionPicker(container);
            container.addChild(_propertyPanel);

            onRectChange(null);
        }

        private function onRectChange(event:Event):void
        {
            if (event && event.data.target !== _rect)
                return;

            _gridContainer.removeChildren();

            if (_scale9)
            {
                _gridContainer.addChild(makeLine(_rect.x, 0, _rect.x, 1));
                _gridContainer.addChild(makeLine(_rect.x + _rect.width, 0, _rect.x + _rect.width, 1));
                _gridContainer.addChild(makeLine(0, _rect.y, 1, _rect.y));
                _gridContainer.addChild(makeLine(0, _rect.y + _rect.height, 1, _rect.y + _rect.height));
            }
            else
            {
                if (_direction == Scale3Textures.DIRECTION_HORIZONTAL)
                {
                    _gridContainer.addChild(makeLine(_rect.x, 0, _rect.x, 1));
                    _gridContainer.addChild(makeLine(_rect.x + _rect.width, 0, _rect.x + _rect.width, 1));
                }
                else
                {
                    _gridContainer.addChild(makeLine(0, _rect.y, 1, _rect.y));
                    _gridContainer.addChild(makeLine(0, _rect.y + _rect.height, 1, _rect.y + _rect.height));
                }
            }
        }

        private function makeLine(x1:Number, y1:Number, x2:Number, y2:Number):Quad
        {
            return DrawUtil.makeLine(x1 * _image.width, y1 * _image.height, x2 * _image.width, y2 * _image.height, Color.RED);
        }

        private function createUIMapperParams():Array
        {
            var params:Array = [];

            if (_scale9)
            {
                params.push(createUIMapperParam("x"));
                params.push(createUIMapperParam("width"));
                params.push(createUIMapperParam("y"));
                params.push(createUIMapperParam("height"));
            }
            else
            {
                if (_direction == Scale3Textures.DIRECTION_HORIZONTAL)
                {
                    params.push(createUIMapperParam("x"));
                    params.push(createUIMapperParam("width"));
                }
                else
                {
                    params.push(createUIMapperParam("y"));
                    params.push(createUIMapperParam("height"));
                }
            }

            return params;
        }

        private function createUIMapperParam(name:String):Object
        {
            return {"name":name, "component":"slider", "min":0, "max":1, "step":0.01};
        }

        private function createDirectionPicker(container:Sprite):void
        {
            if (!_scale9)
            {
                _pickerList = new PickerList();
                _pickerList.dataProvider = new ListCollection(["horizontal", "vertical"]);
                _pickerList.addEventListener(Event.CHANGE, onPickerListChange);

                if (_direction == Scale3Textures.DIRECTION_HORIZONTAL)
                    _pickerList.selectedIndex = 0;
                else
                    _pickerList.selectedIndex = 1;

                container.addChild(_pickerList);
            }
        }

        private function onPickerListChange(event:Event):void
        {
            _direction = _pickerList.selectedItem as String;

            _propertyPanel.reset();

            var params:Array = createUIMapperParams();
            _propertyPanel.reloadData(_rect, params);

            onRectChange(null);
        }

        private function onDialogComplete(event:Event):void
        {
            //We will change this later to a format compatible with Feathers Scale3Textures/Scale9Textures

            var index:int = int(event.data);

            if (index == 0)
            {
                var scaleRatio:Array;

                if (_scale9)
                {
                    scaleRatio = [_rect.x, _rect.y, _rect.width, _rect.height];
                }
                else
                {
                    if (_direction == Scale3Textures.DIRECTION_HORIZONTAL)
                    {
                        scaleRatio = [_rect.x, _rect.width, _direction];
                    }
                    else
                    {
                        scaleRatio = [_rect.y, _rect.height, _direction];
                    }
                }

                _data.constructorParams[0].scaleRatio = scaleRatio;

                complete();
            }
            else
            {
                _data = null;

                _onComplete = null;
            }

        }

        override public function dispose():void
        {
            removeEventListener(Event.COMPLETE, onDialogComplete);

            PropertyPanel.globalDispatcher.removeEventListener(UIMapperEventType.PROPERTY_CHANGE, onRectChange);

            super.dispose();
        }

        private function fitDisplayObject(object:DisplayObject):void
        {
            if (object.width > MAX_SIZE || object.height > MAX_SIZE)
            {
                var rect:Rectangle = RectangleUtil.fit(new Rectangle(0, 0, object.width, object.height), new Rectangle(0, 0, MAX_SIZE, MAX_SIZE));
                object.width = rect.width;
                object.height = rect.height;
            }
        }

        protected function complete():void
        {
            _onComplete(_data);
        }
    }
}
