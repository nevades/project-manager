package neva.project_manager.model;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;

@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
@ToString
@Table("task")
public class Task {

    @Id
    private Integer id;
    private String subject;
    private String description;
    private String priority;
    private Integer project_id;
    private Integer board_id;
    private Integer assigned_to;
    private Integer behalf_of;
    private String status;
//    @CreatedDate
//    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd hh:mm:ss")
//    private Date date;
//    @CreatedBy
//    private Integer createdBy;
}
