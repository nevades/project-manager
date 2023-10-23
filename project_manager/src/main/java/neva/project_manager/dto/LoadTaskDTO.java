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
    private Integer project_id;
    private Integer board_id;
    private String status;

}
