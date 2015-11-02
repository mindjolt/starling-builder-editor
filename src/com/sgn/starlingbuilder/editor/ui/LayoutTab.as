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
    import com.sgn.starlingbuilder.editor.events.DocumentEventType;

    import feathers.controls.Button;
    import feathers.controls.ButtonGroup;
    import feathers.controls.LayoutGroup;
    import feathers.controls.List;
    import feathers.controls.renderers.IListItemRenderer;
    import feathers.data.ListCollection;
    import feathers.events.FeathersEventType;
    import feathers.layout.AnchorLayout;
    import feathers.layout.AnchorLayoutData;

    import flash.ui.Keyboard;

    import starling.core.Starling;

    import starling.display.DisplayObject;
    import starling.events.Event;
    import starling.events.KeyboardEvent;

    public class LayoutTab extends LayoutGroup
    {
        private var _list:List;

        private var _documentManager:DocumentManager;

        private var _buttonGroup1:ButtonGroup;
        private var _buttonGroup2:ButtonGroup;
        private var _buttonGroup3:ButtonGroup;

        public function LayoutTab()
        {
            var anchorLayoutData:AnchorLayoutData = new AnchorLayoutData();
            anchorLayoutData.bottom = 0;
            anchorLayoutData.top = 25;
            layoutData = anchorLayoutData;

            layout = new AnchorLayout();

            _documentManager = UIEditorApp.instance.documentManager;

            _buttonGroup3 = createToolButtons(createTextButtons3());
            _buttonGroup2 = createToolButtons(createTextButtons2(), _buttonGroup3);
            _buttonGroup1 = createToolButtons(createTextButtons(), _buttonGroup2);

            createList();

            _documentManager.addEventListener(DocumentEventType.CHANGE, onChange);

            registerMenuActions();
        }

        private function createList():void
        {
            _list = new List();
            _list.width = 280;
            _list.height = 400;

            _list.itemRendererFactory = function():IListItemRenderer
            {
                return new LayoutItemRenderer();
            }

            _list.addEventListener(Event.CHANGE, onListChange);
            _list.addEventListener(FeathersEventType.FOCUS_IN, onFocusIn);
            _list.addEventListener(FeathersEventType.FOCUS_OUT, onFocusOut);

            var anchorLayoutData:AnchorLayoutData = new AnchorLayoutData();
            anchorLayoutData.top = 0
            anchorLayoutData.bottom = 0;
            anchorLayoutData.bottomAnchorDisplayObject = _buttonGroup1;
            _list.layoutData = anchorLayoutData;

            addChild(_list);
        }



        private function onListChange(event:Event):void
        {
            if (_list.selectedIndex >= 0)
            {
                _documentManager.selectObjectAtIndex(_list.selectedIndex);
            }
        }


        private function onChange(event:Event):void
        {
            _list.dataProvider = null;
            _list.dataProvider = _documentManager.dataProvider;

            var index:int = _documentManager.selectedIndex;

            if (index >= 0)
            {
                _list.selectedIndex = index;
                _list.scrollToDisplayIndex(index);
            }


        }

        private function createToolButtons(buttons:Array, anchorDisplayObject:DisplayObject = null):ButtonGroup
        {
            var group:ButtonGroup = new ButtonGroup();
            group.paddingTop = 5;
            group.paddingBottom = 5;
            group.direction = ButtonGroup.DIRECTION_HORIZONTAL;
            group.maxWidth = 200;
            group.dataProvider = new ListCollection(buttons);

            var layoutData:AnchorLayoutData = new AnchorLayoutData();
            layoutData.left = 0;
            layoutData.right = 0;
            layoutData.bottom = 0;

            if (anchorDisplayObject)
            {
                layoutData.bottomAnchorDisplayObject = anchorDisplayObject;
            }

            group.layoutData = layoutData;

            addChild(group);

            return group;
        }



        private function createTextButtons():Array
        {
            return [
                {label:"up", triggered:onButton},
                {label:"down", triggered:onButton},
                {label:"delete", triggered:onButton},

            ];
        }

        private function createTextButtons2():Array
        {
            return [
                {label:"cut", triggered:onButton},
                {label:"copy", triggered:onButton},
                {label:"paste", triggered:onButton},
            ];
        }

        private function createTextButtons3():Array
        {
            return [
                {label:"duplicate", triggered:onButton},
            ]
        }

        private function onButton(event:Event):void
        {
            var button:Button = event.target as Button;
            switch (button.label)
            {
                case "up":
                    moveUp();
                    break;
                case "down":
                    moveDown();
                    break;
                case "delete":
                    remove();
                    break;
                case "deselect":
                    deselect();
                    break;
                case "cut":
                    cut();
                    break;
                case "copy":
                    copy();
                    break;
                case "paste":
                    paste();
                    break;
                case "duplicate":
                    duplicate();
                    break;
            }
        }

        private function cut():void
        {
            _documentManager.cut();
        }

        private function copy():void
        {
            _documentManager.copy();
        }

        private function paste():void
        {
            _documentManager.paste();
        }

        private function duplicate():void
        {
            _documentManager.duplicate();
        }

        private function deselect():void
        {
            _list.selectedIndex = -1;
            _documentManager.selectObject(null);
        }

        private function moveUp():void
        {
            _documentManager.moveUp();
        }

        private function moveDown():void
        {
            _documentManager.moveDown();
        }

        private function remove():void
        {
            _documentManager.remove();
        }

        private function registerMenuActions():void
        {
            var menu:MainMenu = MainMenu.instance;

            menu.registerAction(MainMenu.CUT, cut);
            menu.registerAction(MainMenu.COPY, copy);
            menu.registerAction(MainMenu.PASTE, paste);
            menu.registerAction(MainMenu.DUPLICATE, duplicate);

            menu.registerAction(MainMenu.DESELECT, deselect);

            menu.registerAction(MainMenu.MOVE_UP, moveUp);
            menu.registerAction(MainMenu.MOVE_DOWN, moveDown);

            Starling.current.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
        }

        private function onKeyUp(event:KeyboardEvent):void
        {
            switch (event.keyCode)
            {
                case Keyboard.BACKSPACE:
                case Keyboard.DELETE:
                    if (_documentManager.hasFocus || _focus)
                        remove();
                    break;
            }
        }

        private var _focus:Boolean = false;

        protected function onFocusIn(event:Event):void
        {
            _focus = true;
        }

        protected function onFocusOut(event:Event):void
        {
            _focus = false;
        }
    }
}
