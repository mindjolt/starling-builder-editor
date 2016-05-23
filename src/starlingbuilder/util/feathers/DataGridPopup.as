/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.util.feathers
{
    import starlingbuilder.util.feathers.popup.BasePopupDev;

    import feathers.controls.Button;
    import feathers.controls.ScrollContainer;
    import feathers.core.PopUpManager;

    import starling.events.Event;

    public class DataGridPopup extends BasePopupDev
    {
        private var _data:Array;

        private var _container:ScrollContainer;

        private var _okButton:Button;

        public function DataGridPopup(data:Array)
        {
            super();

            _data = data;

            width = 400;
            height = 400;

            _container = FeathersUIUtil.scrollContainerWithVerticalLayout();
            _container.width = width;
            _container.height = height;

            var dataGrid:DataGrid;

            dataGrid = new DataGrid();
            dataGrid.data = _data;

            _container.addChild(dataGrid);

            _okButton = new Button();
            _okButton.label = "OK";
            _okButton.addEventListener(Event.TRIGGERED, onOK);

            _container.addChild(_okButton);

            addChild(_container);
        }

        private function onOK(event:Event):void
        {
            _okButton.removeEventListener(Event.TRIGGERED, onOK);

            PopUpManager.removePopUp(this, true);
        }
    }
}
