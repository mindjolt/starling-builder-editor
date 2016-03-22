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

    public class ComponentRenderSupport implements IComponentRenderSupport
    {
        public static var support:IComponentRenderSupport;

        private var _assetMediator:IAssetMediator;
        private var _extraParamsDict:Dictionary;
        private var _uiBuilder:IUIBuilder;

        public function ComponentRenderSupport(assetMediator:IAssetMediator, extraParamsDict:Dictionary, uiBuilder:IUIBuilder)
        {
            _assetMediator = assetMediator;
            _extraParamsDict = extraParamsDict;
            _uiBuilder = uiBuilder;
        }

        public function get assetMediator():IAssetMediator
        {
            return _assetMediator;
        }

        public function get extraParamsDict():Dictionary
        {
            return _extraParamsDict;
        }

        public function get uiBuilder():IUIBuilder
        {
            return _uiBuilder;
        }

        public function setChanged():void
        {

        }
    }
}
