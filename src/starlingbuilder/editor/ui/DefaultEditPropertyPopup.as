/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.ui
{
    import starlingbuilder.editor.controller.ComponentRenderSupport;

    import starlingbuilder.editor.data.TemplateData;
    import starlingbuilder.editor.helper.EmptyTexture;
    import starlingbuilder.editor.helper.FontHelper;
    import starlingbuilder.editor.helper.UIComponentHelper;
    import starlingbuilder.engine.util.ParamUtil;
    import starlingbuilder.util.feathers.popup.InfoPopup;
    import starlingbuilder.util.ui.inspector.PropertyPanel;

    import feathers.controls.LayoutGroup;
    import feathers.controls.PickerList;
    import feathers.data.ListCollection;
    import feathers.layout.VerticalLayout;

    import starling.events.Event;

    import starlingbuilder.util.ui.inspector.UIMapperUtil;

    public class DefaultEditPropertyPopup extends AbstractPropertyPopup
    {
        private var _classPicker:PickerList;

        private var _propertyPanel:PropertyPanel;

        private var _supportedClass:Array = [];

        private var _paramDict:Object = {};



        public function DefaultEditPropertyPopup(owner:Object, target:Object, targetParam:Object, customParam:Object, onComplete:Function)
        {
            super(owner, target, targetParam, customParam, onComplete);

            title = "Edit Property";
            buttons = ["OK", "Cancel"];

            addEventListener(Event.COMPLETE, onDialogComplete);
        }

        private function initClass(supportedClasses:Array):void
        {
            _supportedClass = [];

            for each (var cls:String in supportedClasses)
            {
                if (cls == null)
                {
                    _supportedClass.push("null");
                }
                else
                {
                    _supportedClass.push(cls);
                }
            }

            _paramDict = {};

            for each (var clsName:String in _supportedClass)
            {
                var param:Object = ParamUtil.getParamByClassName(TemplateData.editor_template, clsName);
                UIMapperUtil.processParamsWithFonts(param as Array, FontHelper.getBitmapFontNames());
                _paramDict[clsName] = param;
            }
        }

        override protected function createContent(container:LayoutGroup):void
        {
            initClass(getSupportedClasses());

            container.layout = new VerticalLayout();

            _classPicker = new PickerList();
            _classPicker.dataProvider = new ListCollection(_supportedClass);

            var clsName:String = ParamUtil.getClassName(_target);

            if (clsName == "") clsName = "null";

            _classPicker.selectedIndex = _supportedClass.indexOf(clsName);

            _propertyPanel = new PropertyPanel(_target, _paramDict[clsName], _customParam.params[_targetParam.name]);

            addChild(_classPicker);

            createCustom();

            addChild(_propertyPanel);

            _classPicker.addEventListener(Event.CHANGE, onClassPicker);
        }

        protected function onClassPicker(event:Event):void
        {
            var selected:String = _classPicker.selectedItem as String;

            if (selected == "null")
            {
                _target = null;
            }
            else
            {
                createNewComponent(selected);
                initDefault();
            }

            _owner[_targetParam.name] = _target;
            _propertyPanel.reloadData(_target, _paramDict[ParamUtil.getClassName(_target)], _customParam.params[_targetParam.name]);
        }

        private function onDialogComplete(event:Event):void
        {
            var index:int = int(event.data);

            if (index == 0)
            {
                if (hasEmptyTexture())
                    InfoPopup.show("Please select a texture", ["OK"]);
                _onComplete(_target);
            }
            else
            {
                _owner[_targetParam.name] = _oldTarget;
                _onComplete = null;
            }
        }

        private function createNewComponent(cls:String):void
        {
            var data:Object = UIComponentHelper.createDefaultComponentData(cls);
            var res:Object = ComponentRenderSupport.support.uiBuilder.createUIElement(data);
            _target = res.object;
            _customParam.params[_targetParam.name] = res.params;
        }

        private function hasEmptyTexture():Boolean
        {
            if (_customParam)
            {
                var data:String = JSON.stringify(_customParam);
                if (data.indexOf(EmptyTexture.NAME) != -1)
                    return true;
            }

            return false;
        }

        protected function createCustom():void
        {

        }

        protected function initDefault():void
        {

        }


        private function getSupportedClasses():Array
        {
            if (_targetParam.supportedClasses)
            {
                return _targetParam.supportedClasses;
            }
            else if (_targetParam.supportedGroup)
            {
                return TemplateData.editor_template["group"][_targetParam.supportedGroup];
            }
            else
            {
                return [];
            }
        }
    }
}
