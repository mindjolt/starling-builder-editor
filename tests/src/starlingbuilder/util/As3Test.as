/**
 * Created by hyh on 12/23/15.
 */
package starlingbuilder.util
{
    import org.flexunit.asserts.assertEquals;

    public class As3Test
    {
        public function As3Test()
        {
        }

        [Test]
        public function test1():void
        {
            assertEquals(0, 0);
        }

        [Test]
        public function test2():void
        {
            assertEquals(1, 1);
        }
    }
}
