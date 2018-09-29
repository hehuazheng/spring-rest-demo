package hello;

import hello.service.HelloService;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

@RestController
@RequestMapping("/h")
public class HelloController {
    @Resource
    private HelloService helloService;

    @RequestMapping("/hello")
    public String hello(String name) {
        System.out.println("name: " + name);
        return helloService.hello(name);
    }
}
