namespace StudyO.Domain.Models.Main;

public partial class Subject
{
    public int Id { get; set; }

    public string? SubjectName { get; set; }

    public int? Grade { get; set; }

    public int? ClassId { get; set; }

    public virtual SchoolClass? Class { get; set; }

    public virtual ICollection<Lesson> Lessons { get; set; } = new List<Lesson>();
}
