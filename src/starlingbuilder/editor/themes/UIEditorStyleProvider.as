/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.themes
{
    import feathers.core.IFeathersControl;
    import feathers.skins.IStyleProvider;
    import feathers.skins.StyleNameFunctionStyleProvider;

    public class UIEditorStyleProvider extends StyleNameFunctionStyleProvider implements IStyleProvider
    {

        private var _gameStyleProvider:ExtendedStyleNameFunctionStyleProvider;
        private var _editorStyleProvider:ExtendedStyleNameFunctionStyleProvider;

        private var _configGameTheme:Boolean;

        private var _themeMediator:IUIEditorThemeMediator;

        public function UIEditorStyleProvider()
        {
            super();

            _gameStyleProvider = new ExtendedStyleNameFunctionStyleProvider();
            _editorStyleProvider = new ExtendedStyleNameFunctionStyleProvider();
        }

        public function set configGameTheme(value:Boolean):void
        {
            _configGameTheme = value;
        }


        override public function get defaultStyleFunction():Function
        {
            if (_configGameTheme)
            {
                return _gameStyleProvider.defaultStyleFunction;
            }
            else
            {
                return _editorStyleProvider.defaultStyleFunction;
            }
        }

        /**
         * @private
         */
        override public function set defaultStyleFunction(value:Function):void
        {
            if (_configGameTheme)
            {
                _gameStyleProvider.defaultStyleFunction = value;
            }
            else
            {
                _editorStyleProvider.defaultStyleFunction = value;
            }
        }



        override public function setFunctionForStyleName(styleName:String, styleFunction:Function):void
        {
            if (_configGameTheme)
            {
                _gameStyleProvider.setFunctionForStyleName(styleName, styleFunction);
            }
            else
            {
                _editorStyleProvider.setFunctionForStyleName(styleName, styleFunction);
            }
        }

        override public function applyStyles(target:IFeathersControl):void
        {
            if (useGameTheme(target))
            {
                return _gameStyleProvider.applyStyles(target);
            }
            else
            {
                return _editorStyleProvider.applyStyles(target);
            }
        }

        private function useGameTheme(target:IFeathersControl):Boolean
        {
            if (_themeMediator)
            {
                return _themeMediator.useGameTheme(target);
            }
            else
            {
                return false;
            }
        }

        public function get themeMediator():IUIEditorThemeMediator
        {
            return _themeMediator;
        }

        public function set themeMediator(value:IUIEditorThemeMediator):void
        {
            _themeMediator = value;
        }

        public function get styleNameMap():Object
        {
            return _gameStyleProvider.styleNameMap;
        }
    }
}
