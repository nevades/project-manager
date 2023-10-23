package neva.project_manager.model;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;

@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
@Table("board")

public class Board {

    @Id
    private Integer boardId;
    private String boardName;
    private String boardColor;
    private Integer projectId;
}
