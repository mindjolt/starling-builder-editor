/**
 * Created by hyh on 1/12/16.
 */
package starlingbuilder.engine
{
    import starling.textures.Texture;

    public class MockAssetMediator implements IAssetMediator
    {
        public function MockAssetMediator()
        {
        }

        public function getTexture(name:String):Texture
        {
            return null;
        }

        public function getTextures(prefix:String="", result:Vector.<Texture>=null):Vector.<Texture>
        {
            return null;
        }

        public function getExternalData(name:String):Object
        {
            return null;
        }
    }
}
