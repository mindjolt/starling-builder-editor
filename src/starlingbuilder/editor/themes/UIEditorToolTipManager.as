/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.themes
{
    import feathers.core.DefaultToolTipManager;

    import starling.display.DisplayObjectContainer;

    public class UIEditorToolTipManager extends DefaultToolTipManager
    {
        public function UIEditorToolTipManager(root:DisplayObjectContainer)
        {
            super(root);
            offsetX = 10;
            offsetY = 35;
        }
    }
}
