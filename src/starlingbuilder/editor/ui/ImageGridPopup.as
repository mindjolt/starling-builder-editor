/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.ui
{
    import flash.utils.Dictionary;

    import starling.utils.Color;

    import starlingbuilder.editor.UIEditorApp;
    import starlingbuilder.editor.controller.ComponentRenderSupport;

    import starlingbuilder.util.DrawUtil;
    import starlingbuilder.util.ui.inspector.PropertyPanel;
    import starlingbuilder.util.ui.inspector.UIMapperEventType;

    import flash.geom.Rectangle;

    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.display.Quad;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.utils.RectangleUtil;

    public class ImageGridPopup extends DefaultEditPropertyPopup
    {
        public static const DEFAULT_SCALE9_GRID:Array = [0.3, 0.3, 0.4, 0.4];

        private static const MAX_SIZE:int = 700;

        private var _gridContainer:Sprite;

        private var _textureName:String;

        private var _image:Image;

        public function ImageGridPopup(owner:Object, target:Object, targetParam:Object, onComplete:Function)
        {
            super(owner, target, targetParam, onComplete);

            PropertyPanel.globalDispatcher.addEventListener(UIMapperEventType.PROPERTY_CHANGE, onRectChange);
        }

        override protected function createCustom():void
        {
            var imageContainer:Sprite = new Sprite();

            var params:Object = ComponentRenderSupport.support.extraParamsDict[_owner];

            if (params)
            {
                _textureName = params.constructorParams[0].textureName;
                _image = new Image(ComponentRenderSupport.support.assetMediator.getTexture(_textureName));
            }
            else
            {
                _image = new Image(_owner["texture"]);
            }

            _gridContainer = new Sprite();

            imageContainer.addChild(_image);
            imageContainer.addChild(_gridContainer);

            fitDisplayObject(_image);

            addChild(imageContainer);

            onRectChange(null);
        }

        private function onRectChange(event:Event):void
        {
            var rect:Rectangle = _target as Rectangle;

            if (event && event.data.target !== rect)
                return;

            _gridContainer.removeChildren();

            if (rect)
            {
                _gridContainer.addChild(makeLine(rect.x, 0, rect.x, _image.height));
                _gridContainer.addChild(makeLine(rect.x + rect.width, 0, rect.x + rect.width, _image.height));
                _gridContainer.addChild(makeLine(0, rect.y, _image.width, rect.y));
                _gridContainer.addChild(makeLine(0, rect.y + rect.height, _image.width, rect.y + rect.height));
            }
        }

        private function makeLine(x1:Number, y1:Number, x2:Number, y2:Number):Quad
        {
            return DrawUtil.makeLine(x1, y1, x2, y2, Color.RED);
        }

        override public function dispose():void
        {
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

        override protected function onClassPicker(event:Event):void
        {
            super.onClassPicker(event);

            onRectChange(null);
        }

        override protected function initDefault():void
        {
            var rect:Rectangle = _target as Rectangle;

            if (rect)
            {
                rect.x = Math.round(DEFAULT_SCALE9_GRID[0] * _image.width);
                rect.y = Math.round(DEFAULT_SCALE9_GRID[1] * _image.height);
                rect.width = Math.round(DEFAULT_SCALE9_GRID[2] * _image.width);
                rect.height = Math.round(DEFAULT_SCALE9_GRID[3] * _image.height);
            }
        }
    }
}
