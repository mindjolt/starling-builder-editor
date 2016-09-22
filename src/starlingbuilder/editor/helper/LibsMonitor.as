/**
 * Created by hyh on 9/21/16.
 */
package starlingbuilder.editor.helper
{
    import com.adobe.crypto.MD5;

    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;

    import starlingbuilder.engine.format.StableJSONEncoder;
    import starlingbuilder.util.feathers.popup.InfoPopup;

    public class LibsMonitor
    {
        private static const LIBS_PATH:String = "settings/libs.json";

        private var _workspace:File;

        private var _oldTemplate:Object;
        private var _newTemplate:Object;

        public function LibsMonitor(workspace:File)
        {
            _workspace = workspace;

            var file:File = _workspace.resolvePath(LIBS_PATH);

            if (file.exists)
            {
                try
                {
                    var fs:FileStream = new FileStream();
                    fs.open(file, FileMode.READ);
                    _oldTemplate = JSON.parse(fs.readUTFBytes(fs.bytesAvailable));
                    fs.close();
                }
                catch (e:Error)
                {
                    InfoPopup.show("Failed to read libs.json");
                }
            }

            _newTemplate = {};
        }

        public function updateTemplateChecksum(name:String, template:Object):void
        {
            _newTemplate[name] = {custom_template_checksum:createChecksum(template)};
        }

        private function createChecksum(obj:Object):String
        {
            //return StableJSONEncoder.stringify(obj).length.toString();
            return MD5.hash(StableJSONEncoder.stringify(obj));
        }

        public function hasChange():Boolean
        {
            return _oldTemplate && StableJSONEncoder.stringify(_oldTemplate) != StableJSONEncoder.stringify(_newTemplate);
        }

        public function saveChange():void
        {
            var file:File = _workspace.resolvePath(LIBS_PATH);
            var fs:FileStream = new FileStream();
            fs.open(file, FileMode.WRITE);
            fs.writeUTFBytes(JSON.stringify(_newTemplate));
        }
    }
}
