/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.ui
{
    import feathers.layout.VerticalLayout;

    import flash.desktop.NativeApplication;

    import starlingbuilder.editor.UIEditorApp;
    import starlingbuilder.editor.controller.DocumentManager;
    import starlingbuilder.editor.events.DocumentEventType;

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

    import starlingbuilder.util.feathers.FeathersUIUtil;

    public class LayoutTab extends LayoutGroup
    {
        private var _list:List;

        private var _documentManager:DocumentManager;

        private var _buttonGroup:ButtonGroup;
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
            _buttonGroup1 = createToolButtons(createTextButtons1(), _buttonGroup2);
            _buttonGroup = createToolButtons(createTextButtons(), _buttonGroup1);

            createList();

            _documentManager.addEventListener(DocumentEventType.CHANGE, onChange);

            registerMenuActions();
        }

        private function createList():void
        {
            _list = new List();
            _list.allowMultipleSelection = true;
            _list.isFocusEnabled = false;
            _list.width = 330;
            _list.height = 400;

            _list.itemRendererFactory = function():IListItemRenderer
            {
                return new LayoutItemRenderer();
            }

            _list.addEventListener(Event.CHANGE, onListChange);

            var layout:VerticalLayout = new VerticalLayout();
            layout.useVirtualLayout = true;
            layout.padding = 0;
            layout.gap = 1;
            layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
            layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
            _list.layout = layout;

            var anchorLayoutData:AnchorLayoutData = new AnchorLayoutData();
            anchorLayoutData.top = 0
            anchorLayoutData.bottom = 0;
            anchorLayoutData.bottomAnchorDisplayObject = _buttonGroup;
            _list.layoutData = anchorLayoutData;

            addChild(_list);
        }



        private function onListChange(event:Event):void
        {
            if (_list.selectedIndices.length > 0)
            {
                _documentManager.selectObjectAtIndices(_list.selectedIndices);
            }
        }


        private function onChange(event:Event):void
        {
            var oldIndex:int = _list.selectedIndex;
            var position:Number = _list.verticalScrollPosition;

            _list.dataProvider = null;
            _list.dataProvider = _documentManager.dataProvider;

            var indices:Vector.<int> = _documentManager.selectedIndices;

            if (indices.length > 0)
            {
                _list.selectedIndices = indices;

                if (oldIndex == indices[0])
                    _list.verticalScrollPosition = position;
                else
                    _list.scrollToDisplayIndex(indices[0]);
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
                {label:"collapse all", triggered:onButton},
                {label:"expand all", triggered:onButton},
            ];
        }

        private function createTextButtons1():Array
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
                case "collapse all":
                    _documentManager.collapseAll();
                    break;
                case "expand all":
                    _documentManager.expandAll();
                    break;
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
            if (_documentManager.hasFocus)
                _documentManager.cut();
            else
                NativeApplication.nativeApplication.cut();
        }

        private function copy():void
        {
            if (_documentManager.hasFocus)
                _documentManager.copy();
            else
                NativeApplication.nativeApplication.copy();
        }

        private function paste():void
        {
            if (_documentManager.hasFocus)
                _documentManager.paste();
            else
                NativeApplication.nativeApplication.paste();
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
                    if (_documentManager.hasFocus)
                        remove();
                    break;
            }
        }
    }
}
