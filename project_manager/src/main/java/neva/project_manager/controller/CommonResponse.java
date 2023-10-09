/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package neva.project_manager.controller;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 *
 * @author nevanjith
 */
@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
public class CommonResponse {

    public CommonResponse(String message, int status) {
        this.message = message;
        this.status = status;
    }

    private String message;
    private int status;
    private Object data;

}
