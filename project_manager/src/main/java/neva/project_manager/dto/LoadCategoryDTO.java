/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package neva.project_manager.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 *
 * @author Neva
 */
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class LoadCategoryDTO {

    private Integer id;
    private String name;
    private String date;
    private String created_by;
    private String status;
}
