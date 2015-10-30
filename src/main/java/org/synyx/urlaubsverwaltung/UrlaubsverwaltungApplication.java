package org.synyx.urlaubsverwaltung;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.velocity.VelocityAutoConfiguration;

import org.springframework.context.annotation.ImportResource;

import org.springframework.scheduling.annotation.EnableScheduling;


/**
 * Spring Boot Entry Point.
 *
 * @author  David Schilling - schilling@synyx.de
 */
@SpringBootApplication(exclude = { VelocityAutoConfiguration.class })
@EnableScheduling
@ImportResource({ "classpath:spring-security.xml", "classpath:spring-mail.xml", "classpath:h2.xml" })
public final class UrlaubsverwaltungApplication {

    private UrlaubsverwaltungApplication() {

        // OK
    }

    /**
     * Start the Urlaubsverwaltung Spring Boot application.
     *
     * @param  args  arguments
     */
    public static void main(String[] args) {

        SpringApplication.run(UrlaubsverwaltungApplication.class, args);
    }
}
