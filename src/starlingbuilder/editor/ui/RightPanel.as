/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.ui
{
    import feathers.controls.LayoutGroup;
    import feathers.layout.AnchorLayout;
    import feathers.layout.AnchorLayoutData;
    import feathers.layout.HorizontalLayout;

    import starlingbuilder.editor.UIEditorApp;
    import starlingbuilder.editor.UIEditorScreen;
    import starlingbuilder.editor.controller.DocumentManager;
    import starlingbuilder.editor.data.TemplateData;
    import starlingbuilder.editor.data.TemplateData;
    import starlingbuilder.editor.events.DocumentEventType;
    import starlingbuilder.engine.util.ParamUtil;
    import starlingbuilder.engine.util.ParamUtil;

    import feathers.controls.Label;
    import feathers.layout.VerticalLayout;

    import starling.events.Event;

    import starlingbuilder.util.feathers.FeathersUIUtil;

    public class RightPanel extends TabPanel
    {
        private var _documentManager:DocumentManager;

        private var _label:Label;
        private var _helpButton:ComponentHelpButton;

        public function RightPanel()
        {
            super();

            _documentManager = UIEditorApp.instance.documentManager;
            _documentManager.addEventListener(DocumentEventType.CHANGE, onChange);

            this.layout = new AnchorLayout();

            _label = new Label();
            _helpButton = new ComponentHelpButton();

            var group:LayoutGroup = FeathersUIUtil.layoutGroupWithHorizontalLayout();
            group.y = 40;
            (group.layout as HorizontalLayout).verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
            group.addChild(_label);
            group.addChild(_helpButton);
            addChild(group);

            createTabs([{"label":"properties"}, {"label":"custom"}], [new PropertyTab(), new CustomParamsTab()]);
        }

        private function onChange(event:Event):void
        {
            var clsName:String = ParamUtil.getClassName(_documentManager.selectedObject);

            _label.text = clsName;

            var url:String = getDocuemntUrl(TemplateData.editor_template, clsName);

            if (url)
                _helpButton.url = url;
            else
                _helpButton.clsName = clsName;
        }

        private function getDocuemntUrl(template:Object, clsName:String):String
        {
            for each (var item:Object in template.supported_components)
            {
                if (item.cls == clsName)
                {
                    if (item.hasOwnProperty("document_url"))
                        return item.document_url;
                    else
                        return null;
                }
            }

            return null;
        }
    }
}
