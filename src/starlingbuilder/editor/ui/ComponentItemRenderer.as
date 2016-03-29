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
    import feathers.controls.text.TextBlockTextRenderer;
    import feathers.core.ITextRenderer;
    import feathers.dragDrop.IDragSource;

    import starlingbuilder.editor.helper.DragToCanvasHelper;

    public class ComponentItemRenderer extends DefaultListItemRenderer implements IDragSource
    {
        public function ComponentItemRenderer(name:String = null)
        {
            super();

            _labelFactory = function():ITextRenderer
            {
                var textRenderer:TextBlockTextRenderer = new TextBlockTextRenderer();
                textRenderer.wordWrap = true;
                return textRenderer;
            };

            this.height = 50;

            this.name = name;
            new DragToCanvasHelper(this);
        }
    }
}
