package neva.project_manager.service;

import neva.project_manager.model.Board;
import neva.project_manager.model.Project;
import neva.project_manager.repo.BoardRepo;
import neva.project_manager.repo.ProjectRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ProjectService {

    @Autowired
    private ProjectRepo repo;

    @Autowired
    private BoardRepo brepo;

    public Project saveProject(String projectName, String[] boardNames, String[] boardColors) {

        Project existingProject = repo.findByProjectName(projectName);
        if (existingProject != null) {
            return existingProject;
        }

        Project project = new Project();
        project.setProjectName(projectName);
        project = repo.save(project);

        for (int i = 0; i < boardNames.length; i++) {
            String name = boardNames[i].replace("\"", "").replace("[", "").replace("]", "");
            String color = boardColors[i].replace("\"", "").replace("[", "").replace("]", "");
            Board board = new Board();
            board.setBoardName(name);
            board.setBoardColor(color);
            brepo.save(board);
        }

        return project;
    }
}
