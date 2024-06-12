using StudyO.Domain.Models.Main;
using StudyO.Utilities.Paging.Attributes;

namespace StudyO.Core.Dtos.Main
{
    public record LessonDto
    {
        [TableColumn("Lesson id", nameof(LessonId), true, true)]
        public int LessonId { get; set; }
        public string? LessonName { get; set; }
        public string? LessonDescription { get; set; }
        public int? SubjectId { get; set; }

        public static LessonDto CreateDto(Lesson lesson)
        {
            return new LessonDto
            {
                LessonId = lesson.Id,
                LessonName = lesson.LessonName,
                LessonDescription = lesson.LessonDescription,
                SubjectId = lesson.SubjectId
            };
        }

        public static Lesson ToModel(LessonDto lessonDto)
        {
            return new Lesson
            {
                Id = lessonDto.LessonId,
                LessonName = lessonDto.LessonName,
                LessonDescription = lessonDto.LessonDescription,
                SubjectId = lessonDto.SubjectId
            };
        }
    }
}
