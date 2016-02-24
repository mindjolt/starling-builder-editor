/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor
{
    public class SettingParams
    {
        public static const PARAMS:Array = [
            {"name":"rootContainerClass", "label":"Root Container Class", "component":"pickerList", options:["starling.display.Sprite", "feathers.controls.LayoutGroup"]},
            {"name":"defaultCanvasWidth", "label":"Default Canvas Width"},
            {"name":"defaultCanvasHeight", "label":"Default Canvas Height"},
            {"name":"prettyJSON", "label":"Pretty JSON", "component":"check"}
        ]
    }
}
