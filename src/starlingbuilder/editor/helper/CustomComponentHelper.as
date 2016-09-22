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
        public static function load(workspace:File, name:String, libsMonitor:LibsMonitor):void
        {
            try
            {
                var cls:Class = getDefinitionByName(name) as Class;

                if ("custom_component_template" in cls)
                {
                    var template:Object = JSON.parse(new cls["custom_component_template"]());
                    libsMonitor.updateTemplateChecksum(name, template);
                    TemplateData.load(template, workspace);
                }
            }
            catch (e:Error)
            {
            }
        }
    }
}
