package neva.project_manager.repo;

import neva.project_manager.dto.SlimSelectDTO;
import neva.project_manager.model.Category;
import org.springframework.data.jdbc.repository.query.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface CategoryRepo extends CrudRepository<Category, Integer> {

    @Query("SELECT `id` AS `value`,`name` AS `text` FROM `category` WHERE `status`='active'")
    Iterable<SlimSelectDTO> searchType(@Param("search") String search);

}
