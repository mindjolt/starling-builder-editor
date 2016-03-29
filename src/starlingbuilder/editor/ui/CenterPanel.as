/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.ui
{
    import feathers.dragDrop.DragData;
    import feathers.dragDrop.DragDropManager;
    import feathers.dragDrop.IDropTarget;
    import feathers.events.DragDropEvent;

    import flash.geom.Point;

    import starlingbuilder.editor.UIEditorApp;
    import starlingbuilder.editor.UIEditorScreen;
    import starlingbuilder.editor.controller.DocumentManager;

    import feathers.controls.LayoutGroup;
    import feathers.controls.ScrollContainer;

    import starling.display.Sprite;
    import starling.events.Event;
    import starling.utils.AssetManager;

    import starlingbuilder.editor.helper.DragToCanvasHelper;

    public class CenterPanel extends ScrollContainer implements IDropTarget
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

            addEventListener(DragDropEvent.DRAG_ENTER, onDragEnter);
            addEventListener(DragDropEvent.DRAG_MOVE, onDragMove);
            addEventListener(DragDropEvent.DRAG_EXIT, onDragExit);
            addEventListener(DragDropEvent.DRAG_DROP, onDragDrop);
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

        private function onDragEnter(event:DragDropEvent, dragData:DragData):void
        {
            DragDropManager.acceptDrag(this);
        }

        private function onDragMove(event:DragDropEvent, dragData:DragData):void
        {


        }

        private function onDragDrop(event:DragDropEvent, dragData:DragData):void
        {
            var label:String = dragData.getDataForFormat(DragToCanvasHelper.LABEL);
            var tab:String = dragData.getDataForFormat(DragToCanvasHelper.TAB);

            var tabPanel:Object;

            var leftPanel:LeftPanel = UIEditorScreen.instance.leftPanel;

            switch (tab)
            {
                case DragToCanvasHelper.ASSET_TAB:
                    tabPanel = leftPanel.assetTab;
                    break;
                case DragToCanvasHelper.TEXT_TAB:
                    tabPanel = leftPanel.textTab;
                    break;
                case DragToCanvasHelper.CONTAINER_TAB:
                    tabPanel = leftPanel.containerTab;
                    break;
                case DragToCanvasHelper.FEATHERS_TAB:
                    tabPanel = leftPanel.feathersTab;
                    break;
            }

            tabPanel.create(label, new Point(Math.round(event.localX), Math.round(event.localY)));

            trace(label, tab, event.localX, event.localY);
        }

        private function onDragExit(event:DragDropEvent, dragData:DragData):void
        {
        }

    }
}
