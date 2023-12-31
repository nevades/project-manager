package neva.project_manager.controller;

import jakarta.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;
import neva.project_manager.datatable.DataTableRequest;
import neva.project_manager.datatable.DataTablesResponse;
import neva.project_manager.dto.LoadBoardDTO;
import neva.project_manager.dto.LoadCategoryDTO;
import neva.project_manager.dto.LoadDataDTO;
import neva.project_manager.dto.LoadParameterDTO;
import neva.project_manager.dto.LoadProjectDTO;
import neva.project_manager.dto.LoadTaskCountDTO;
import neva.project_manager.dto.LoadTaskDTO;
import neva.project_manager.dto.LoadUserDTO;
import neva.project_manager.dto.ParamDTO;
import neva.project_manager.dto.SlimSelectDTO;
import neva.project_manager.model.Task;
import neva.project_manager.model.User;
import neva.project_manager.service.ProjectService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

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

    @PostMapping("/save-ctype")
    public ResponseEntity<CommonResponse> saveCtype(@RequestParam String ctype) throws Exception {
        ser.saveCtypee(ctype);
        CommonResponse response = new CommonResponse("Success!", 200);
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @PostMapping("/update-project")
    public ResponseEntity<CommonResponse> updateProject(@RequestParam Integer projectId, @RequestParam String projectName, @RequestParam String boardData) throws Exception {
        ser.updateProject(projectId, projectName, boardData);
        CommonResponse response = new CommonResponse("Success!", 200);
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @PostMapping("/update-user")
    public ResponseEntity<CommonResponse> updateUser(@RequestParam Integer userid, @RequestParam String username, @RequestParam Integer usertype) throws Exception {
        ser.updateUser(userid, username, usertype);
        CommonResponse response = new CommonResponse("Success!", 200);
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @PostMapping("/save-param")
    public ResponseEntity<CommonResponse> saveParam(@RequestParam String ctype, @RequestParam String cname) throws Exception {
        ser.saveParam(ctype, cname);
        CommonResponse response = new CommonResponse("Success!", 200);
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @PostMapping("/save-user")
    public ResponseEntity<CommonResponse> saveUser(@RequestParam String username, @RequestParam Integer usertype) throws Exception {
        ser.saveUser(username, usertype);
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

    @PostMapping("/load-parameter")
    public LoadParameterDTO LoadParameter(@RequestParam Integer pid) throws Exception {
        return ser.LoadParameter(pid);
    }

    @GetMapping("/load-tasks")
    public Iterable<LoadTaskDTO> LoadTasks(HttpSession session) throws Exception {
        return ser.LoadTasks(session.getAttribute("uid").toString());
    }

    @PostMapping("/load-task")
    public Iterable<LoadTaskDTO> LoadTask(@RequestParam Integer tid) throws Exception {
        return ser.LoadTask(tid);
    }

    @PostMapping("/show")
    public DataTablesResponse<ParamDTO> getParam(@RequestBody DataTableRequest param) throws Exception {
        return ser.getParam(param);
    }

    @PostMapping("/show-cat-type")
    public DataTablesResponse<LoadCategoryDTO> getCatType(@RequestBody DataTableRequest param) throws Exception {
        return ser.getCatType(param);
    }

    @PostMapping("/show-tickets")
    public DataTablesResponse<LoadTaskDTO> getTickets(@RequestBody DataTableRequest param) throws Exception {
        return ser.getTickets(param);
    }

    @PostMapping("/show-data")
    public LoadTaskDTO showData(@RequestParam Integer nid) throws Exception {
        return ser.showData(nid);
    }

    @PostMapping("/load-username")
    public User getUserName(@RequestParam Integer uuid) throws Exception {
        return ser.getUserName(uuid);
    }

    @PostMapping("/get-users")
    public DataTablesResponse<LoadUserDTO> getUsers(@RequestBody DataTableRequest param) throws Exception {
        return ser.getUsers(param);
    }

    @PostMapping("/deactivate")
    public ResponseEntity<CommonResponse> deactivateStatus(@RequestParam Integer id) throws Exception {
        ser.deactivateStatus(id);
        CommonResponse response = new CommonResponse("Success!", 200);
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @PostMapping("/deactivate-user")
    public ResponseEntity<CommonResponse> deactivateUser(@RequestParam Integer id) throws Exception {
        ser.deactivateUser(id);
        CommonResponse response = new CommonResponse("Success!", 200);
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @PostMapping("/deactivate-task")
    public ResponseEntity<CommonResponse> deactivateTask(@RequestParam Integer id) throws Exception {
        ser.deactivateTask(id);
        CommonResponse response = new CommonResponse("Success!", 200);
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @PostMapping("/update-board")
    public ResponseEntity<CommonResponse> updateBoard(@RequestParam Integer id, @RequestParam Integer bid) throws Exception {
        ser.updateBoard(id, bid);
        CommonResponse response = new CommonResponse("Success!", 200);
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @PostMapping("/reactivate")
    public ResponseEntity<CommonResponse> reactivateStatus(@RequestParam Integer id) throws Exception {
        ser.reactivateStatus(id);
        CommonResponse response = new CommonResponse("Success!", 200);
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @PostMapping("/reactivate-user")
    public ResponseEntity<CommonResponse> reactivateUser(@RequestParam Integer id) throws Exception {
        ser.reactivateUser(id);
        CommonResponse response = new CommonResponse("Success!", 200);
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @PostMapping("/reactivate-task")
    public ResponseEntity<CommonResponse> reactivateTask(@RequestParam Integer id) throws Exception {
        ser.reactivateTask(id);
        CommonResponse response = new CommonResponse("Success!", 200);
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @PostMapping("/get-type")
    public Iterable<SlimSelectDTO> searchType(@RequestParam String search) throws Exception {
        return ser.searchType(search);
    }

    @PostMapping("/get-usertype")
    public Iterable<SlimSelectDTO> searchUserType(@RequestParam String search) throws Exception {
        return ser.searchUserType(search);
    }

    @PostMapping("/search-type")
    public Iterable<SlimSelectDTO> getAllType(@RequestParam String search) throws Exception {
        return ser.getAllType(search);
    }

    @PostMapping("/search-user")
    public Iterable<SlimSelectDTO> getAllUsers(@RequestParam String search) throws Exception {
        return ser.getAllUsers(search);
    }

    @PostMapping("/save-task")
    public ResponseEntity<CommonResponse> saveTask(@RequestParam String subject, @RequestParam String selectedOption, @RequestParam String description, @RequestParam Integer projectId, @RequestParam Integer assignedTo, @RequestParam Integer behalfOf, @RequestParam Integer parameter_id) throws Exception {
        Task saved = ser.saveTask(subject, selectedOption, description, projectId, assignedTo, behalfOf, parameter_id);
        Map<String, Object> responseData = new HashMap<>();
        responseData.put("id", saved.getId());
        responseData.put("projectId", saved.getProject_id());
        responseData.put("boardId", saved.getBoard_id());

        CommonResponse response = new CommonResponse("Success!", 200, responseData);
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @PostMapping("/update-parameter")
    public ResponseEntity<CommonResponse> updateParameter(@RequestParam Integer pid, @RequestParam String categoryName, @RequestParam String categoryType) throws Exception {
        ser.updateParameter(pid, categoryName, categoryType);
        CommonResponse response = new CommonResponse("Success!", 200);
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @GetMapping("/cards")
    public Iterable<LoadTaskCountDTO> getCardCount(HttpSession session) throws Exception {
        return ser.getCardCount(session.getAttribute("uid").toString());
    }

    @GetMapping("/other")
    public Iterable<LoadTaskCountDTO> loadOtherCount(HttpSession session) throws Exception {
        return ser.loadOtherCount(session.getAttribute("uid").toString());
    }

    @GetMapping("/total")
    public Iterable<LoadTaskCountDTO> loadTotalCount(HttpSession session) throws Exception {
        return ser.loadTotalCount(session.getAttribute("uid").toString());
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<CommonResponse> handleException(Exception e) {
        e.printStackTrace();
        CommonResponse response = new CommonResponse(e.getMessage(), 2000);
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

}
