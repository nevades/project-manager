/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package neva.project_manager.controller;

import neva.project_manager.service.ProjectService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

/**
 *
 * @author nevanjith
 */
@RestController
@RequestMapping("/project")
public class ProjectController {

    @Autowired
    private ProjectService ser;

    @RequestMapping(value = "/save-project", method = RequestMethod.POST)
    @ResponseBody
    public ResponseEntity<CommonResponse> saveApplication(@RequestParam String projectName, @RequestParam String boardName, @RequestParam String boardColor) throws Exception {
        ser.saveProject(projectName, boardName, boardColor);
        CommonResponse response = new CommonResponse("Success!", 200);
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

}
