/**
 * Created by hyh on 7/20/15.
 */
package starlingbuilder.util.ui.inspector
{
    import org.as3commons.lang.ObjectUtils;

    public class UIPropertyComponentFactory
    {
        public static const DEFAULT_COMPONENT_MAPPING:Object = {
            "slider":SliderPropertyComponent,
            "pickerList":PickerListPropertyComponent,
            "textInput":TextInputPropertyComponent,
            "textInputShort":TextInputPropertyComponentShort,
            "textInputHex":TextInputPropertyComponentHex,
            "colorPicker":ColorPickerPropertyComponent,
            "textArea":TextAreaPropertyComponent,
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

            _itemsMapping = ObjectUtils.clone(DEFAULT_ITEMS_MAPPING);
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
