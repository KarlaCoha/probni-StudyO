namespace StudyO.Domain.Models.Main;

public partial class SpecialNeed
{
    public int Id { get; set; }

    public string? Name { get; set; }

    public ICollection<UserSpecialNeed> UserSpecialNeeds { get; set; }
    public virtual ICollection<User> Users { get; set; } = new List<User>();
}
