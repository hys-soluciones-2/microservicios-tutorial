
package com.microservicio.configuracion;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;

/**
 *
 * @author Hugo
 */
@Configuration
public class RestTemplateConfig {
    
    	@Bean
	public RestTemplate restTemplate() {
		return new RestTemplate();
        }
}
