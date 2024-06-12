namespace StudyO.Domain.Models.Main;

public partial class Answer
{
    public int Id { get; set; }

    public string? AnswerText { get; set; }

    public string? AnswerDescription { get; set; }

    public int? QuestionId { get; set; }

    public int? CorrectAnswer { get; set; }

    public virtual Question? Question { get; set; }
}
