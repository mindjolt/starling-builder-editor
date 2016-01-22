/**
 * Created by hyh on 1/15/16.
 */
package starlingbuilder.editor.citestutil
{
    import org.flexunit.asserts.assertTrue;

    public function assertNumericEquals(v1:Number, v2:Number):void
    {
        assertTrue(Math.abs(v1 - v2) < 0.000001);
    }
}
