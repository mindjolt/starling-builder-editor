/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.themes
{
    import feathers.skins.IStyleProvider;
    import feathers.skins.StyleNameFunctionStyleProvider;
    import feathers.skins.StyleProviderRegistry;
    import feathers.themes.*;

    public class UIEditorTheme extends StyleNameFunctionTheme
    {
        private var _configGameTheme:Boolean;

        private var _themeMediator:IUIEditorThemeMediator;

        private static var _sharedRegistry:StyleProviderRegistry;

        public function UIEditorTheme(configGameTheme:Boolean = true, themeMediator:IUIEditorThemeMediator = null)
        {
            super();

            if (!_sharedRegistry) _sharedRegistry = new StyleProviderRegistry(true, styleProviderFactory);

            this._registry = _sharedRegistry;

            _configGameTheme = configGameTheme;
            _themeMediator = themeMediator;
        }

        protected function styleProviderFactory():IStyleProvider
        {
            return new UIEditorStyleProvider();
        }

        override public function getStyleProviderForClass(type:Class):StyleNameFunctionStyleProvider
        {
            var res:UIEditorStyleProvider = UIEditorStyleProvider(this._registry.getStyleProvider(type));
            res.configGameTheme = _configGameTheme;
            res.themeMediator = _themeMediator;
            return res;
        }
    }
}
