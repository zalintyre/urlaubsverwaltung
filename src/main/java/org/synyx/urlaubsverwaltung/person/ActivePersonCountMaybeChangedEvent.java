package org.synyx.urlaubsverwaltung.person;

import org.springframework.context.ApplicationEvent;

public class ActivePersonCountMaybeChangedEvent extends ApplicationEvent {

    private final int personId;

    public ActivePersonCountMaybeChangedEvent(Object source, int personId) {
        super(source);
        this.personId = personId;
    }

    public int getPersonId() {
        return personId;
    }
}
