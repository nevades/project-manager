package neva.project_manager.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class LoadUserDTO {

    private Integer id;
    private Integer userId;
    private String userName;
    private String userType;
    private String date;
    private String createdBy;
    private String status;

}
