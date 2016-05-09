/**
 * Created by hyh on 1/12/16.
 */
package starlingbuilder.engine
{
    import org.mock4as.Mock;

    import starling.textures.Texture;

    public class MockAssetMediator extends Mock implements IAssetMediator
    {
        public function MockAssetMediator()
        {
        }

        public function getTexture(name:String):Texture
        {
            record("getTexture");
            return expectedReturnFor();
        }

        public function getTextures(prefix:String="", result:Vector.<Texture>=null):Vector.<Texture>
        {
            record("getTextures", prefix, result);
            return expectedReturnFor();
        }

        public function getExternalData(name:String):Object
        {
            record("getExternalData", name);
            return expectedReturnFor();
        }

        public function getXml(name:String):XML
        {
            record("getXml", name);
            return expectedReturnFor();
        }

        public function getObject(name:String):Object
        {
            record("getObject", name);
            return expectedReturnFor();
        }
    }
}
