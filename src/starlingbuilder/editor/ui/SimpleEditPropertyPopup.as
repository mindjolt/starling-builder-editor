/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.ui
{
    import starlingbuilder.editor.data.TemplateData;
    import starlingbuilder.engine.util.ParamUtil;
    import starlingbuilder.util.feathers.popup.InfoPopup;
    import starlingbuilder.util.ui.inspector.PropertyPanel;

    import feathers.controls.LayoutGroup;
    import feathers.controls.PickerList;
    import feathers.data.ListCollection;
    import feathers.layout.VerticalLayout;

    import starling.events.Event;

    import starlingbuilder.util.ui.inspector.UIMapperEventType;

    public class SimpleEditPropertyPopup extends InfoPopup
    {
        private var _propertyPanel:PropertyPanel;
        private var _target:Object;
        private var _params:Array;
        private var _onUpdate:Function;
        private var _onComplete:Function;

        public function SimpleEditPropertyPopup(target:Object, params:Array, onUpdate:Function, onComplete:Function)
        {
            _target = target;
            _params = params;
            _onUpdate = onUpdate;
            _onComplete = onComplete;

            super();

            title = "Edit Property";
            buttons = ["OK", "Cancel"];

            addEventListener(Event.COMPLETE, onDialogComplete);
        }

        override protected function createContent(container:LayoutGroup):void
        {
            container.layout = new VerticalLayout();

            _propertyPanel = new PropertyPanel(_target, _params);
            PropertyPanel.globalDispatcher.addEventListener(UIMapperEventType.PROPERTY_CHANGE, onPropertyChange);

            addChild(_propertyPanel);
        }

        private function onDialogComplete(event:Event):void
        {
            var index:int = int(event.data);

            if (index == 0)
            {
                if (_onComplete) _onComplete();
            }
        }

        private function onPropertyChange(event:Event):void
        {
            if (event.data.target === _target)
            {
                if (_onUpdate) _onUpdate();
            }
        }

        override public function dispose():void
        {
            removeEventListener(Event.COMPLETE, onDialogComplete);
            PropertyPanel.globalDispatcher.removeEventListener(UIMapperEventType.PROPERTY_CHANGE, onPropertyChange);

            super.dispose();
        }
    }
}
