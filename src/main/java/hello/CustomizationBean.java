package hello;

import org.springframework.boot.context.embedded.ConfigurableEmbeddedServletContainer;
import org.springframework.boot.context.embedded.EmbeddedServletContainerCustomizer;
import org.springframework.stereotype.Component;

/**
 * Created by hejf on 2017/7/12.
 */
@Component
public class CustomizationBean implements EmbeddedServletContainerCustomizer {

    @Override
    public void customize(ConfigurableEmbeddedServletContainer configurableEmbeddedServletContainer) {
        int port = 8080;
        try {
            String portStr = System.getProperty("port", "8080");
            port = Integer.parseInt(portStr);
        } catch (Exception e) {
            //ignore
        }
        configurableEmbeddedServletContainer.setPort(port);
    }
}
