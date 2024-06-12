using StudyO.Domain.Interfaces.Repositories.Main;
using StudyO.Domain.Models.Main;
using StudyO.Utilities.Paging.Models;
using Microsoft.EntityFrameworkCore;
using StudyO.Utilities.Paging;

namespace StudyO.Persistence.Main
{
    public class SchoolClassRepository : ISchoolClassRepository
    {
        private readonly ApplicationDbContext _context;
        public SchoolClassRepository(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<List<SchoolClass>> GetSchoolClassesPagedAsync(TableMetadata? tableMetadata)
        {
            var query = PagingHelper.CreateTableQuery(_context.SchoolClasses, tableMetadata);
            return await query.ToListAsync();
        }

        public async Task<int> GetSchoolClassesCountAsync()
        {
            return await _context.SchoolClasses.CountAsync();
        }

        public async Task<List<SchoolClass>> GetSchoolClassesAsync()
        {
            return await _context.SchoolClasses.ToListAsync();
        }

        public async Task<SchoolClass> GetSchoolClassAsync(int id)
        {
            return await _context.SchoolClasses.FindAsync(id);
        }

        public async Task InsertSchoolClassAsync(SchoolClass schoolClass)
        {
            _context.SchoolClasses.Add(schoolClass);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateSchoolClassAsync(SchoolClass schoolClass)
        {
            var existingSchoolClass = await _context.SchoolClasses.FindAsync(schoolClass.Id);
            if (existingSchoolClass != null)
            {
                _context.Entry(existingSchoolClass).CurrentValues.SetValues(schoolClass);
                await _context.SaveChangesAsync();
            }
        }

        public async Task DeleteSchoolClassAsync(int id)
        {
            var schoolClass = await _context.SchoolClasses.FindAsync(id);
            if (schoolClass != null)
            {
                _context.SchoolClasses.Remove(schoolClass);
                await _context.SaveChangesAsync();
            }
        }
    }
}
