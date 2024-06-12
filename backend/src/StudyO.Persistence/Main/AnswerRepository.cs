using StudyO.Domain.Interfaces.Repositories.Main;
using StudyO.Domain.Models.Main;
using StudyO.Utilities.Paging.Models;
using Microsoft.EntityFrameworkCore;
using StudyO.Utilities.Paging;

namespace StudyO.Persistence.Main
{
    public class AnswerRepository : IAnswerRepository
    {
        private readonly ApplicationDbContext _context;
        public AnswerRepository(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<List<Answer>> GetAnswersPagedAsync(TableMetadata? tableMetadata)
        {
            var query = PagingHelper.CreateTableQuery(_context.Answers, tableMetadata);
            return await query.ToListAsync();
        }

        public async Task<int> GetAnswersCountAsync()
        {
            return await _context.Answers.CountAsync();
        }

        public async Task<List<Answer>> GetAnswersAsync()
        {
            return await _context.Answers.AsNoTracking().ToListAsync();
        }

        public async Task<Answer> GetAnswerAsync(int id)
        {
            return await _context.Answers.FindAsync(id);
        }

        public async Task InsertAnswerAsync(Answer answer)
        {
            _context.Answers.Add(answer);
            await _context.SaveChangesAsync();
        }

        public async Task<bool> UpdateAnswerAsync(Answer answer)
        {
            var existingAnswer = await _context.Answers.FindAsync(answer.Id);
            if (existingAnswer != null)
            {
                _context.Entry(existingAnswer).CurrentValues.SetValues(answer);
               return await _context.SaveChangesAsync() > 0;
            }
            return false;
        }

        public async Task DeleteAnswerAsync(int id)
        {
            var answer = await _context.Answers.FindAsync(id);
            if (answer != null)
            {
                _context.Answers.Remove(answer);
                await _context.SaveChangesAsync();
            }
        }

        public async Task<List<Answer>> GetAnswerByQuestionIdAsync(int id)
        {
            var answers = await _context.Answers.Where(a => a.QuestionId == id).ToListAsync();
            if (answers != null)
            {
                return answers;
            }
            return null;
        }
    }
}
