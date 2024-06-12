using StudyO.Domain.Interfaces.Repositories.Main;
using StudyO.Domain.Models.Main;
using StudyO.Utilities.Paging.Models;
using Microsoft.EntityFrameworkCore;
using StudyO.Utilities.Paging;

namespace StudyO.Persistence.Main
{
    public class QuestionRepository : IQuestionRepository
    {
        private readonly ApplicationDbContext _context;
        public QuestionRepository(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<List<Question>> GetQuestionsPagedAsync(TableMetadata? tableMetadata)
        {
            var query = PagingHelper.CreateTableQuery(_context.Questions, tableMetadata);
            return await query.ToListAsync();
        }

        public async Task<int> GetQuestionsCountAsync()
        {
            return await _context.Questions.CountAsync();
        }

        public async Task<List<Question>> GetQuestionsAsync()
        {
            return await _context.Questions.ToListAsync();
        }

        public async Task<Question> GetQuestionAsync(int id)
        {
            return await _context.Questions.FindAsync(id);
        }

        public async Task InsertQuestionAsync(Question question)
        {
            _context.Questions.Add(question);
            await _context.SaveChangesAsync();
        }

        public async Task<bool> UpdateQuestionAsync(Question question)
        {
            var existingQuestion = await _context.Questions.FindAsync(question.Id);
            if (existingQuestion != null)
            {
                _context.Entry(existingQuestion).CurrentValues.SetValues(question);
               return await _context.SaveChangesAsync() > 0;
            }
            return false;
        }

        public async Task DeleteQuestionAsync(int id)
        {
            var question = await _context.Questions.FindAsync(id);
            if (question != null)
            {
                _context.Questions.Remove(question);
                await _context.SaveChangesAsync();
            }
        }
    }
}
