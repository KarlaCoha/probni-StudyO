namespace StudyO.Domain.Models.Main;

public partial class SchoolClass
{
    public int Id { get; set; }

    public int? ClassNumber { get; set; }

    public virtual ICollection<Subject> Subjects { get; set; } = new List<Subject>();

    public virtual ICollection<User> Users { get; set; } = new List<User>();
}
