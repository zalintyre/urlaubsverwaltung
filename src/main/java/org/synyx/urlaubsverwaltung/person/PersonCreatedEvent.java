package org.synyx.urlaubsverwaltung.person;

public class PersonCreatedEvent {

    private final int personId;

    public PersonCreatedEvent(int personId) {
        this.personId = personId;
    }

    public int getPersonId() {
        return personId;
    }
}
