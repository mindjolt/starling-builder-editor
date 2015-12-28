/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.helper
{
    import starlingbuilder.editor.UIEditorApp;
    import starlingbuilder.editor.data.TemplateData;
    import starlingbuilder.editor.history.MovePivotOperation;
    import starlingbuilder.editor.history.ResizeOperation;
    import starlingbuilder.engine.util.DisplayObjectUtil;
    import starlingbuilder.engine.util.ParamUtil;
    import starlingbuilder.util.ui.inspector.PropertyPanel;
    import starlingbuilder.util.ui.inspector.UIMapperEventType;

    import flash.geom.Point;
    import flash.geom.Rectangle;

    import starling.display.DisplayObject;
    import starling.display.Quad;
    import starling.display.Sprite;
    import starling.events.Event;

    public class InteractiveBoundingBox extends Sprite
    {


        public static const TOP_LEFT:String = "topLeft";
        public static const TOP_CENTER:String = "topCenter";
        public static const TOP_RIGHT:String = "topRight";

        public static const BOTTOM_LEFT:String = "bottomLeft";
        public static const BOTTOM_CENTER:String = "bottomCenter";
        public static const BOTTOM_RIGHT:String = "bottomRight";

        public static const LEFT_CENTER:String = "leftCenter";
        public static const RIGHT_CENTER:String = "rightCenter";

        public static const TOP:String = "top";
        public static const BOTTOM:String = "bottom";
        public static const LEFT:String = "left";
        public static const RIGHT:String = "right";

        public static const PIVOT_POINT:String = "pivotPoint";

        public static const DRAG_BOX:String = "dragBox";

        public static const BOUNDING_BOX:Array = [

            TOP, BOTTOM, LEFT, RIGHT,
            TOP_LEFT, TOP_CENTER, TOP_RIGHT,
            BOTTOM_LEFT, BOTTOM_CENTER, BOTTOM_RIGHT,
            LEFT_CENTER, RIGHT_CENTER,

        ]

        public static const INTERACTABLE:Array = [
            TOP_LEFT, TOP_CENTER, TOP_RIGHT,
            BOTTOM_LEFT, BOTTOM_CENTER, BOTTOM_RIGHT,
            LEFT_CENTER, RIGHT_CENTER,
        ]

        private var _target:DisplayObject;

        private var _boundingBoxContainer:Sprite;

        private var _enable:Boolean = true;

        public function InteractiveBoundingBox()
        {
            createBoundingBox();
            _boundingBoxContainer.visible = false;

            PropertyPanel.globalDispatcher.addEventListener(UIMapperEventType.PROPERTY_CHANGE, onChange);

        }

        public function set target(value:DisplayObject):void
        {
            if (_target !== value)
            {
                _target = value;

                reload();
            }
        }

        public function get target():DisplayObject
        {
            return _target;
        }



        public function reload():void
        {


            if (_target && _target.parent)
            {
                _boundingBoxContainer.visible = true;

                var rect:Rectangle = _target.getBounds(parent);
                updateBoundingBox(rect.x, rect.y, rect.width, rect.height, _target.pivotX, _target.pivotY);
            }
            else
            {
                _boundingBoxContainer.visible = false;
                updateBoundingBox(0, 0, 0, 0, 0, 0);
            }
        }

        private function createBoundingBox():void
        {
            var quad:Quad;

            _boundingBoxContainer = new Sprite();
            addChild(_boundingBoxContainer);

            quad = createDragBox(DRAG_BOX);
            DragHelper.startDrag(quad, onDrag, onComplete);
            _boundingBoxContainer.addChild(quad);

            quad = createPivot(PIVOT_POINT);
            DragHelper.startDrag(quad, onDrag, onComplete);
            _boundingBoxContainer.addChild(quad);

            for each (var name:String in BOUNDING_BOX)
            {
                quad = createSquare(name);

                _boundingBoxContainer.addChild(quad);

                if (INTERACTABLE.indexOf(name) != -1)
                {
                    DragHelper.startDrag(quad, onDrag, onComplete);
                }
            }
        }

        private function updateBoundingBox(x:Number, y:Number, width:Number, height:Number, pivotX:Number, pivotY:Number):void
        {
            var quad:Quad;

            if (_target)
            {
                this.x = x;
                this.y = y;
            }
            else
            {
                this.x = 0;
                this.y = 0;
            }

            if (_target)
            {
                var p:Point = _target.localToGlobal(new Point(_target.pivotX, _target.pivotY));
                p = this.globalToLocal(p);
                pivotX = p.x;
                pivotY = p.y;
//                pivotX *= _target.scaleX;
//                pivotY *= _target.scaleY;

                if (_target.width == 0 && _target.height == 0)
                {
                    _boundingBoxContainer.getChildByName(DRAG_BOX).visible = true;
                }
                else
                {
                    _boundingBoxContainer.getChildByName(DRAG_BOX).visible = false;
                }
            }

            quad = _boundingBoxContainer.getChildByName(PIVOT_POINT) as Quad;
            if (quad)
            {
                updateSquare(quad, width, height, pivotX, pivotY, _enable);
            }

            var b:Boolean = interactable(_target);
            var visible:Boolean = false;

            for each (var name:String in BOUNDING_BOX)
            {
                if (INTERACTABLE.indexOf(name) != -1)
                {
                    if (b && _enable)
                        visible = true;
                    else
                        visible = false;
                }
                else
                {
                    visible = true;
                }

                quad = _boundingBoxContainer.getChildByName(name) as Quad;
                if (quad)
                {
                    updateSquare(quad, width, height, pivotX, pivotY, visible);
                }
            }
        }

        private function interactable(target:DisplayObject):Boolean
        {
            if (target == null) return false;

            var params:Array = ParamUtil.getParams(TemplateData.editor_template, target);

            var count:int = 0;

            for each (var param:Object in params)
            {
                if (param.name == "width" || param.name == "height")
                    ++count;
            }

            return count >= 2;
        }

        private function createDragBox(name:String):Quad
        {
            var square:Quad = new Quad(50, 50, 0xffff00);
            square.alpha = 0.5;
            square.alignPivot();
            square.name = name;
            return square;
        }

        private function createPivot(name:String):Quad
        {
            var square:Quad = new Quad(14, 14, 0x00ff00);
            square.pivotX = square.width * 0.5;
            square.pivotY = square.height * 0.5;
            square.name = name;
            return square;
        }

        private function createSquare(name:String):Quad
        {
            var square:Quad = new Quad(10, 10, 0xff0000);
            square.pivotX = square.width * 0.5;
            square.pivotY = square.height * 0.5;
            square.name = name;
            return square;
        }

        private function updateSquare(quad:Quad, width:Number, height:Number, pivotX:Number, pivotY:Number, visible:Boolean):void
        {
            quad.visible = visible;

            switch (quad.name)
            {
                case TOP_LEFT:
                    quad.x = 0;
                    quad.y = 0;
                    break;
                case TOP_CENTER:
                    quad.x = width * 0.5;
                    quad.y = 0;
                    break;
                case TOP_RIGHT:
                    quad.x = width;
                    quad.y = 0;
                    break;
                case BOTTOM_LEFT:
                    quad.x = 0;
                    quad.y = height;
                    break;
                case BOTTOM_CENTER:
                    quad.x = width * 0.5;
                    quad.y = height;
                    break;
                case BOTTOM_RIGHT:
                    quad.x = width;
                    quad.y = height;

                    break;
                case LEFT_CENTER:
                    quad.x = 0;
                    quad.y = height * 0.5;
                    break;
                case RIGHT_CENTER:
                    quad.x = width;
                    quad.y = height * 0.5;
                    break;
                case TOP:
                    quad.x = width * 0.5;
                    quad.y = 0;
                    quad.width = width;
                    quad.height = 1;
                    break;
                case BOTTOM:
                    quad.x = width * 0.5;
                    quad.y = height;
                    quad.width = width;
                    quad.height = 1;
                    break;
                case LEFT:
                    quad.x = 0;
                    quad.y = height * 0.5;
                    quad.width = 1;
                    quad.height = height;
                    break;
                case RIGHT:
                    quad.x = width;
                    quad.y = height * 0.5;
                    quad.width = 1;
                    quad.height = height;
                    break;
                case PIVOT_POINT:
                    quad.x = pivotX;
                    quad.y = pivotY;
                    break;
            }


        }

        private function onDrag(object:DisplayObject, dx:Number, dy:Number):Boolean
        {
            //trace("dx:", dx, "dy:", dy);

            //disable resize when rotation is not 0
            if (_target.rotation != 0) return false;

            dx /= UIEditorApp.instance.documentManager.scale;
            dy /= UIEditorApp.instance.documentManager.scale;

            var ratioX:Number = 1 - _target.pivotX / (_target.width / _target.scaleX);
            var ratioY:Number = 1 - _target.pivotY / (_target.height / _target.scaleY);
            if (isNaN(ratioX)) ratioX = 1;
            if (isNaN(ratioY)) ratioY = 1;

            var oldValue:Rectangle = new Rectangle(_target.x, _target.y, _target.width, _target.height);

            switch (object.name)
            {
                case TOP_LEFT:
                    _target.x += dx * ratioX;
                    _target.y += dy * ratioY;
                    _target.width -= dx;
                    _target.height -= dy;
                    break;
                case TOP_CENTER:
                    _target.y += dy * ratioY;
                    _target.height -= dy;
                    break;
                case TOP_RIGHT:
                    _target.x += dx * (1 - ratioX);
                    _target.y += dy * ratioY;
                    _target.width += dx;
                    _target.height -= dy;
                    break;
                case BOTTOM_LEFT:
                    _target.x += dx * ratioX;
                    _target.y += dy * (1 - ratioY);
                    _target.width -= dx;
                    _target.height += dy;
                    break;
                case BOTTOM_CENTER:
                    _target.y += dy * (1 - ratioY);
                    _target.height += dy;
                    break;
                case BOTTOM_RIGHT:
                    _target.x += dx * (1 - ratioX);
                    _target.y += dy * (1 - ratioY);
                    _target.width += dx;
                    _target.height += dy;
                    break;
                case LEFT_CENTER:
                    _target.x += dx * ratioX;
                    _target.width -= dx;
                    break;
                case RIGHT_CENTER:
                    _target.x += dx * (1 - ratioX);
                    _target.width += dx;
                    break;
                case PIVOT_POINT:
                    DisplayObjectUtil.movePivotTo(_target, _target.pivotX + dx, _target.pivotY + dy);
                    UIEditorApp.instance.documentManager.historyManager.add(new MovePivotOperation(_target, new Point(_target.pivotX - dx, _target.pivotY - dx),
                            new Point(_target.pivotX, _target.pivotY)));
                    break;
                case DRAG_BOX:
                    _target.x += dx * ratioX;
                    _target.y += dy * ratioY;
                    break;
            }

            if (object.name != PIVOT_POINT)
            {
                var newValue:Rectangle = new Rectangle(_target.x, _target.y, _target.width, _target.height);
                UIEditorApp.instance.documentManager.historyManager.add(new ResizeOperation(_target, oldValue, newValue));
            }



            UIEditorApp.instance.documentManager.setChanged();

            return (dx * dx + dy * dy > 0.5);
        }

        private function onComplete():void
        {

        }

        private function onChange(event:Event):void
        {
            if (_target === event.data.target)
                reload();
        }

        public function get enable():Boolean
        {
            return _enable;
        }

        public function set enable(value:Boolean):void
        {
            _enable = value;

            reload();
        }

        override public function dispose():void
        {
            PropertyPanel.globalDispatcher.removeEventListener(UIMapperEventType.PROPERTY_CHANGE, onChange);

            super.dispose();
        }
    }
}
