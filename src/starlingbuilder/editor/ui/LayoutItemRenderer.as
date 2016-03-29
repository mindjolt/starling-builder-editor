/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.ui
{
    import feathers.controls.Check;
    import feathers.controls.Label;
    import feathers.controls.LayoutGroup;
    import feathers.controls.ToggleButton;
    import feathers.controls.renderers.DefaultListItemRenderer;
    import feathers.dragDrop.DragData;
    import feathers.dragDrop.DragDropManager;
    import feathers.dragDrop.IDragSource;
    import feathers.dragDrop.IDropTarget;
    import feathers.events.DragDropEvent;
    import feathers.layout.HorizontalLayout;
    import feathers.layout.VerticalLayout;

    import starling.display.Button;
    import starling.display.DisplayObject;
    import starling.display.DisplayObjectContainer;
    import starling.display.Image;
    import starling.display.Quad;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.textures.Texture;

    import starlingbuilder.editor.UIEditorApp;
    import starlingbuilder.editor.data.EmbeddedImages;
    import starlingbuilder.editor.history.MoveLayerOperation;
    import starlingbuilder.util.feathers.FeathersUIUtil;

    public class LayoutItemRenderer extends DefaultListItemRenderer implements IDragSource, IDropTarget
    {
        [Embed(source="eye.png")]
        private static const EYE:Class;

        [Embed(source="lock.png")]
        private static const LOCK:Class;

        private static var eyeTexture:Texture;
        private static var lockTexture:Texture;


        public static const SOURCE:String = "source";
        public static const TARGET:String = "target";
        public static const INDEX:String = "index";

        public static const DROP_ABOVE:String = "above";
        public static const DROP_INSIDE:String = "inside";
        public static const DROP_BELOW:String = "below";

        private var _group:LayoutGroup;
        private var _hiddenCheck:ToggleButton;
        private var _lockCheck:ToggleButton;

        private var _group2:LayoutGroup;
        private var _sign:Button;
        private var _nameLabel:Label;

        private var _dropLine:Quad;

        public function LayoutItemRenderer()
        {
            super();

            if (lockTexture == null) lockTexture = Texture.fromBitmap(new LOCK);
            if (eyeTexture == null) eyeTexture = Texture.fromBitmap(new EYE);


            createIconGroup();
            _iconFunction = layoutIconFunction;
            _labelFunction = nameLabelFunction;

            addEventListener(TouchEvent.TOUCH, onTouch);
            addEventListener(DragDropEvent.DRAG_ENTER, onDragEnter);
            addEventListener(DragDropEvent.DRAG_MOVE, onDragMove);
            addEventListener(DragDropEvent.DRAG_EXIT, onDragExit);
            addEventListener(DragDropEvent.DRAG_DROP, onDragDrop);
        }

        private function onTrigger(event:Event):void
        {
            if (_data.collapse)
            {
                UIEditorApp.instance.documentManager.expand(_data.obj);
            }
            else
            {
                UIEditorApp.instance.documentManager.collapse(_data.obj);
            }
        }

        private function createIconGroup():void
        {
            _group = new LayoutGroup();

            var layout:HorizontalLayout = FeathersUIUtil.horizontalLayout(10);
            layout.paddingTop = layout.paddingBottom = 16;
            layout.paddingRight = 10;

            _group.layout = layout;

            _hiddenCheck = new ToggleButton();
            _hiddenCheck.styleName = "no-theme";
            _hiddenCheck.defaultSkin = getImage(eyeTexture, 0.5, 1);
            _hiddenCheck.defaultSelectedSkin = getImage(eyeTexture, 0.5, 0.3);
            //_hiddenCheck.label = "hidden";

            _hiddenCheck.addEventListener(Event.CHANGE, function():void{
                _data.hidden = _hiddenCheck.isSelected;
                UIEditorApp.instance.documentManager.refresh();
            });
            _group.addChild(_hiddenCheck);

            _lockCheck = new ToggleButton();
            _lockCheck.styleName = "no-theme";
            _lockCheck.defaultSkin = getImage(lockTexture, 0.5, 0.3);
            _lockCheck.defaultSelectedSkin = getImage(lockTexture, 0.5, 1);
            //_lockCheck.label = "lock";
            _lockCheck.addEventListener(Event.CHANGE, function():void{
                _data.lock = _lockCheck.isSelected;
                UIEditorApp.instance.documentManager.refresh();
            });
            _group.addChild(_lockCheck);

            layout = new HorizontalLayout();
            layout.gap = 2;
            layout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
            _group2 = new LayoutGroup();
            _group2.layout = layout;

            if (EmbeddedImages.expand_sign_texture == null) EmbeddedImages.expand_sign_texture = Texture.fromBitmap(new EmbeddedImages.expand_sign())
            _sign = new Button(EmbeddedImages.expand_sign_texture);
            _sign.alignPivot();
            _sign.addEventListener(Event.TRIGGERED, onTrigger);

            _nameLabel = new Label();
            _group2.addChild(_group);
            _group2.addChild(_sign);
            _group2.addChild(_nameLabel);


        }

        private function layoutIconFunction(item:Object):DisplayObject
        {
            _hiddenCheck.isSelected = item.hidden;
            _lockCheck.isSelected = item.lock;
            _nameLabel.text = item.label;
            _sign.rotation = item.collapse ? 0 : Math.PI / 2;
            _data = item;

            changeState(STATE_UP);

            if (item.isContainer)
            {
                _group2.addChildAt(_sign, 1);
            }
            else
            {
                _sign.removeFromParent();
            }

            HorizontalLayout(_group2.layout).firstGap = item.layer * 20;
            return _group2;
        }

        private function nameLabelFunction(item:Object):String
        {
            return "";
        }

        private function onTouch(event:TouchEvent):void
        {
            if (DragDropManager.isDragging)
            {
                return;
            }

            var touch:Touch = event.getTouch(this);
            if (touch && touch.phase == TouchPhase.MOVED)
            {
                var clone:LayoutItemRenderer = new LayoutItemRenderer();
                clone.width = width;
                clone.height = height;
                clone.styleName = this.styleName;
                clone.data = _data;
                clone.owner = owner;
                clone.alpha = 0.5;

                var dragData:DragData = new DragData();
                dragData.setDataForFormat(SOURCE, _data.obj);

                DragDropManager.startDrag(this, touch, dragData, clone, -clone.width / 2, -clone.height / 2);
            }
        }

        private function onDragEnter(event:DragDropEvent, dragData:DragData):void
        {
            DragDropManager.acceptDrag(this);
            showDropLine(event, dragData);
        }

        private function onDragMove(event:DragDropEvent, dragData:DragData):void
        {
            showDropLine(event, dragData);
        }

        private function onDragDrop(event:DragDropEvent, dragData:DragData):void
        {
            hideDropLine(event);

            var target:DisplayObjectContainer = dragData.getDataForFormat(TARGET);
            var source:DisplayObject = dragData.getDataForFormat(SOURCE);
            var index:int = dragData.getDataForFormat(INDEX);

            if (target === source) return;

            if (canDrop(target, source))
            {
                //don't forget to subtract its own index
                if (source.parent === target && source.parent.getChildIndex(source) < index)
                    --index;

                UIEditorApp.instance.documentManager.historyManager.add(new MoveLayerOperation(source, target, source.parent.getChildIndex(source), index));

                //var point:Point = source.parent.localToGlobal(new Point(source.x, source.y));
                target.addChildAt(source, index);
                //point = target.globalToLocal(point);
                //source.x = point.x;
                //source.y = point.y;

                UIEditorApp.instance.documentManager.setLayerChanged();
                UIEditorApp.instance.documentManager.setChanged();
            }
        }

        private function canDrop(target:DisplayObjectContainer, source:DisplayObject):Boolean
        {
            if (target === source)
            {
                return false;
            }
            else if (source is DisplayObjectContainer && (source as DisplayObjectContainer).contains(target))
            {
                return false;
            }
            else
            {
                return true;
            }
        }

        private function onDragExit(event:DragDropEvent, dragData:DragData):void
        {
            hideDropLine(event);
        }

        private function showDropLine(event:DragDropEvent, dragData:DragData):void
        {
            createDropLine();

            var dropPosition:String;
            var target:DisplayObjectContainer;
            var index:int;

            if (_data.obj === UIEditorApp.instance.documentManager.root)
            {
                dropPosition = DROP_INSIDE;
            }
            else if (_data.isContainer)
            {
                if (event.localY < height / 3)
                {
                    dropPosition = DROP_ABOVE;
                }
                else if (event.localY < height * 2 / 3)
                {
                    dropPosition = DROP_INSIDE;
                }
                else
                {
                    dropPosition = DROP_BELOW;
                }
            }
            else
            {
                if (event.localY < height / 2)
                {
                    dropPosition = DROP_ABOVE;
                }
                else
                {
                    dropPosition = DROP_BELOW;
                }
            }

            if (dropPosition == DROP_ABOVE)
            {
                _dropLine.visible = true;
                _dropLine.y = 0;
                alpha = 1;
                target = _data.obj.parent;
                index = target.getChildIndex(_data.obj);
            }
            else if (dropPosition == DROP_INSIDE)
            {
                _dropLine.visible = false;
                alpha = 0.5;
                target = _data.obj;
                index = target.numChildren;
            }
            else
            {
                _dropLine.visible = true;
                _dropLine.y = height;
                target = _data.obj.parent;
                index = target.getChildIndex(_data.obj) + 1;
            }

            dragData.setDataForFormat(TARGET, target);
            dragData.setDataForFormat(INDEX, index);
        }

        private function hideDropLine(event:DragDropEvent):void
        {
            createDropLine();

            _dropLine.visible = false;
            alpha = 1;
        }

        private function createDropLine():void
        {
            if (!_dropLine)
            {
                _dropLine = new Quad(width, 1);
                addChild(_dropLine);
            }
        }

        public static function getImage(texture:Texture, scale:Number, alpha:Number):Image
        {
            var image:Image = new Image(texture);
            image.scaleX = image.scaleY = scale;
            image.alpha = alpha;
            return image;
        }

    }
}
