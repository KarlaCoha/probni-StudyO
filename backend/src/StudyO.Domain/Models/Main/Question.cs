namespace StudyO.Domain.Models.Main;

public partial class Question
{
    public int Id { get; set; }

    public string? QuestionText { get; set; }

    public int? LessonId { get; set; }

    public virtual ICollection<Answer> Answers { get; set; } = new List<Answer>();

    public virtual Lesson? Lesson { get; set; }
}
