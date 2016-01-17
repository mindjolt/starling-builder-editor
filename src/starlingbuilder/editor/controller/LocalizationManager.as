/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.controller
{
    import starlingbuilder.editor.UIEditorApp;
    import starlingbuilder.editor.UIEditorScreen;
    import starlingbuilder.editor.localization.DefaultLocalizationFileWrapper;
    import starlingbuilder.editor.ui.MainMenu;
    import starlingbuilder.editor.ui.MainMenu;
    import starlingbuilder.engine.localization.ILocalization;

    import starling.events.Event;

    public class LocalizationManager
    {
        public static const DEFAULT_LOCALE:String = "en_US";

        private var _localization:ILocalization;
        private var _localizationFileWrapper:DefaultLocalizationFileWrapper;

        public function LocalizationManager()
        {
            _localizationFileWrapper = new DefaultLocalizationFileWrapper(UIEditorScreen.instance.workspaceDir);

            _localization = _localizationFileWrapper.localization;

            initMenu();
        }

        private function initMenu():void
        {
            var array:Array = [
            ];

            var locale:String;


            if (_localization)
            {
                var locales:Array = _localization.getLocales();

                sortLocales(locales);

                for each (locale in locales)
                {
                    array.push({"label":locale});
                }
            }

            var menu:MainMenu = MainMenu.instance;

            menu.createSubMenu(array, MainMenu.LOCALIZATION);

            if (_localization && array.length)
            {
                for each (locale in locales)
                {
                    menu.registerAction(locale, onLocale);
                }

                var currentLocale:String = locales[0];

                menu.getItemByName(currentLocale).checked = true;
                _localization.locale = currentLocale;
            }

            menu.createSubMenu(MainMenu.HELP_MENU, MainMenu.HELP);
        }

        private function sortLocales(locales:Array):void
        {
            //Make sure default locales are on the top
            locales.sort(function(a:String, b:String):int{
                if (a == DEFAULT_LOCALE)
                {
                    return -1;
                }
                else if (b == DEFAULT_LOCALE)
                {
                    return 1;
                }
                else
                {
                    return a < b ? -1 : 1;
                }
            })
        }

        public function onLocale(event:Event):void
        {
            var locale:String = event.type;

            var menu:MainMenu = MainMenu.instance;

            for each (var l:String in _localization.getLocales())
            {
                menu.getItemByName(l).checked = false;
            }

            menu.getItemByName(locale).checked = true;

            _localization.locale = locale;

            var documentManager:DocumentManager = UIEditorApp.instance.documentManager;

            documentManager.uiBuilder.localizeTexts(documentManager.root, documentManager.extraParamsDict);
        }

        public function get localization():ILocalization
        {
            return _localization;
        }

    }
}
