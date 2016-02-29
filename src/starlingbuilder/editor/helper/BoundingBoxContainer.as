/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.helper
{
    import starling.display.DisplayObject;
    import starling.display.Sprite;

    import starlingbuilder.editor.UIEditorApp;

    import starlingbuilder.editor.controller.DocumentManager;

    public class BoundingBoxContainer extends Sprite
    {
        private var _documentManager:DocumentManager;
        private var _enable:Boolean = true;

        public function BoundingBoxContainer(documentManager:DocumentManager)
        {
            super();
            _documentManager = documentManager;
        }

        public function update(selectedObjects:Array):void
        {
            removeChildren(0, -1, true);

            for each (var obj:DisplayObject in selectedObjects)
            {
                var box:InteractiveBoundingBox = new InteractiveBoundingBox(_documentManager);
                box.enable = _enable;
                box.target = obj;
                addChild(box);
            }
        }

        public function reload():void
        {
            for (var i:int = 0; i < numChildren; ++i)
            {
                var box:InteractiveBoundingBox = getChildAt(i) as InteractiveBoundingBox;
                box.reload();
            }
        }

        public function set enable(value:Boolean):void
        {
            _enable = value;

            for (var i:int = 0; i < numChildren; ++i)
            {
                var box:InteractiveBoundingBox = getChildAt(i) as InteractiveBoundingBox;
                box.enable = _enable;
            }
        }

        public function get enable():Boolean
        {
            return _enable;
        }
    }
}
