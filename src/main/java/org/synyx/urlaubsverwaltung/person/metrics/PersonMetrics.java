package org.synyx.urlaubsverwaltung.person.metrics;

import io.micrometer.core.instrument.Gauge;
import io.micrometer.core.instrument.MeterRegistry;
import org.springframework.context.event.EventListener;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;
import org.synyx.urlaubsverwaltung.person.ActivePersonCountMaybeChangedEvent;
import org.synyx.urlaubsverwaltung.person.PersonCreatedEvent;
import org.synyx.urlaubsverwaltung.person.PersonDisabledEvent;
import org.synyx.urlaubsverwaltung.person.PersonService;

import java.util.concurrent.atomic.AtomicInteger;

@Component
public class PersonMetrics {

    private final PersonService personService;
    private AtomicInteger activeUsersCount;

    public PersonMetrics(MeterRegistry meterRegistry, PersonService personService) {

        this.personService = personService;
        this.activeUsersCount = new AtomicInteger(this.personService.getActivePersons().size());

        Gauge.builder("users.active", activeUsersCount, AtomicInteger::doubleValue)
            .description("number of active users")
            .register(meterRegistry);
    }

    @Async
    @EventListener(PersonCreatedEvent.class)
    public void countCreatedUser() {
        activeUsersCount.incrementAndGet();
    }

    @Async
    @EventListener(PersonDisabledEvent.class)
    public void countDisabledUser() {
        activeUsersCount.decrementAndGet();
    }

    @Async
    @EventListener(ActivePersonCountMaybeChangedEvent.class)
    public void countActiveUsers() {
        activeUsersCount.set(this.personService.getActivePersons().size());
    }
}
