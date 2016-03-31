/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.ui
{
    import feathers.controls.LayoutGroup;
    import feathers.core.PopUpManager;
    import feathers.layout.VerticalLayout;

    import flash.geom.Rectangle;

    import starling.core.Starling;

    import starling.display.Button;

    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.display.Stage;

    import starling.events.Event;
    import starling.textures.Texture;
    import starling.textures.TextureAtlas;

    import starlingbuilder.editor.UIEditorApp;

    import starlingbuilder.editor.controller.DocumentManager;
    import starlingbuilder.editor.history.CompositeHistoryOperation;
    import starlingbuilder.editor.history.MoveOperation;
    import starlingbuilder.editor.history.ResizeOperation;
    import starlingbuilder.util.feathers.FeathersUIUtil;

    public class PositionToolbar extends LayoutGroup
    {
        public static const ALIGN_LEFT:String = "align left";
        public static const ALIGN_CENTER:String = "align center";
        public static const ALIGN_RIGHT:String = "align right";

        public static const ALIGN_TOP:String = "align top";
        public static const ALIGN_MIDDLE:String = "align middle";
        public static const ALIGN_BOTTOM:String = "align bottom";

        public static const ALIGN_WIDTH:String = "align width";
        public static const ALIGN_HEIGHT:String = "align height";

        public static const DISTRIBUTE_HORIZONTAL:String = "distribute horizontal";
        public static const DISTRIBUTE_VERTICAL:String = "distribute vertical";

        public static const ALIGN_HORIZONTAL:String = "align horizontal";
        public static const ALIGN_VERTICAL:String = "align vertical";

        [Embed(source="position_tool.png")]
        public static const POSITION_TOOL_PNG:Class;

        [Embed(source="position_tool.xml", mimeType="application/octet-stream")]
        public static const POSITION_TOOL_XML:Class;

        public static var texture:Texture;
        public static var atlas:TextureAtlas;

        private var _documentManager:DocumentManager;

        private var _horizontalPadding:Object;
        private var _verticalPadding:Object;

        public function PositionToolbar()
        {
            _documentManager = UIEditorApp.instance.documentManager;

            _horizontalPadding = {padding:0};
            _verticalPadding = {padding:0};

            createButtons();
        }

        private function createButtons():void
        {
            if (texture == null) texture = Texture.fromBitmap(new POSITION_TOOL_PNG());
            if (atlas == null) atlas = new TextureAtlas(texture, XML(new POSITION_TOOL_XML));

            var group:LayoutGroup = FeathersUIUtil.layoutGroupWithVerticalLayout(15);
            var layout:VerticalLayout = group.layout as VerticalLayout;
            layout.paddingLeft = layout.paddingRight = 5;
            group.y = 25;
            for each (var item:Object in createTextButtons())
            {
                trace(item.name.replace(" ", "_"));
                var button:starling.display.Button = new starling.display.Button(atlas.getTexture(item.name.replace(" ", "_")));
                button.width = button.height = 22;
                button.name = item.name;
                button.addEventListener(Event.TRIGGERED, item.triggered);
                button.useHandCursor = false;
                group.addChild(button);

            }

            addChild(group);
        }

        private function createTextButtons():Array
        {
            var obj:Image = new Image(Texture.fromBitmap(new AboutPopup.ICON()));
            obj.width = obj.height = 32;

            return [
                {name:ALIGN_LEFT, textureName:"", triggered:onButtonClick},
                {name:ALIGN_CENTER, textureName:"", triggered:onButtonClick},
                {name:ALIGN_RIGHT, textureName:"", triggered:onButtonClick},

                {name:ALIGN_TOP, textureName:"", triggered:onButtonClick},
                {name:ALIGN_MIDDLE, textureName:"", triggered:onButtonClick},
                {name:ALIGN_BOTTOM, textureName:"", triggered:onButtonClick},

                {name:ALIGN_WIDTH, textureName:"", triggered:onButtonClick},
                {name:ALIGN_HEIGHT, textureName:"", triggered:onButtonClick},

                {name:DISTRIBUTE_HORIZONTAL, textureName:"", triggered:onButtonClick},
                {name:DISTRIBUTE_VERTICAL, textureName:"", triggered:onButtonClick},

                {name:ALIGN_HORIZONTAL, textureName:"", triggered:onButtonClick},
                {name:ALIGN_VERTICAL, textureName:"", triggered:onButtonClick},
            ]
        }

        private function onButtonClick(event:Event):void
        {
            var button:starling.display.Button = event.target as starling.display.Button;
            switch(button.name)
            {
                case ALIGN_LEFT:
                    changePosition(horizontalSortFunc, function(first:DisplayObject, obj:DisplayObject, prev:DisplayObject):void{
                        var r:Rectangle = first.getBounds(obj.parent);
                        var x1:Number = r.x;
                        r = obj.getBounds(obj.parent);
                        var x2:Number = obj.x - r.x;
                        obj.x = x1 + x2;
                    });
                    break;
                case ALIGN_CENTER:
                    changePosition(horizontalSortFunc, function(first:DisplayObject, obj:DisplayObject, prev:DisplayObject):void{
                        var r:Rectangle = first.getBounds(obj.parent);
                        var x1:Number = r.x + r.width / 2;
                        r = obj.getBounds(obj.parent);
                        var x2:Number = obj.x - (r.x + r.width / 2);
                        obj.x = x1 + x2;
                    });
                    break;
                case ALIGN_RIGHT:
                    changePosition(horizontalSortFunc, function(first:DisplayObject, obj:DisplayObject, prev:DisplayObject):void{
                        var r:Rectangle = first.getBounds(obj.parent);
                        var x1:Number = r.x + r.width;
                        r = obj.getBounds(obj.parent);
                        var x2:Number = obj.x - (r.x + r.width);
                        obj.x = x1 + x2;
                    });
                    break;
                case ALIGN_TOP:
                    changePosition(verticalSortFunc, function(first:DisplayObject, obj:DisplayObject, prev:DisplayObject):void{
                        var r:Rectangle = first.getBounds(obj.parent);
                        var y1:Number = r.y;
                        r = obj.getBounds(obj.parent);
                        var y2:Number = obj.y - r.y;
                        obj.y = y1 + y2;
                    });
                    break;
                case ALIGN_MIDDLE:
                    changePosition(verticalSortFunc, function(first:DisplayObject, obj:DisplayObject, prev:DisplayObject):void{
                        var r:Rectangle = first.getBounds(obj.parent);
                        var y1:Number = r.y + r.height / 2;
                        r = obj.getBounds(obj.parent);
                        var y2:Number = obj.y - (r.y + r.height / 2);
                        obj.y = y1 + y2;
                    });
                    break;
                case ALIGN_BOTTOM:
                    changePosition(verticalSortFunc, function(first:DisplayObject, obj:DisplayObject, prev:DisplayObject):void{
                        var r:Rectangle = first.getBounds(obj.parent);
                        var y1:Number = r.y + r.height;
                        r = obj.getBounds(obj.parent);
                        var y2:Number = obj.y - (r.y + r.height);
                        obj.y = y1 + y2;
                    });
                    break;
                case ALIGN_WIDTH:
                    changeSize(horizontalSortFunc, function(first:DisplayObject, obj:DisplayObject):void{
                        obj.width = first.getBounds(obj.parent).width;
                    });
                    break;
                case ALIGN_HEIGHT:
                    changeSize(verticalSortFunc, function(first:DisplayObject, obj:DisplayObject):void{
                        obj.height = first.getBounds(obj.parent).height;
                    });
                    break;
                case DISTRIBUTE_HORIZONTAL:
                    doAlignHorizontal(getHorizontalPadding());
                    break;
                case DISTRIBUTE_VERTICAL:
                    doAlignVertical(getVerticalPadding());
                    break;
                case ALIGN_HORIZONTAL:
                    var alignHorizontal:Function = function():void{
                        doAlignHorizontal(_horizontalPadding.padding);
                    };
                    PopUpManager.addPopUp(new SimpleEditPropertyPopup(_horizontalPadding, [{name:"padding", type:"Number"}], alignHorizontal, alignHorizontal));
                    break;
                case ALIGN_VERTICAL:
                    var alignVertical:Function = function():void{
                        doAlignVertical(_verticalPadding.padding);
                    };
                    PopUpManager.addPopUp(new SimpleEditPropertyPopup(_verticalPadding, [{name:"padding", type:"Number"}], alignVertical, alignVertical));
                    break;
            }
        }

        private function doAlignHorizontal(padding:Number):void
        {
            changePosition(horizontalSortFunc, function(first:DisplayObject, obj:DisplayObject, prev:DisplayObject):void{
                var r:Rectangle = prev.getBounds(obj.parent);
                var x1:Number = r.x + r.width;
                r = obj.getBounds(obj.parent);
                var x2:Number = obj.x - r.x;
                obj.x = x1 + x2 + padding;
            });
        }

        private function doAlignVertical(padding:Number):void
        {
            changePosition(verticalSortFunc, function(first:DisplayObject, obj:DisplayObject, prev:DisplayObject):void{
                var r:Rectangle = prev.getBounds(obj.parent);
                var y1:Number = r.y + r.height;
                r = obj.getBounds(obj.parent);
                var y2:Number = obj.y - r.y;
                obj.y = y1 + y2 + padding;
            });
        }

        private function changePosition(sortFunc:Function, opFunc:Function):void
        {
            var objects:Array = _documentManager.selectedObjects.sort(sortFunc);

            var ops:Array = [];

            if (objects.length > 1)
            {
                var first:DisplayObject = objects[0];
                for (var i:int = 1; i < objects.length; ++i)
                {
                    var obj:DisplayObject = objects[i];
                    var prev:DisplayObject = objects[i - 1];

                    var oldX:Number = obj.x;
                    var oldY:Number = obj.y;
                    opFunc(first, obj, prev);
                    var dx:Number = obj.x - oldX;
                    var dy:Number = obj.y - oldY;

                    ops.push(new MoveOperation(obj, dx, dy));
                }

                _documentManager.historyManager.add(new CompositeHistoryOperation(ops));
                _documentManager.setChanged();
            }
        }

        private function changeSize(sortFunc:Function, opFunc:Function):void
        {
            var objects:Array = _documentManager.selectedObjects.sort(sortFunc);

            var ops:Array = [];

            if (objects.length > 1)
            {
                var first:DisplayObject = objects[0];
                for (var i:int = 1; i < objects.length; ++i)
                {
                    var obj:DisplayObject = objects[i];

                    var oldValue:Rectangle = new Rectangle(obj.x, obj.y, obj.width, obj.height);
                    opFunc(first, obj);
                    var newValue:Rectangle = new Rectangle(obj.x, obj.y, obj.width, obj.height);

                    ops.push(new ResizeOperation(obj, oldValue, newValue));
                }

                _documentManager.historyManager.add(new CompositeHistoryOperation(ops));
                _documentManager.setChanged();
            }
        }

        private function horizontalSortFunc(obj1:DisplayObject, obj2:DisplayObject):int
        {
            var stage:Stage = Starling.current.stage;
            var x1:Number = obj1.getBounds(stage).x;
            var x2:Number = obj2.getBounds(stage).x;
            return x1 - x2;
        }

        private function verticalSortFunc(obj1:DisplayObject, obj2:DisplayObject):int
        {
            var stage:Stage = Starling.current.stage;
            var y1:Number = obj1.getBounds(stage).y;
            var y2:Number = obj2.getBounds(stage).y;
            return y1 - y2;
        }

        public function getHorizontalPadding():Number
        {
            var objects:Array = _documentManager.selectedObjects;

            if (objects == null || objects.length < 2) return 0;

            var left:Number = Number.MAX_VALUE;
            var right:Number = Number.MIN_VALUE;
            var width:Number = 0;

            for each (var obj:DisplayObject in objects)
            {
                left = Math.min(left, obj.getBounds(obj.parent).left);
                right = Math.max(right, obj.getBounds(obj.parent).right);
                width += obj.width;
            }

            return (right - left - width) / (objects.length - 1);
        }

        public function getVerticalPadding():Number
        {
            var objects:Array = _documentManager.selectedObjects;

            if (objects == null || objects.length < 2) return 0;

            var top:Number = Number.MAX_VALUE;
            var bottom:Number = Number.MIN_VALUE;
            var height:Number = 0;

            for each (var obj:DisplayObject in objects)
            {
                top = Math.min(top, obj.getBounds(obj.parent).top);
                bottom = Math.max(bottom, obj.getBounds(obj.parent).bottom);
                height += obj.height;
            }

            return (bottom - top - height) / (objects.length - 1);
        }



    }
}
