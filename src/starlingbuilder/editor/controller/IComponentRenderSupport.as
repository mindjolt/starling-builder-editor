/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.controller
{
    import flash.utils.Dictionary;

    import starlingbuilder.engine.IAssetMediator;
    import starlingbuilder.engine.IUIBuilder;

    public interface IComponentRenderSupport
    {
        function get assetMediator():IAssetMediator;

        function get extraParamsDict():Dictionary;

        function get uiBuilder():IUIBuilder;

        function setChanged():void;
    }
}
