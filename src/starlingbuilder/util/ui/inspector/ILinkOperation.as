/**
 * Created by hyh on 1/10/16.
 */
package starlingbuilder.util.ui.inspector
{
    public interface ILinkOperation
    {
        function update(target:Object, changedPropertyName:String, propertyName:String):void
    }
}
