/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package neva.project_manager.service;

import neva.project_manager.model.Board;
import neva.project_manager.model.Project;
import neva.project_manager.repo.BoardRepo;
import neva.project_manager.repo.ProjectRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 *
 * @author nevanjith
 */
@Service
public class ProjectService {

    @Autowired
    private ProjectRepo repo;

    @Autowired
    private BoardRepo brepo;

    public Project saveProject(String projectName, String boardName, String boardColor) {

        Project ifp = repo.findByProjectName(projectName);

        if (ifp == null) {
            Project project = new Project();
            project.setProjectName(projectName);
            project = repo.save(project);
        }

        Board board = new Board();
        board.setBoardName(boardName);
        board.setBoardColor(boardColor);
        board = brepo.save(board);

        return ifp;
    }
}
