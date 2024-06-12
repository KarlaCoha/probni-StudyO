namespace StudyO.Domain.Models.Main;

public partial class User
{
    public Guid? Id { get; set; }

    public string? FirstName { get; set; }

    public string? LastName { get; set; }

    public string? Gender { get; set; }

    public string? DateOfBirth { get; set; }

    public int? SchoolClassId { get; set; }

    public int? SpecialNeedsId { get; set; }

    public string? Username { get; set; }

    public string? Password { get; set; }

    public string? Email { get; set; }

    public int? Points { get; set; }

    public virtual SchoolClass? SchoolClass { get; set; }
    public virtual UserAuthentication? UserAuthentication { get; set; }

    public virtual SpecialNeed? SpecialNeeds { get; set; }
    public ICollection<UserSpecialNeed> UserSpecialNeeds { get; set; }
    public virtual ICollection<Friend> Friends { get; set; } = new HashSet<Friend>();
    public virtual ICollection<Friend> ReceivedRequests { get; set; } = new HashSet<Friend>();
}
