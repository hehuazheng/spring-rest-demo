package hello;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

@SpringBootApplication
@ComponentScan(basePackages = { "hello" })
public class Application {

    public static void main(String[] args) {
        SpringApplication app = new SpringApplication(Application.class);
//        app.set
        app.run(args);
//        SpringApplication.run(Application.class, args);
    }
}
