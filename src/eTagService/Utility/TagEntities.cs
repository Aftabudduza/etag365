using TagService.BO;

namespace eTagService
{
    internal class TagEntity
    {
        private TagEntity()
        {
            // Prevent outside instantiation
        }

        //private static PropertyEntities _singleton = PropertyEntities.Create(Utility.CONNECTIONSTRING);
        private static TagEntities _singleton;
        public static TagEntities GetEntity()
        {           
            if (_singleton == null)
            {
                _singleton = new TagEntities();
            }
            return _singleton;
        }

        public static TagEntities GetFreshEntity()
        {
            _singleton = new TagEntities();
            return _singleton;
        }
    }


}
