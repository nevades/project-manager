/**
 *
 * @author nevanjith
 */
package neva.project_manager.repo;

import neva.project_manager.model.Project;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ProjectRepo extends CrudRepository<Project, Long> {

    Project findByProjectName(String projectName);
}
