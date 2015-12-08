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
    import com.sgn.starlingbuilder.editor.data.EmbeddedImages;

    import feathers.controls.Check;
    import feathers.controls.Label;
    import feathers.controls.LayoutGroup;
    import feathers.controls.renderers.DefaultListItemRenderer;
    import feathers.layout.HorizontalLayout;
    import feathers.layout.VerticalLayout;

    import starling.display.Button;

    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.events.Event;

    public class LayoutItemRenderer extends DefaultListItemRenderer
    {
        private var _group:LayoutGroup;
        private var _hiddenCheck:Check;
        private var _lockCheck:Check;

        private var _group2:LayoutGroup;
        private var _sign:Button;
        private var _nameLabel:Label;

        public function LayoutItemRenderer()
        {
            super();
            createIconGroup();
            _iconFunction = layoutIconFunction;
            _labelFunction = nameLabelFunction;
        }

        private function onTrigger(event:Event):void
        {
            var target:Button = event.target as Button;
            if (target.rotation == 0)
                target.rotation = Math.PI / 2;
            else
                target.rotation = 0;
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

            var layout:HorizontalLayout = new HorizontalLayout();
            layout.gap = 2;
            layout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
            _group2 = new LayoutGroup();
            _group2.layout = layout;

            _sign = new Button(EmbeddedImages.expand_sign_texture);
            _sign.alignPivot();
            //_sign.addEventListener(Event.TRIGGERED, onTrigger);

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
            _sign.rotation = Math.PI / 2;

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


    }
}
