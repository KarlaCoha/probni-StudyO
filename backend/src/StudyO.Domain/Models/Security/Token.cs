namespace StudyO.Domain.Models.Security
{
    public partial class Token
    {
        public Guid Id { get; set; }
        public Guid UserAccountId { get; set; }
        public string RefreshToken { get; set; } = default!;
        public DateTimeOffset Created { get; set; }
        public DateTimeOffset Expires { get; set; }

    }
}
