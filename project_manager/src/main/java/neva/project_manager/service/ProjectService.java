package neva.project_manager.service;

import neva.project_manager.datatable.DataTableRepo;
import neva.project_manager.datatable.DataTableRequest;
import neva.project_manager.datatable.DataTablesResponse;
import neva.project_manager.dto.LoadBoardDTO;
import neva.project_manager.dto.LoadDataDTO;
import neva.project_manager.dto.LoadParameterDTO;
import neva.project_manager.dto.LoadProjectDTO;
import neva.project_manager.dto.LoadTaskDTO;
import neva.project_manager.dto.LoadUserDTO;
import neva.project_manager.dto.ParamDTO;
import neva.project_manager.dto.SlimSelectDTO;
import neva.project_manager.model.Board;
import neva.project_manager.model.Category;
import neva.project_manager.model.Parameter;
import neva.project_manager.model.Project;
import neva.project_manager.model.Task;
import neva.project_manager.model.User;
import neva.project_manager.repo.BoardRepo;
import neva.project_manager.repo.CardRepo;
import neva.project_manager.repo.CategoryRepo;
import neva.project_manager.repo.ParamRepo;
import neva.project_manager.repo.ProjectRepo;
import neva.project_manager.repo.TaskRepo;
import neva.project_manager.repo.UserRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

@Service
public class ProjectService {

    @Autowired
    private ProjectRepo repo;

    @Autowired
    private UserRepo usr;

    @Autowired
    private TaskRepo trepor;

    @Autowired
    private CategoryRepo catrepo;

    @Autowired
    private ParamRepo pramrepo;

    @Autowired
    private BoardRepo brepo;

    @Autowired
    private CardRepo crepo;

    @Autowired
    private DataTableRepo<ParamDTO> prepo;

    @Autowired
    private DataTableRepo<LoadUserDTO> urepo;

    @Transactional
    public Project saveProject(String projectName, String[] boardNames, String[] boardColors) throws Exception {

        try {
            Project existingProject = repo.findByProjectName(projectName);
            if (existingProject != null) {
                throw new Exception("project already exists");
            }

            Project project = new Project();
            project.setProjectName(projectName);
            project.setStatus("Active");
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

    public Category saveCtypee(String ctype) throws Exception {

        Category cate = new Category();
        cate.setName(ctype);
        cate.setStatus("Active");
        cate = catrepo.save(cate);

        return cate;

    }

    public Project updateProject(Integer projectId, String projectName) throws Exception {
        Project existingProject = repo.findByProjectId(projectId);

        existingProject.setProjectName(projectName);

        return repo.save(existingProject);
    }

    public Parameter saveParam(String ctype, String cname) throws Exception {

        Parameter parameter = new Parameter();
        parameter.setCategoryName(cname);
        parameter.setCategoryType(ctype);
        parameter.setStatus("Active");
        parameter = pramrepo.save(parameter);

        return parameter;
    }

    public User saveUser(String username) throws Exception {

        User usro = new User();
        usro.setUsername(username);
        usro.setStatus("Active");
        usro = usr.save(usro);

        return usro;
    }

    public Iterable<LoadBoardDTO> LoadBoard(String uid, String projectId) {
        return crepo.LoadBoard(uid, projectId);
    }

    public Iterable<LoadProjectDTO> LoadProject(String uid) {
        return repo.LoadProject(uid);
    }

    public LoadParameterDTO LoadParameter(Integer pid) {
        return pramrepo.LoadParameter(pid);
    }

    public Iterable<LoadTaskDTO> LoadTasks(String uid) {
        return trepor.LoadTasks(uid);
    }

    public Iterable<LoadDataDTO> LoadData(String uid) {
        return repo.LoadData(uid);
    }

    public LoadTaskDTO showData(Integer tid) {
        return trepor.showData(tid);
    }

    public Parameter deactivateStatus(Integer id) throws Exception {
        Parameter utype = pramrepo.findById(id).get();
        utype.setStatus("deactivated");
        utype = pramrepo.save(utype);
        return utype;
    }

    public User deactivateUser(Integer id) throws Exception {
        User usrtype = usr.findById(id).get();
        usrtype.setStatus("deactivated");
        usrtype = usr.save(usrtype);
        return usrtype;
    }

    public Task deactivateTask(Integer id) throws Exception {
        Task tttype = trepor.findById(id).get();
        tttype.setStatus("deactivated");
        tttype = trepor.save(tttype);
        return tttype;
    }

    public Task updateBoard(Integer id, Integer bid) throws Exception {
        Task task = trepor.findById(id).get();
        task.setBoard_id(bid);
        task = trepor.save(task);
        return task;
    }

    public Parameter reactivateStatus(Integer id) throws Exception {
        Parameter utype = pramrepo.findById(id).get();
        utype.setStatus("active");
        utype = pramrepo.save(utype);
        return utype;
    }

    public User reactivateUser(Integer id) throws Exception {
        User usrtype = usr.findById(id).get();
        usrtype.setStatus("active");
        usrtype = usr.save(usrtype);
        return usrtype;
    }

    public Task saveTask(String subject, String selectedOption, String description, Integer projectId) {
        Task task = new Task();
        task.setSubject(subject);
        task.setDescription(description);
        task.setProject_id(projectId);
        task.setBoard_id(1);
        task.setStatus("active");

        switch (selectedOption) {
            case "Low" ->
                task.setPriority("1");
            case "Medium" ->
                task.setPriority("2");
            case "High" ->
                task.setPriority("3");
            default ->
                throw new AssertionError();
        }

        task = trepor.save(task);
        Integer tid = task.getId();
        return task;
    }

    public DataTablesResponse<ParamDTO> getParam(DataTableRequest param) throws Exception {
        return prepo.getData(ParamDTO.class, param, "SELECT `id`,`category_name` AS categoryName,(SELECT `name` FROM `category` WHERE `id` = `category_type`) AS categoryType,`date`,(SELECT `username` FROM `user` WHERE `id` = p.`created_by`) AS createdBy,`status` FROM `parameter` p");
    }

    public DataTablesResponse<LoadUserDTO> getUsers(DataTableRequest param) throws Exception {
        return urepo.getData(LoadUserDTO.class, param, "SELECT `id` AS `userId`,`username` AS `userName`,`user_type` AS `userType`,`date`,(SELECT `username` FROM `user` WHERE `id` = p.`created_by`) AS createdBy,`status` FROM `user` p");
    }

    public Iterable<SlimSelectDTO> searchType(String search) {
        return catrepo.searchType("%" + search.trim() + "%");
    }

    public Iterable<SlimSelectDTO> getAllType(String search) {
        return pramrepo.getAllType("%" + search.trim() + "%");
    }

}
