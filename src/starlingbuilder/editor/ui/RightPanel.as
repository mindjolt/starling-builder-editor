/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.ui
{
    import feathers.layout.AnchorLayout;
    import feathers.layout.AnchorLayoutData;

    import starlingbuilder.editor.UIEditorApp;
    import starlingbuilder.editor.UIEditorScreen;
    import starlingbuilder.editor.controller.DocumentManager;
    import starlingbuilder.editor.events.DocumentEventType;
    import starlingbuilder.engine.util.ParamUtil;

    import feathers.controls.Label;
    import feathers.layout.VerticalLayout;

    import starling.events.Event;

    public class RightPanel extends TabPanel
    {
        private var _documentManager:DocumentManager;

        private var _label:Label;

        public function RightPanel()
        {
            super();

            _documentManager = UIEditorApp.instance.documentManager;
            _documentManager.addEventListener(DocumentEventType.CHANGE, onChange);

            this.layout = new AnchorLayout();

            _label = new Label();
            _label.y = 40;

            addChild(_label);

            createTabs([{"label":"properties"}, {"label":"custom"}], [new PropertyTab(), new CustomParamsTab()]);
        }

        private function onChange(event:Event):void
        {
            _label.text = ParamUtil.getClassName(_documentManager.selectedObject);
        }
    }
}
