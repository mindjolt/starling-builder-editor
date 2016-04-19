/**
 * Created by hyh on 11/8/15.
 */
package starlingbuilder.editor.helper
{
    import flash.utils.getDefinitionByName;

    import starlingbuilder.editor.data.TemplateData;

    import flash.filesystem.File;

    public class CustomComponentHelper
    {
        private static const NAME:String = "EmbeddedComponents";

        public static function load(workspace:File):void
        {
            try
            {
                var cls:Class = getDefinitionByName(NAME) as Class;
                var template:String = new cls["custom_component_template"]().toString();
                TemplateData.load(template, workspace);
            }
            catch (e:Error)
            {
                TemplateData.load(null, workspace);
            }
        }
    }
}
