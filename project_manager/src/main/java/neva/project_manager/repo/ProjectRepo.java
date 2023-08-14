/**
 *
 * @author nevanjith
 */
package neva.project_manager.repo;

import neva.project_manager.dto.LoadDataDTO;
import neva.project_manager.dto.LoadProjectDTO;
import neva.project_manager.model.Project;
import org.springframework.data.jdbc.repository.query.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface ProjectRepo extends CrudRepository<Project, Long> {

    Project findByProjectName(String projectName);

    Project findByProjectId(Integer projectId);

    @Query("SELECT `project_id`,`project_name`,`project_icon`,`date` FROM `project` WHERE `user_id` =:uid and `status` = 'active'")
    Iterable<LoadProjectDTO> LoadProject(@Param("uid") String uid);

    @Query("SELECT `project_id`,`project_name`,`status` FROM `project` WHERE `user_id` = 1")
    Iterable<LoadDataDTO> LoadData(@Param("uid") String uid);
}
