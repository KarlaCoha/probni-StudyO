using StudyO.Domain.Interfaces.Repositories.Main;
using StudyO.Domain.Models.Main;
using StudyO.Utilities.Paging.Models;
using Microsoft.EntityFrameworkCore;
using StudyO.Utilities.Paging;

namespace StudyO.Persistence.Main
{
    public class LessonRepository : ILessonRepository
    {
        private readonly ApplicationDbContext _context;
        public LessonRepository(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<List<Lesson>> GetLessonsPagedAsync(TableMetadata? tableMetadata)
        {
            var query = PagingHelper.CreateTableQuery(_context.Lessons, tableMetadata);
            return await query.ToListAsync();
        }

        public async Task<int> GetLessonsCountAsync()
        {
            return await _context.Lessons.CountAsync();
        }

        public async Task<List<Lesson>> GetLessonsAsync()
        {
            return await _context.Lessons.ToListAsync();
        }

        public async Task<Lesson> GetLessonAsync(int id)
        {
            return await _context.Lessons.FindAsync(id);
        }

        public async Task InsertLessonAsync(Lesson lesson)
        {
            _context.Lessons.Add(lesson);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateLessonAsync(Lesson lesson)
        {
            var existingLesson = await _context.Lessons.FindAsync(lesson.Id);
            if (existingLesson != null)
            {
                _context.Entry(existingLesson).CurrentValues.SetValues(lesson);
                await _context.SaveChangesAsync();
            }
        }

        public async Task DeleteLessonAsync(int id)
        {
            var lesson = await _context.Lessons.FindAsync(id);
            if (lesson != null)
            {
                _context.Lessons.Remove(lesson);
                await _context.SaveChangesAsync();
            }
        }
    }
}
