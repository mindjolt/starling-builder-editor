/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package com.sgn.starlingbuilder.editor.ui
{
    import com.sgn.starlingbuilder.editor.data.TemplateData;

    public class FeathersTab extends ContainerTab
    {
        public function FeathersTab()
        {
            super();
        }

        override protected function createPickerList():void
        {
            _supportedTypes = TemplateData.getSupportedComponent("feathers");
        }
    }
}
