/**
 * Created by hyh on 7/20/15.
 */
package starlingbuilder.util.ui.inspector
{
    import starlingbuilder.engine.UIBuilder;

    public class UIPropertyComponentFactory
    {
        public static const CONTAINER:String = "container";
        public static const ROW:String = "row";
        public static const LABEL:String = "label";
        public static const PICKER_LIST:String = "pickerList";
        public static const SLIDER:String = "slider";
        public static const TEXT_INPUT:String = "textInput";
        public static const TEXT_INPUT_SHORT:String = "textInputShort";
        public static const COLOR_PICKER:String = "colorPicker";
        public static const TEXT_AREA:String = "textArea";
        public static const EDIT_PATH:String = "editPath";
        public static const POPUP:String = "popup";
        public static const CHECK:String = "check";

        public static const DEFAULT_COMPONENT_MAPPING:Object = {
            "slider":SliderPropertyComponent,
            "pickerList":PickerListPropertyComponent,
            "textInput":TextInputPropertyComponent,
            "textInputShort":TextInputPropertyComponentShort,
            "textInputHex":TextInputPropertyComponentHex,
            "colorPicker":ColorPickerPropertyComponent,
            "textArea":TextAreaPropertyComponent,
            "textAreaString":TextAreaStringPropertyComponent,
            "editPath":EditPathPropertyComponent,
            "addPath":AddPathPropertyComponent,
            "popup":ButtonPropertyComponent,
            "check":CheckPropertyComponent
        };

        public static const DEFAULT_ITEMS_MAPPING:Object = {
            "pickerList":["pickerList"],
            "slider":["slider", "textInputShort"],
            "colorPicker":["textInputHex", "colorPicker"],
            "textInput":["textInput"],
            "textArea":["textArea"],
            "popup":["textInput", "popup"],
            "check":["check"],
            "editPath":["textAreaString", "editPath"],
            "addPath":["textAreaString", "addPath"],
            "default":["textInput"]
        }

        private var _componentMapping:Object = {};

        private var _itemsMapping:Object = {};

        public function UIPropertyComponentFactory()
        {
            var id:String;

            for (id in DEFAULT_COMPONENT_MAPPING)
            {
                _componentMapping[id] = DEFAULT_COMPONENT_MAPPING[id];
            }

            _itemsMapping = UIBuilder.cloneObject(DEFAULT_ITEMS_MAPPING);
        }

        public function registerComponentMapping(type:String, cls:Class):void
        {
            _componentMapping[type] = cls;
        }

        public function registerItemMapping(type:String, value:Array):void
        {
            _itemsMapping[type] = value;
        }

        public function getComponent(type:String):Class
        {
            return _componentMapping[type];
        }

        public function getItems(type:String):Array
        {
            if (_itemsMapping[type])
            {
                return _itemsMapping[type];
            }
            else
            {
                return _itemsMapping["default"];
            }
        }
    }
}
