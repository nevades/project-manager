package neva.project_manager.service;

import neva.project_manager.dto.LoadBoardDTO;
import neva.project_manager.model.Board;
import neva.project_manager.model.Project;
import neva.project_manager.repo.BoardRepo;
import neva.project_manager.repo.CardRepo;
import neva.project_manager.repo.ProjectRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

@Service
public class ProjectService {

    @Autowired
    private ProjectRepo repo;

    @Autowired
    private BoardRepo brepo;

    @Autowired
    private CardRepo crepo;

    @Transactional
    public Project saveProject(String projectName, String[] boardNames, String[] boardColors) throws Exception {

        try {
            Project existingProject = repo.findByProjectName(projectName);
            if (existingProject != null) {
                throw new Exception("project already exists");
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
                board.setProjectId(project.getProjectId());
                brepo.save(board);
            }

            return project;
        } catch (Exception e) {
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            throw e;
        }

    }

    public Iterable<LoadBoardDTO> LoadBoard(String uid) {
        return crepo.LoadBoard(uid);
    }
}
