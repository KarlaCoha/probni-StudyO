namespace StudyO.Domain.Models.Main;

public partial class Lesson
{
    public int Id { get; set; }

    public string? LessonName { get; set; }

    public string? LessonDescription { get; set; }

    public int? SubjectId { get; set; }

    public virtual ICollection<Question> Questions { get; set; } = new List<Question>();

    public virtual Subject? Subject { get; set; }
}
