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
    import com.sgn.starlingbuilder.editor.UIEditorScreen;
    import com.sgn.starlingbuilder.editor.controller.DocumentManager;
    import com.sgn.starlingbuilder.editor.events.DocumentEventType;
    import com.sgn.starlingbuilder.engine.util.ParamUtil;

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

            var layout:VerticalLayout = new VerticalLayout();
            layout.gap = 10;
            this.layout = layout;

            _label = new Label();
            addChild(_label);

            createTabs([{"label":"properties"}, {"label":"custom"}], [new PropertyTab(), new CustomParamsTab()]);
        }

        private function onChange(event:Event):void
        {
            if (UIEditorScreen.instance.leftPanel.currentTab is BackgroundTab)
            {
                _label.text = ParamUtil.getClassName(_documentManager.background);
            }
            else
            {
                _label.text = ParamUtil.getClassName(_documentManager.selectedObject);
            }

        }
    }
}
