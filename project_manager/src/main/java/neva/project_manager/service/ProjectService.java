package neva.project_manager.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.Iterator;
import java.util.Map;
import neva.project_manager.datatable.DataTableRepo;
import neva.project_manager.datatable.DataTableRequest;
import neva.project_manager.datatable.DataTablesResponse;
import neva.project_manager.dto.LoadBoardDTO;
import neva.project_manager.dto.LoadDataDTO;
import neva.project_manager.dto.LoadParameterDTO;
import neva.project_manager.dto.LoadProjectDTO;
import neva.project_manager.dto.LoadTaskCountDTO;
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
import neva.project_manager.repo.CategoryRepo;
import neva.project_manager.repo.ParamRepo;
import neva.project_manager.repo.ProjectRepo;
import neva.project_manager.repo.TaskRepo;
import neva.project_manager.repo.UserRepo;
import neva.project_manager.repo.UserTypeRepo;
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
    private UserTypeRepo tussr;

    @Autowired
    private CategoryRepo catrepo;

    @Autowired
    private ParamRepo pramrepo;

    @Autowired
    private BoardRepo brepo;

    @Autowired
    private DataTableRepo<ParamDTO> prepo;

    @Autowired
    private DataTableRepo<LoadUserDTO> urepo;

    @Autowired
    private DataTableRepo<LoadTaskDTO> ltrepo;

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

    public Project updateProject(Integer projectId, String projectName, String boardData) throws Exception {
        Project existingProject = repo.findByProjectId(projectId);
        existingProject.setProjectName(projectName);

        ObjectMapper objectMapper = new ObjectMapper();
        JsonNode boardDataJson = objectMapper.readTree(boardData);

        Iterator<Map.Entry<String, JsonNode>> boards = boardDataJson.fields();
        while (boards.hasNext()) {
            Map.Entry<String, JsonNode> boardEntry = boards.next();
            String boardId = boardEntry.getKey();

            // Extract the numeric part from the board ID
            String numericPart = boardId.replaceAll("\\D+", ""); // Extracts only digits

            JsonNode boardDetails = boardEntry.getValue();

            // Now you can extract 'name' and 'color' from boardDetails and update the corresponding board.
            // For example:
            String boardName = boardDetails.get("name").asText();
            String boardColor = boardDetails.get("color").asText();

            // Update the board using the retrieved information.
            Board existingBoard = brepo.findByBoardId(numericPart);
            existingBoard.setBoardName(boardName);
            existingBoard.setBoardColor(boardColor);
            brepo.save(existingBoard);
        }

        return repo.save(existingProject);
    }

    public User updateUser(Integer userid, String username, Integer usertype) throws Exception {
        User existingUser = usr.findById(userid).get();
        existingUser.setUsername(username);
        existingUser.setUserType(usertype);

        return usr.save(existingUser);
    }

    public Parameter saveParam(String ctype, String cname) throws Exception {

        Parameter parameter = new Parameter();
        parameter.setCategoryName(cname);
        parameter.setCategoryType(ctype);
        parameter.setStatus("Active");
        parameter = pramrepo.save(parameter);

        return parameter;
    }

    public User saveUser(String username, Integer usertype) throws Exception {

        User usro = new User();
        usro.setUsername(username);
        usro.setUserType(usertype);
        usro.setStatus("Active");
        usro = usr.save(usro);

        return usro;
    }

    public Iterable<LoadBoardDTO> LoadBoard(String uid, String projectId) {
        return brepo.LoadBoard(uid, projectId);
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

    public Iterable<LoadTaskDTO> LoadTask(Integer tid) {
        return trepor.LoadTask(tid);
    }

    public Iterable<LoadDataDTO> LoadData(String uid) {
        return repo.LoadData(uid);
    }

    public LoadTaskDTO showData(Integer nid) {
        return trepor.showData(nid);
    }

    public User getUserName(Integer uuid) {
        return usr.getUserName(uuid);
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

    public Task reactivateTask(Integer id) throws Exception {
        Task tttype = trepor.findById(id).get();
        tttype.setStatus("active");
        tttype = trepor.save(tttype);
        return tttype;
    }

    public Task saveTask(String subject, String selectedOption, String description, Integer projectId, Integer assignedTo, Integer behalfOf, Integer parameter_id) {
        Task task = new Task();
        task.setSubject(subject);
        task.setDescription(description);
        task.setProject_id(projectId);
        task.setBoard_id(1);
        task.setParameter_id(parameter_id);
        task.setBehalf_of(behalfOf);
        task.setAssigned_to(assignedTo);
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
        return task;
    }

    public DataTablesResponse<ParamDTO> getParam(DataTableRequest param) throws Exception {
        return prepo.getData(ParamDTO.class, param, "SELECT `id`,`category_name` AS categoryName,(SELECT `name` FROM `category` WHERE `id` = `category_type`) AS categoryType,`date`,(SELECT `username` FROM `user` WHERE `id` = p.`created_by`) AS createdBy,`status` FROM `parameter` p");
    }

    public DataTablesResponse<LoadTaskDTO> getTickets(DataTableRequest param) throws Exception {

        String s = "";
        String data = param.getData();
        if ("0".equals(data)) {
            s = "";
        } else if ("1".equals(data)) {
            s = "WHERE p.`category_type` IN (1)";
        } else if ("2".equals(data)) {
            s = "WHERE p.`category_type` IN (2)";
        } else if ("69".equals(data)) {
            s = "WHERE p.`category_type` NOT IN (1,2)";
        }

        return ltrepo.getData(LoadTaskDTO.class, param, "SELECT t.`id`,`subject`,`description`,`priority`,(SELECT `project_name` FROM `project` WHERE `project_id` = t.`project_id`) AS `project_id`,(SELECT `board_name` FROM `board` WHERE `board_id` = t.`board_id`) AS `board_id`,(SELECT `category_name` FROM `parameter` WHERE `id` = `parameter_id`) AS `parameter_id`,(SELECT `username` FROM `user` WHERE `id` = `assigned_to`) AS `assigned_to`,(SELECT `username` FROM `user` WHERE `id` = `behalf_of`) AS `behalf_of`,t.`status` FROM `task` t INNER JOIN `parameter` p ON t.`parameter_id` = p.`id` " + s + " ");
    }

    public DataTablesResponse<LoadUserDTO> getUsers(DataTableRequest param) throws Exception {
        return urepo.getData(LoadUserDTO.class, param, "SELECT `id` AS `userId`,`username` AS `userName`, (SELECT `name` FROM `user_type` WHERE `id`=`user_type`) AS `userType`,`date`,(SELECT `username` FROM `user` WHERE `id` = p.`created_by`) AS createdBy,`status` FROM `user` p");
    }

    public Iterable<SlimSelectDTO> searchType(String search) {
        return catrepo.searchType("%" + search.trim() + "%");
    }

    public Iterable<SlimSelectDTO> searchUserType(String search) {
        return tussr.searchUserType("%" + search.trim() + "%");
    }

    public Iterable<SlimSelectDTO> getAllType(String search) {
        return pramrepo.getAllType("%" + search.trim() + "%");
    }

    public Iterable<SlimSelectDTO> getAllUsers(String search) {
        return usr.getAllUsers("%" + search.trim() + "%");
    }

    public Parameter updateParameter(Integer pid, String categoryName, String categoryType) throws Exception {
        Parameter p = pramrepo.findById(pid).get();
        p.setCategoryName(categoryName);
        p.setCategoryType(categoryType);
        p = pramrepo.save(p);
        return p;
    }

    public Iterable<LoadTaskCountDTO> getCardCount(String uid) {
        return trepor.countByStatus();
    }

    public Iterable<LoadTaskCountDTO> loadOtherCount(String uid) {
        return trepor.loadOtherCount();
    }

    public Iterable<LoadTaskCountDTO> loadTotalCount(String uid) {
        return trepor.loadTotalCount();
    }
}
