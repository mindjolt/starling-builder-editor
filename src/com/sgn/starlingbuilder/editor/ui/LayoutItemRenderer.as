/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package com.sgn.starlingbuilder.editor.ui
{
    import com.sgn.starlingbuilder.editor.UIEditorApp;

    import feathers.controls.Check;
    import feathers.controls.LayoutGroup;
    import feathers.controls.renderers.DefaultListItemRenderer;
    import feathers.layout.VerticalLayout;

    import starling.display.DisplayObject;
    import starling.events.Event;

    public class LayoutItemRenderer extends DefaultListItemRenderer
    {
        private var _group:LayoutGroup;
        private var _hiddenCheck:Check;
        private var _lockCheck:Check;

        public function LayoutItemRenderer()
        {
            super();
            createIconGroup();
            _iconFunction = layoutIconFunction;
        }

        private function createIconGroup():void
        {
            _group = new LayoutGroup();
            _group.layout = new VerticalLayout();

            _hiddenCheck = new Check();
            _hiddenCheck.label = "hidden";

            _hiddenCheck.addEventListener(Event.CHANGE, function():void{
                _data.hidden = _hiddenCheck.isSelected;
                UIEditorApp.instance.documentManager.refresh();
            });
            _group.addChild(_hiddenCheck);

            _lockCheck = new Check();
            _lockCheck.label = "lock";
            _lockCheck.addEventListener(Event.CHANGE, function():void{
                _data.lock = _lockCheck.isSelected;
                UIEditorApp.instance.documentManager.refresh();
            });
            _group.addChild(_lockCheck);
        }

        private function layoutIconFunction(item:Object):DisplayObject
        {
            _hiddenCheck.isSelected = item.hidden;
            _lockCheck.isSelected = item.lock;
            return _group;
        }


    }
}
