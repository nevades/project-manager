/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package neva.project_manager.model;

import com.fasterxml.jackson.annotation.JsonFormat;
import java.util.Date;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.data.annotation.CreatedBy;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;

/**
 *
 * @author nevanjith
 */
@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
@Table("project")

public class Project {

    @Id
    private Integer projectId;
    private String projectName;
    private String status;
    @CreatedBy
    private Integer userId;
    @CreatedDate
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd hh:mm:ss")
    private Date date;
}
