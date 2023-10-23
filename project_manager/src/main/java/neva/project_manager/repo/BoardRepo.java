package neva.project_manager.repo;

import neva.project_manager.model.Board;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface BoardRepo extends CrudRepository<Board, Integer> {

}
