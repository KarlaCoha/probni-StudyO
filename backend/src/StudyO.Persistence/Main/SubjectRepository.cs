using StudyO.Domain.Interfaces.Repositories.Main;
using StudyO.Domain.Models.Main;
using StudyO.Utilities.Paging.Models;
using Microsoft.EntityFrameworkCore;
using StudyO.Utilities.Paging;

namespace StudyO.Persistence.Main
{
    public class SubjectRepository : ISubjectRepository
    {
        private readonly ApplicationDbContext _context;
        public SubjectRepository(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<List<Subject>> GetSubjectsPagedAsync(TableMetadata? tableMetadata)
        {
            var query = PagingHelper.CreateTableQuery(_context.Subjects, tableMetadata);
            return await query.ToListAsync();
        }

        public async Task<int> GetSubjectsCountAsync()
        {
            return await _context.Subjects.CountAsync();
        }

        public async Task<List<Subject>> GetSubjectsAsync()
        {
            return await _context.Subjects.ToListAsync();
        }

        public async Task<Subject> GetSubjectAsync(int id)
        {
            return await _context.Subjects.FindAsync(id);
        }

        public async Task InsertSubjectAsync(Subject subject)
        {
            _context.Subjects.Add(subject);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateSubjectAsync(Subject subject)
        {
            var existingSubject = await _context.Subjects.FindAsync(subject.Id);
            if (existingSubject != null)
            {
                _context.Entry(existingSubject).CurrentValues.SetValues(subject);
                await _context.SaveChangesAsync();
            }
        }

        public async Task DeleteSubjectAsync(int id)
        {
            var subject = await _context.Subjects.FindAsync(id);
            if (subject != null)
            {
                _context.Subjects.Remove(subject);
                await _context.SaveChangesAsync();
            }
        }
    }
}
