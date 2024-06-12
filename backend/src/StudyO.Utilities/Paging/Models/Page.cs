namespace StudyO.Utilities.Paging.Models
{
   public class Page
    {
        public int Offset { get; set; }
        public int PageSize { get; set; } = 10;
        public int PageCount { get; set; }
        public int PageIndex { get; set; } = 1;
        public int TotalCount { get; set; }

        public Page() { }

        public Page(int count, Page page)
        {
            PageCount = (page.PageCount == 0) ? (int)Math.Ceiling(decimal.Divide(count, page.PageSize)) : page.PageCount; // Number of pages based on total count and page size
            PageIndex = page.PageIndex; // Selected page index
            PageSize = page.PageSize; // Selected page rows to return
            TotalCount = count;
            Offset = (page.PageIndex > 0 && PageCount > 0) ? (page.PageIndex - 1) * page.PageSize : 0; // Number of rows to skip based on page index and page size
        }
    }
}

