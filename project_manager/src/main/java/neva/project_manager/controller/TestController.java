package neva.project_manager.controller;

import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Controller;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

@Controller
public class TestController {

    @GetMapping("/test")
    public String test() {
        return "test";
    }

    @PostMapping("/test/upload")
    @ResponseBody
    public String upload(MultipartHttpServletRequest req) throws IOException {

        String txt = req.getParameter("txt");
        MultiValueMap<String, MultipartFile> multiFileMap = req.getMultiFileMap();

        //Map<String, MultipartFile> fileMap = req.getFileMap();
        for (Map.Entry<String, List<MultipartFile>> entry : multiFileMap.entrySet()) {
            Object key = entry.getKey();
            List<MultipartFile> val = (List<MultipartFile>) entry.getValue();

            for (int i = 0; i < val.size(); i++) {
                //abc.xyz.jpg
                String[] split = val.get(i).getOriginalFilename().split("\\.");
                File des = new File("C:\\Users\\Neva\\" + new SimpleDateFormat("yyyy-MM-dd hh-mm-ss").format(new Date()) + i + "." + split[split.length - 1]);
                val.get(i).transferTo(des);
            }

        }

        return "ok";
    }

    @GetMapping("/test/view/{name}")
    @ResponseBody
    public void view(@PathVariable String name, HttpServletResponse resp) throws IOException {

        File file = new File("C:\\Users\\Neva\\" + name);

        if (!file.exists()) {
            resp.sendError(404, "file not found");
            return;
        }

        OutputStream out = resp.getOutputStream();
        FileInputStream in = new FileInputStream(file);
        byte[] buffer = new byte[4096];
        int length;
        while ((length = in.read(buffer)) > 0) {
            out.write(buffer, 0, length);
        }
        in.close();
        out.flush();

    }

}
