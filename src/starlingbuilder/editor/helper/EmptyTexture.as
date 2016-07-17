/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.helper
{
    import starling.textures.Texture;

    public class EmptyTexture
    {
        public static const NAME:String = "@emptyTexture@";

        private static var _texture:Texture;

        public static function get texture():Texture
        {
            if (!_texture) _texture = Texture.empty(1, 1);
            return _texture;
        }
    }
}
