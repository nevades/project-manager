package neva.project_manager.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class LoadTaskDTO {

    private Integer id;
    private String subject;
    private String description;
    private String priority;
    private String project_id;
    private String board_id;
    private String parameter_id;
    private String assigned_to;
    private String behalf_of;
    private String status;

}
