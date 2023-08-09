package neva.project_manager.service;

import neva.project_manager.datatable.DataTableRepo;
import neva.project_manager.datatable.DataTableRequest;
import neva.project_manager.datatable.DataTablesResponse;
import neva.project_manager.dto.LoadBoardDTO;
import neva.project_manager.dto.LoadDataDTO;
import neva.project_manager.dto.LoadProjectDTO;
import neva.project_manager.dto.ParamDTO;
import neva.project_manager.model.Board;
import neva.project_manager.model.Parameter;
import neva.project_manager.model.Project;
import neva.project_manager.repo.BoardRepo;
import neva.project_manager.repo.CardRepo;
import neva.project_manager.repo.ParamRepo;
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

    @Autowired
    private DataTableRepo<ParamDTO> prepo;

    @Autowired
    ParamRepo pramrepo;

    @Transactional
    public Project saveProject(String projectName, String[] boardNames, String[] boardColors) throws Exception {

        try {
            Project existingProject = repo.findByProjectName(projectName);
            if (existingProject != null) {
                throw new Exception("project already exists");
            }

            Project project = new Project();
            project.setProjectName(projectName);
            project.setStatus(1);
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

    public Iterable<LoadBoardDTO> LoadBoard(String uid, String projectId) {
        return crepo.LoadBoard(uid, projectId);
    }

    public Iterable<LoadProjectDTO> LoadProject(String uid) {
        return repo.LoadProject(uid);
    }

    public Iterable<LoadDataDTO> LoadData(String uid) {
        return repo.LoadData(uid);
    }

    public Parameter deactivateStatus(Integer id) throws Exception {
        Parameter utype = pramrepo.findById(id).get();
        utype.setStatus("deactivated");
        utype = pramrepo.save(utype);
        return utype;
    }

    public Parameter reactivateStatus(Integer id) throws Exception {
        Parameter utype = pramrepo.findById(id).get();
        utype.setStatus("active");
        utype = pramrepo.save(utype);
        return utype;
    }

    public DataTablesResponse<ParamDTO> getParam(DataTableRequest param) throws Exception {
        return prepo.getData(ParamDTO.class, param, "SELECT `id`,`category_name` AS categoryName,(SELECT `name` FROM `category` WHERE `id` = `category_type`) AS categoryType,`date`,(SELECT `username` FROM `user` WHERE `id` = `created_by`) AS createdBy,`status` FROM `parameter`");
    }
}
