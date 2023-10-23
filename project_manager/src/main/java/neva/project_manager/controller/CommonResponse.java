package neva.project_manager.controller;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
public class CommonResponse {

    public CommonResponse(String message, int status) {
        this.message = message;
        this.status = status;
    }

    private String message;
    private int status;
    private Object data;

}
