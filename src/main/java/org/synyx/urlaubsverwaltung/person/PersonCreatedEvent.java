package org.synyx.urlaubsverwaltung.person;

import org.springframework.context.ApplicationEvent;

public class PersonCreatedEvent extends ApplicationEvent {

    private final int personId;

    public PersonCreatedEvent(Object source, int personId) {
        super(source);
        this.personId = personId;
    }

    public int getPersonId() {
        return personId;
    }
}
