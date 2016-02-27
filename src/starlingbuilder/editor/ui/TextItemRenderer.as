/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.ui
{
    import feathers.controls.renderers.DefaultListItemRenderer;

    import starling.display.DisplayObject;
    import starling.text.TextField;
    import starling.utils.Color;

    public class TextItemRenderer extends DefaultListItemRenderer
    {
        private var _text:TextField;

        public function TextItemRenderer()
        {
            super();
            _iconFunction = createIcon;
        }

        private function createIcon(item:Object):DisplayObject
        {
            if (_text == null)
            {
                _text = new TextField(50, 50, TextTab.DEFAULT_TEXT);
            }

            _text.format.color = Color.WHITE;
            _text.format.font = item.label;
            return _text;
        }
    }
}
