/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.data
{
    import starling.textures.Texture;

    public class EmbeddedImages
    {
        [Embed(source="expand_sign.png")]
        public static const expand_sign:Class;

        public static var expand_sign_texture:Texture = Texture.fromBitmap(new expand_sign());
    }
}
