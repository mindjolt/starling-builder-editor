/**
 * Created by hyh on 5/18/16.
 */
package starlingbuilder.util.ui.inspector
{
    public class AddPathPropertyComponent extends EditPathPropertyComponent
    {
        public function AddPathPropertyComponent(propertyRetriver:IPropertyRetriever, param:Object)
        {
            super(propertyRetriver, param);

            _button.label = "Add";
        }

        override protected function processPath(value:String, dir:String):String
        {
            if (value != "" && value.charAt(value.length - 1) != ":")
                value += ":";

            value += dir;
            return value;
        }
    }
}
