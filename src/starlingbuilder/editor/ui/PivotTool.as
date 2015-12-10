/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.ui
{
    import starlingbuilder.editor.UIEditorApp;
    import starlingbuilder.editor.controller.DocumentManager;
    import starlingbuilder.editor.history.MovePivotOperation;
    import starlingbuilder.engine.util.DisplayObjectUtil;
    import starlingbuilder.util.feathers.FeathersUIUtil;

    import feathers.controls.Button;
    import feathers.controls.LayoutGroup;
    import feathers.controls.PickerList;
    import feathers.data.ListCollection;

    import flash.geom.Point;

    import starling.display.DisplayObject;
    import starling.events.Event;

    public class PivotTool extends LayoutGroup
    {
        public static const LEFT:String = "left";
        public static const CENTER:String = "center";
        public static const RIGHT:String = "right";
        public static const TOP:String = "top";
        public static const BOTTOM:String = "bottom";


        private var _hAlighPickerList:PickerList;
        private var _vAlighPickerList:PickerList;
        private var _pivotButton:Button;

        private var _documentManager:DocumentManager;

        public function PivotTool()
        {
            super();
            _documentManager = UIEditorApp.instance.documentManager;
            initPivotTools();
        }

        private function initPivotTools():void
        {
            var layoutGroup:LayoutGroup = FeathersUIUtil.layoutGroupWithHorizontalLayout();

            _hAlighPickerList = new PickerList();
            _hAlighPickerList.dataProvider = new ListCollection([LEFT, CENTER, RIGHT]);
            _hAlighPickerList.selectedIndex = 1;

            _vAlighPickerList = new PickerList();
            _vAlighPickerList.dataProvider = new ListCollection([TOP, CENTER, BOTTOM]);
            _vAlighPickerList.selectedIndex = 1;

            _pivotButton = FeathersUIUtil.buttonWithLabel("set pivot to", onPivotButton);

            layoutGroup.addChild(_pivotButton);
            layoutGroup.addChild(_hAlighPickerList);
            layoutGroup.addChild(_vAlighPickerList);

            addChild(layoutGroup);
        }

        private function onPivotButton(event:Event):void
        {
            var obj:DisplayObject = _documentManager.selectedObject;

            if (obj)
            {
                var oldValue:Point = new Point(obj.pivotX, obj.pivotY);

                DisplayObjectUtil.movePivotToAlign(obj, String(_hAlighPickerList.selectedItem), String(_vAlighPickerList.selectedItem));
                _documentManager.setChanged();

                var newValue:Point = new Point(obj.pivotX, obj.pivotY);
                _documentManager.historyManager.add(new MovePivotOperation(obj, oldValue, newValue));
            }
        }
    }
}
