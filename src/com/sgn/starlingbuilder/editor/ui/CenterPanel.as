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
    import com.sgn.starlingbuilder.editor.controller.DocumentManager;

    import feathers.controls.LayoutGroup;
    import feathers.controls.ScrollContainer;

    import starling.display.Sprite;
    import starling.events.Event;
    import com.sgn.starlingbuilder.editor.utils.AssetManager;

    public class CenterPanel extends ScrollContainer
    {
        private var _group:LayoutGroup;

        private var _container:Sprite;

        private var _documentManager:DocumentManager;

        private var _assetManager:AssetManager;

        public function CenterPanel()
        {
            _documentManager = UIEditorApp.instance.documentManager;
            _assetManager = UIEditorApp.instance.assetManager;

            _group = new LayoutGroup();

            addChild(_group);

            _container = new Sprite();
            _group.addChild(_container);

            _documentManager.container = _container;

            width = 670;
            height = 900;
        }

        override protected function focusInHandler(event:Event):void
        {
            super.focusInHandler(event);
            _documentManager.hasFocus = true;
        }

        override protected function focusOutHandler(event:Event):void
        {
            super.focusOutHandler(event);
            _documentManager.hasFocus = false;
        }

        override public function get isFocusEnabled():Boolean
        {
            return this._isEnabled && this._isFocusEnabled;
        }

        override public function dispose():void
        {
            _container.removeChildren(); //make sure DocumentManager component is not disposed
            super.dispose();
        }

    }
}
