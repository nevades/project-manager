package neva.project_manager.repo;

import neva.project_manager.dto.SlimSelectDTO;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import neva.project_manager.model.UserType;
import org.springframework.data.jdbc.repository.query.Query;
import org.springframework.data.repository.query.Param;

@Repository
public interface UserTypeRepo extends CrudRepository<UserType, Integer> {

    @Query("SELECT `id` AS `value`,`name` AS `text` FROM `user_type`")
    Iterable<SlimSelectDTO> searchUserType(@Param("search") String search);
}
