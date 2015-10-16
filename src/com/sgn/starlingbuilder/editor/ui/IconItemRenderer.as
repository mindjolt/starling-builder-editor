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

    import feathers.controls.renderers.DefaultListItemRenderer;

    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.textures.Texture;

    public class IconItemRenderer extends DefaultListItemRenderer
    {
        private var _image:Image;

        public function IconItemRenderer()
        {
            super();
            _iconFunction = createIcon;
        }



        private function createIcon(item:Object):DisplayObject
        {
            var texture:Texture = UIEditorApp.instance.assetManager.getTexture(item.label);

            if (_image == null)
            {
                _image = new Image(texture);
            }
            else
            {
                _image.texture = texture;
                _image.readjustSize();
            }

            _image.width = 50;
            _image.height = 50;
            return _image;
        }
    }
}
