package neva.project_manager.repo;

import java.util.Optional;
import neva.project_manager.dto.SlimSelectDTO;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import neva.project_manager.model.User;
import org.springframework.data.jdbc.repository.query.Query;
import org.springframework.data.repository.query.Param;

@Repository
public interface UserRepo extends CrudRepository<User, Integer> {

    Optional<User> findByUsername(String username);

    @Query("SELECT `id` AS `value`,`username` AS `text` FROM `user` WHERE `status`='active'")
    Iterable<SlimSelectDTO> getAllUsers(@Param("search") String search);

    @Query("SELECT k.`username`,k.`user_type` FROM `user` k WHERE k.`id`=:uuid")
    User getUserName(@Param("uuid") Integer uuid);
}
