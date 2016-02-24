/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor
{
    import starlingbuilder.util.persist.DefaultPersistableObject;

    public class Setting extends DefaultPersistableObject
    {
        public var workspaceUrl:String;

        public var rootContainerClass:String = "starling.display.Sprite";

        public var defaultCanvasWidth:int = 640;

        public var defaultCanvasHeight:int = 960;

        public var prettyJSON:Boolean = true;
    }
}
