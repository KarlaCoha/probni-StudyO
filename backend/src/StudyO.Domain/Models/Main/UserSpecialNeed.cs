using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace StudyO.Domain.Models.Main
{
    [Table("user_special_needs")]
    public class UserSpecialNeed
    {
        
        [Column("user_id")]
        public Guid? UserId { get; set; }

        
        public virtual User User { get; set; }
        [Key]
        [Column("special_need_id")]
        public int SpecialNeedId { get; set; }

       
        public SpecialNeed SpecialNeed { get; set; }
    }

}
