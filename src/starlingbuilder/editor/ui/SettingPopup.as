/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.ui
{
    import starlingbuilder.util.feathers.popup.InfoPopup;
    import starlingbuilder.util.persist.IPersistableObject;
    import starlingbuilder.util.ui.inspector.PropertyPanel;

    import feathers.controls.LayoutGroup;

    import starling.events.Event;

    public class SettingPopup extends InfoPopup
    {
        private var _propertyPanel:PropertyPanel;

        private var _setting:IPersistableObject;
        private var _params:Array;

        private var _oldSetting:Object;

        public function SettingPopup(title:String, setting:IPersistableObject, params:Array)
        {
            _setting = setting;
            _params = params;

            _oldSetting = _setting.save();

            _propertyPanel = new PropertyPanel(setting, params);

            super();

            this.title = title;
            buttons = ["OK", "Cancel"];

            addEventListener(Event.COMPLETE, onDialogComplete);
        }

        override protected function createContent(container:LayoutGroup):void
        {
            container.addChild(_propertyPanel);
        }

        private function onDialogComplete(event:Event):void
        {
            var index:int = int(event.data);

            if (index != 0)
            {
                _setting.load(_oldSetting);
            }

            _setting.persist();
            _setting.setChanged();
        }
    }
}
