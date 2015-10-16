/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package com.sgn.starlingbuilder.editor.themes
{
    import feathers.core.IFeathersControl;

    public interface IUIEditorThemeMediator
    {
        function useGameTheme(target:IFeathersControl):Boolean;
    }
}
