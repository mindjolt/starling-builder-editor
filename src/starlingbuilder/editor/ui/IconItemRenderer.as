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
    import feathers.controls.renderers.DefaultListItemRenderer;

    import flash.geom.Rectangle;

    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.textures.Texture;
    import starling.utils.RectangleUtil;
    import starling.utils.ScaleMode;

    import starlingbuilder.editor.UIEditorApp;

    public class IconItemRenderer extends DefaultListItemRenderer
    {
        private static var fitRect:Rectangle = new Rectangle();
        private static var srcRect:Rectangle = new Rectangle();
        private static var dstRect:Rectangle = new Rectangle();

        private var _defaultSize:int;

        private var _container:LayoutGroup;
        private var _image:Image;

        public function IconItemRenderer(defaultSize:int = 50)
        {
            super();
            _defaultSize = defaultSize;
            _iconFunction = createIcon;
        }

        private function createIcon(item:Object):DisplayObject
        {
            var texture:Texture = UIEditorApp.instance.assetManager.getTexture(item.label);

            if (_image == null)
            {
                _container = new LayoutGroup();
                _container.width = _container.height = _defaultSize;

                _image = new Image(texture);
                _container.addChild(_image);
            }
            else
            {
                _image.texture = texture;
                _image.readjustSize();
            }

            srcRect.width = _image.width;
            srcRect.height = _image.height;
            fitRect.width = _container.width;
            fitRect.height = _container.height;
            RectangleUtil.fit(srcRect, fitRect, ScaleMode.SHOW_ALL, false, dstRect);

            _image.x = dstRect.x;
            _image.y = dstRect.y;
            _image.width = dstRect.width;
            _image.height = dstRect.height;
            return _container;
        }
    }
}
