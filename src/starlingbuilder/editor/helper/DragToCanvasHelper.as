/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.helper
{
    import feathers.controls.renderers.BaseDefaultItemRenderer;
    import feathers.dragDrop.DragData;
    import feathers.dragDrop.DragDropManager;
    import feathers.dragDrop.IDragSource;

    import flash.utils.getDefinitionByName;

    import starling.display.DisplayObject;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;

    import starlingbuilder.engine.util.ParamUtil;

    public class DragToCanvasHelper
    {
        public static const ASSET_TAB:String = "asset";
        public static const TEXT_TAB:String = "text";
        public static const CONTAINER_TAB:String = "container";
        public static const FEATHERS_TAB:String = "feathers";

        public static const LABEL:String = "label";
        public static const TAB:String = "tab";

        private var _renderer:BaseDefaultItemRenderer;

        public function DragToCanvasHelper(renderer:BaseDefaultItemRenderer):void
        {
            _renderer = renderer;

            _renderer.addEventListener(TouchEvent.TOUCH, onTouch);
        }

        private function onTouch(event:TouchEvent):void
        {
            if (DragDropManager.isDragging)
            {
                return;
            }

            var touch:Touch = event.getTouch(_renderer);
            if (touch && touch.phase == TouchPhase.MOVED)
            {
                var cls:Class = getDefinitionByName(ParamUtil.getClassName(_renderer)) as Class;

                var clone:Object = new cls();
                clone.width = _renderer.width;
                clone.height = _renderer.height;
                clone.styleName = _renderer.styleName;
                clone.data = _renderer.data;
                clone.owner = _renderer["owner"];
                clone.alpha = 0.5;

                var dragData:DragData = new DragData();
                dragData.setDataForFormat(TAB, _renderer.name);
                dragData.setDataForFormat(LABEL, _renderer.data.label);

                DragDropManager.startDrag(_renderer as IDragSource, touch, dragData, clone as DisplayObject, 0, 0);
            }
        }


    }
}
