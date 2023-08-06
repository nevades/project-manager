/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package neva.project_manager.controller;

import jakarta.servlet.http.HttpSession;
import neva.project_manager.dto.LoadBoardDTO;
import neva.project_manager.dto.LoadDataDTO;
import neva.project_manager.dto.LoadProjectDTO;
import neva.project_manager.service.ProjectService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
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
    public ResponseEntity<CommonResponse> saveApplication(@RequestParam String projectName, @RequestParam String[] boardName, @RequestParam String[] boardColor) throws Exception {
        ser.saveProject(projectName, boardName, boardColor);
        CommonResponse response = new CommonResponse("Success!", 200);
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @PostMapping("/load-board")
    public Iterable<LoadBoardDTO> LoadBoard(HttpSession session, String projectId) throws Exception {
        return ser.LoadBoard(session.getAttribute("uid").toString(), projectId);
    }

    @GetMapping("/load-data")
    public Iterable<LoadDataDTO> LoadData(HttpSession session, String projectId) throws Exception {
        return ser.LoadData(session.getAttribute("uid").toString());
    }

    @GetMapping("/load-project")
    public Iterable<LoadProjectDTO> LoadProject(HttpSession session) throws Exception {
        return ser.LoadProject(session.getAttribute("uid").toString());
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<CommonResponse> handleException(Exception e) {
        e.printStackTrace();
        CommonResponse response = new CommonResponse(e.getMessage(), 200);
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

}
