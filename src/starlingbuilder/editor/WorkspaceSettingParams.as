/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor
{
    public class WorkspaceSettingParams
    {
        public static const PARAMS:Array = [
            {name:"assetPath", label:"Asset Path(s)", component:"addPath"},
            {name:"libraryPath", label:"Library Path", component:"editPath"},
            {name:"localizationPath", label:"Localization Path", component:"editPath"},
            {name:"backgroundPath", label:"Background Path", component:"editPath"},
            {name:"layoutPath", label:"Layout Path", component:"editPath"},
        ]
    }
}
