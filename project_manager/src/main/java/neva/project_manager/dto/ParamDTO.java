package neva.project_manager.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class ParamDTO {

    private Integer id;
    private String categoryName;
    private String categoryType;
    private String date;
    private String createdBy;
    private String status;

}
