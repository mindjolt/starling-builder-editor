/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.upgrade
{
    public class LayoutConverterV1 extends AbstractLayoutConverter
    {
        override public function getCurrentVersion():String
        {
            return "1.0";
        }

        override public function getUpgradePolicy(data:Object):String
        {
            data = JSON.parse(data as String);

            var majorVersion:String = data.version.charAt(0);

            if (majorVersion == "1")
                return LayoutUpgradePolicy.NO_UPGRADE;
            else
                return LayoutUpgradePolicy.CANNOT_UPGRADE;
        }
    }
}
