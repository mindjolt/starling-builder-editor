/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.themes
{
    import feathers.skins.StyleNameFunctionStyleProvider;

    public class ExtendedStyleNameFunctionStyleProvider extends StyleNameFunctionStyleProvider
    {
        public function ExtendedStyleNameFunctionStyleProvider(styleFunction:Function = null)
        {
            super(styleFunction);
        }

        public function get styleNameMap():Object
        {
            return _styleNameMap;
        }


    }
}
